radius = 8
height = 3
-- shape = ccylinder(radius, height)
shape = load("o3plink.stl")

emit(shape)

--###########################################################

-- setting up printer settings
set_setting_value('printer', 'Prusa_MK3S')
set_setting_value('z_layer_height_mm', 0.2)

-- setting up some slicing settings
set_setting_value('infill_type_0', 'Phasor')
set_setting_value('num_shells_0', 0)
set_setting_value('cover_thickness_mm_0', 0.0)
set_setting_value('print_perimeter_0', false)

-- printing settings (for TPU, on CR-10 with Titan or Hemera direct extruder)
set_setting_value('filament_priming_mm_0',0.0)
set_setting_value('extruder_temp_degree_c_0',240.0)

set_setting_value('flow_multiplier_0',1)
set_setting_value('speed_multiplier_0',1)
set_setting_value('filament_priming_mm_0',0)

--###########################################################

-- allocating  the field as 3D textures
-- as of today all fields have to be 64x64x64
phi = tex3d_rgb8f(64, 64, 64) -- INCLINATION scales between 0 & 360 degrees
iso = tex3d_rgb8f(64, 64, 64) -- ISOTROPY (GAMMA) scales between 0 & 100%
theta = tex3d_rgb8f(64, 64, 64) -- XY DIRECTION (THETA) scales between 0 & 360 degrees
infill = tex3d_rgb8f(64, 64, 64) -- INFILL DENSITY scales between 0 & 100%

xorigin = 0.5
yorigin = 0.5
zorigin = 0.5

-- filling the 3D textures
-- values in 3D textures are always in [0,1]
-- the textures can hold up to three components
for i = 0,63 do
    for j = 0,63 do
        for k = 0,63 do
            phi:set(i,j,k, v(0, 0, 0))
            iso:set(i,j,k, v(0.5, 0.5, 0.5))
            density = 0.1 + 0.5*(math.sqrt(((i+1)/64 - xorigin)^2 +
                                            ((j+1)/64 - yorigin)^2 +
                                            ((k+1)/64 - zorigin)^2)/(0.75)) -- varies spherically from origin
            infill:set(i,j,k, v(density, density, density))
            theta:set(i,j,k, v(0.5, 0.5, 0.5))
        end
    end
end

-- binding the 3D textures to the fields
-- the binding requires a field (!), a bounding box where it is applied, and the internal name of the parameter (see tooltip in UI)
set_setting_value('phasor_infill_iso_0', iso, v(-radius,-radius,-height/2), v(radius,radius,height/2))
set_setting_value('phasor_infill_theta_0', theta, v(-radius,-radius,-height/2), v(radius,radius,height/2))
set_setting_value('phasor_infill_phi_0', phi, v(-radius,-radius,-height/2), v(radius,radius,height/2))
set_setting_value('infill_percentage_0', infill, v(-radius,-radius,-height/2), v(radius,radius,height/2))
