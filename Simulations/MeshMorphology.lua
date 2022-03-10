-- Export as obj
set_service('MeshExportService') -- Service mode: slice without GUI
set_setting_value('meshing_method', 'Dual contouring')
set_setting_value('voxel_size_mm', 0.4)

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

-- Read desired file name and output gcode file
local file = assert(io.open("CounterData/CounterName.txt", "r"))
local savename = file:read()
run_service("../Simulations/Meshes/" .. savename .. ".obj")
file:close()
