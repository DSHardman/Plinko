-- setting up printer settings
set_service('FilamentSlicer') -- Service mode: slice without GUI
-- set_service('MeshExportService') -- Service mode: slice without GUI

set_setting_value('printer', 'Prusa_MK3S')
set_setting_value('z_layer_height_mm', 0.3)

-- setting up some slicing settings
set_setting_value('infill_type_0', 'Phasor')
set_setting_value('num_shells_0', 0)
set_setting_value('cover_thickness_mm_0', 0.0)
set_setting_value('print_perimeter_0', false)
set_setting_value('add_brim', false)

-- printing settings (for TPU, on CR-10 with Titan or Hemera direct extruder)
set_setting_value('filament_priming_mm_0',0.0)
set_setting_value('extruder_temp_degree_c_0',240.0)

set_setting_value('flow_multiplier_0',1)
set_setting_value('speed_multiplier_0',1)
set_setting_value('filament_priming_mm_0',0)

height = 3 -- This cannot be changed externally

-- Read and generate counter morphology from file
local MATCH_PATTERN = "[^,]+"
local file = assert(io.open("CounterData/circles.txt", "r"))
n = 1
for line in file:lines() do
    local row = {}
    for match in string.gmatch(line, MATCH_PATTERN) do
        table.insert(row, tonumber(match))
    end
    if n == 1 then -- first row contains radius of counter
        radius = row[3]
        c = cylinder(radius, v(0, 0, -height/2), v(0, 0, height/2))
    elseif n == 2 then -- second row contains location of payload hole
        c = difference(c,cylinder(5, v(row[1], row[2], -height/2), v(row[1], row[2], height/2)))
        hole = row
    else -- all other rows are subtractive
        c = difference(c, cylinder(row[3], v(row[1], row[2], -height/2), v(row[1], row[2], height/2)))
    end
    n = n + 1
end
file:close()

-- Maintain a solid 2mm border around the payload, and emit shape
emit(union(c, difference(cylinder(7, v(hole[1], hole[2], -height/2), v(hole[1], hole[2], height/2)),
                         cylinder(5, v(hole[1], hole[2], -height/2), v(hole[1], hole[2], height/2)))))

-- Initialise the phasor infill fields
phi = tex3d_rgb8f(64, 64, 64) -- INCLINATION scales between 0 & 360 degrees
theta = tex3d_rgb8f(64, 64, 64) -- XY DIRECTION (F) scales between 0 & 360 degrees
infill = tex3d_rgb8f(64, 64, 64) -- INFILL DENSITY scales between 0 & 100%
iso = tex3d_rgb8f(64, 64, 64) -- ISOTROPY (GAMMA) scales between 0 & 100% - THIS IS SET AS ZERO HERE

-- Read inclination values from file and implement
local file = assert(io.open("CounterData/inclination.txt", "r"))
local arr1 = {}
for line in file:lines() do
    local row = {}
    for match in string.gmatch(line, MATCH_PATTERN) do
        table.insert(row, tonumber(match))
    end
    table.insert(arr1, row)
end
file:close()

-- Read theta values from file and implement
local file = assert(io.open("CounterData/theta.txt", "r"))
local arr2 = {}
for line in file:lines() do
    local row = {}
    for match in string.gmatch(line, MATCH_PATTERN) do
        table.insert(row, tonumber(match))
    end
    table.insert(arr2, row)
end
file:close()

-- Read density values from file and implement
local file = assert(io.open("CounterData/density.txt", "r"))
local arr3 = {}
for line in file:lines() do
    local row = {}
    for match in string.gmatch(line, MATCH_PATTERN) do
        table.insert(row, tonumber(match))
    end
    table.insert(arr3, row)
end
file:close()

-- values in 3D textures are always in [0,1]
for i = 0,63 do
    for j = 0,63 do
        for k = 0,63 do
            phi:set(i,j,k, v(arr1[i+1][j+1], arr1[i+1][j+1], arr1[i+1][j+1]))
            theta:set(i,j,k, v(arr2[i+1][j+1], arr2[i+1][j+1], arr2[i+1][j+1]))
            infill:set(i,j,k, v(arr3[i+1][j+1], arr3[i+1][j+1], arr3[i+1][j+1]))

            iso:set(i,j,k, v(0, 0, 0)) -- Isotropy is set to zero throughout
        end
    end
end

-- Bind the 3D textures to the phasor fields
set_setting_value('phasor_infill_iso_0', iso, v(-radius,-radius,-height/2), v(radius,radius,height/2))
set_setting_value('phasor_infill_theta_0', theta, v(-radius,-radius,-height/2), v(radius,radius,height/2))
set_setting_value('phasor_infill_phi_0', phi, v(-radius,-radius,-height/2), v(radius,radius,height/2))
set_setting_value('infill_percentage_0', infill, v(-radius,-radius,-height/2), v(radius,radius,height/2))

-- Read desired file name and output gcode file
local file = assert(io.open("CounterData/CounterName.txt", "r"))
local savename = file:read()
run_service(savename .. ".gcode")
file:close()
