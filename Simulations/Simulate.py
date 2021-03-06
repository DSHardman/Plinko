# Shader issues on laptop running DirectX 12
# Downloaded DX9 runtime from https://www.microsoft.com/en-us/download/confirmation.aspx?id=8109 & ran setup to fix

import pychrono.core as chrono
import pychrono.irrlicht as chronoirr
import numpy as np


# Simulation defined and run in here:
def drop_disc(mesh, dropx=0.1, dropy=0, sliderspeed=3.0, sliderend=0.0, rotation=0, restitution=0.2, maxsteps=5000, friction=0.2,
              stoplevel=4, write=False, visualise=False):

    # Defaults
    pegradius = 1
    pegspacing = 35
    timestep = 0.001

    # NSC system setup
    obj_path = 'C:/Users/dshar/OneDrive - University of Cambridge/Documents/PhD/Plinko/Simulations/Meshes/' + mesh + '.obj'
    my_system = chrono.ChSystemNSC()
    my_system.Set_G_acc(chrono.ChVectorD(0, -9810, 0))  # mm used as base length unit to import stl

    #chrono.ChCollisionModel.SetDefaultSuggestedEnvelope(0.00001)
    #chrono.ChCollisionModel.SetDefaultSuggestedMargin(0.00001)
    chrono.SetChronoDataPath("C:/Users/dshar/miniconda3/pkgs/pychrono-7.0.0-py39_0/Library/data/")

    my_system.SetSolverMaxIterations(150)

    # Material setup
    peg_dens = 7.9e-6
    peg_mat = chrono.ChMaterialSurfaceNSC()
    peg_mat.SetFriction(friction)  # Static and kinetic set simultaneously
    peg_mat.SetRestitution(restitution)
    peg_mat.SetCompliance(0)  # Normal direction: rigid
    peg_mat.SetComplianceT(0)  # Tangential direction: rigid
    # Rolling & spinning friction & compliance are left as zero default

    disc_dens = 1e-6
    disc_mat = chrono.ChMaterialSurfaceNSC()
    disc_mat.SetFriction(friction)
    disc_mat.SetRestitution(restitution)
    # Compliance not explicitly considered

    # Add back wall
    body_wall = chrono.ChBody()
    body_wall.SetBodyFixed(True)
    body_wall.SetPos(chrono.ChVectorD(3.5*pegspacing, -2*pegspacing, -3))

    body_wall.GetCollisionModel().ClearModel()
    body_wall.GetCollisionModel().AddBox(peg_mat, 4.5*pegspacing, 4*pegspacing, 1)
    body_wall.GetCollisionModel().BuildModel()
    body_wall.SetCollide(True)

    body_wall_shape = chrono.ChBoxShape()
    body_wall_shape.GetBoxGeometry().Size = chrono.ChVectorD(4.5*pegspacing, 4*pegspacing, 1)
    body_wall.GetAssets().push_back(body_wall_shape)

    body_wall_texture = chrono.ChTexture()
    body_wall_texture.SetTextureFilename('concrete.jpg')
    body_wall.GetAssets().push_back(body_wall_texture)

    my_system.Add(body_wall)

    # Add side walls
    for i in range(2):
        body_side = chrono.ChBody()
        body_side.SetBodyFixed(True)
        body_side.SetPos(chrono.ChVectorD(i*9*pegspacing - pegspacing, -2*pegspacing, 5))

        body_side.GetCollisionModel().ClearModel()
        body_side.GetCollisionModel().AddBox(peg_mat, 3, 4*pegspacing, 10)
        body_side.GetCollisionModel().BuildModel()
        body_side.SetCollide(True)

        body_side_shape = chrono.ChBoxShape()
        body_side_shape.GetBoxGeometry().Size = chrono.ChVectorD(3, 4*pegspacing, 10)
        body_side.GetAssets().push_back(body_side_shape)

        body_side_texture = chrono.ChTexture()
        body_side_texture.SetTextureFilename('concrete.jpg')
        body_side.GetAssets().push_back(body_side_texture)

        my_system.Add(body_side)

    # Add top wall
    body_top = chrono.ChBody()
    body_top.SetBodyFixed(True)
    body_top.SetPos(chrono.ChVectorD(5.75*pegspacing+7.5+sliderend, pegspacing+54, 5))

    body_top.GetCollisionModel().ClearModel()
    body_top.GetCollisionModel().AddBox(peg_mat, 2.25*pegspacing-7.5, 3, 10)
    body_top.GetCollisionModel().BuildModel()
    body_top.SetCollide(True)

    body_top_shape = chrono.ChBoxShape()
    body_top_shape.GetBoxGeometry().Size = chrono.ChVectorD(2.25*pegspacing-7.5, 3, 10)
    body_top.GetAssets().push_back(body_top_shape)

    body_top_texture = chrono.ChTexture()
    body_top_texture.SetTextureFilename('concrete.jpg')
    body_top.GetAssets().push_back(body_top_texture)

    my_system.Add(body_top)

    # Add slider
    body_slider = chrono.ChBody()
    body_slider.SetBodyFixed(False)
    body_slider.SetPos(chrono.ChVectorD(6*pegspacing, pegspacing+90, 5))

    body_slider.GetCollisionModel().ClearModel()
    body_slider.GetCollisionModel().AddBox(peg_mat, 3, 30, 10)
    body_slider.GetCollisionModel().BuildModel()
    body_slider.SetCollide(True)

    body_slider_shape = chrono.ChBoxShape()
    body_slider_shape.GetBoxGeometry().Size = chrono.ChVectorD(3, 30, 10)
    body_slider.GetAssets().push_back(body_slider_shape)

    body_slider_texture = chrono.ChTexture()
    body_slider_texture.SetTextureFilename('concrete.jpg')
    body_slider.GetAssets().push_back(body_slider_texture)

    my_system.Add(body_slider)

    # Add slider motion
    link_slider = chrono.ChLinkLockLock()
    link_slider.Initialize(body_slider, body_top, chrono.CSYSNORM)
    my_system.Add(link_slider)

    my_func = chrono.ChFunction_Ramp(0, -100*sliderspeed)
    link_slider.SetMotion_X(my_func)

    # Add disc
    # Uses 'Method A' from irrlicht/demo_IRR_collision_trimesh.py example - automatically calculates properties
    body_disc = chrono.ChBodyEasyMesh(obj_path, disc_dens, True, True, True, disc_mat)
    # Trues are for: automatically compute mass and inertia, visualise, collide

    body_disc.SetBodyFixed(False)
    # body_disc.SetPos(chrono.ChVectorD(122.5+dropx, 105+dropy, 1))
    body_disc.SetPos(chrono.ChVectorD(5.5*pegspacing, 116, 1))
    body_disc.SetRot(chrono.Q_ROTATE_X_TO_Y)
    body_disc.SetRot(chrono.ChMatrix33D(rotation, chrono.ChVectorD(0, 0, 1)))
    my_system.Add(body_disc)

    # Constrain disc parallel to back wall
    mjointC = chrono.ChLinkLockParallel()
    mjointC.Initialize(body_disc, body_wall, chrono.ChCoordsysD(chrono.ChVectorD(0, 0, 1)))
    my_system.Add(mjointC)

    # Define pegs
    def add_peg(x, y):
        body_peg = chrono.ChBodyEasyCylinder(pegradius, pegradius*10, peg_dens)

        body_peg.GetCollisionModel().ClearModel()
        body_peg.GetCollisionModel().AddCylinder(peg_mat, pegradius, pegradius, pegradius*10)
        body_peg.GetCollisionModel().BuildModel()
        body_peg.SetCollide(True)

        body_peg.SetBodyFixed(True)
        body_peg.SetPos(chrono.ChVectorD(x, y, 0))
        body_peg.SetRot(chrono.Q_ROTATE_Y_TO_Z)
        my_system.Add(body_peg)

    for i in range(8):
        for j in range(3):
            add_peg(i*pegspacing, -j*2*pegspacing)

    for i in range(7):
        for j in range(2):
            add_peg(i*pegspacing+pegspacing/2, -j*2*pegspacing-pegspacing)

    # Top peg
    add_peg(3.5*pegspacing, pegspacing)

    # Setup Irrlicht engine
    if visualise:
        myapplication = chronoirr.ChIrrApp(my_system, 'Plinko Simulator', chronoirr.dimension2du(1024, 768))
        myapplication.SetTimestep(timestep)
        myapplication.AddTypicalSky()
        myapplication.AddTypicalCamera(chronoirr.vector3df(-20, 60, 200), chronoirr.vector3df(2*pegspacing, -1*pegspacing, 0))
        myapplication.AddLightWithShadow(chronoirr.vector3df(0, 0, 500),    # point
                                         chronoirr.vector3df(0, 0, 0),    # aimpoint
                                         2000,                 # radius (power)
                                         1000, 9000,           # near, far
                                         40)                   # angle of FOV

        myapplication.AssetBindAll()
        myapplication.AssetUpdateAll()
        myapplication.AddShadowAll()
        myapplication.SetTryRealtime(True)

    if write:
        f = open("Path.txt", "w")
    for n in range(maxsteps):  # Maximum number of steps
        if visualise:
            myapplication.BeginScene()
            myapplication.DrawAll()
            for substep in range(0, 5):
                myapplication.DoStep()
        else:
            my_system.DoStepDynamics(timestep)
        if write:
            f.write(str(body_disc.GetCoord().pos.x) + ", " + str(body_disc.GetCoord().pos.y) + "\n")
        # Exit when bottom of board is reached
        if body_disc.GetCoord().pos.y < -stoplevel*pegspacing:
            if write:
                f.close()
            return [body_disc.GetCoord().pos.x - 122.5]
        if visualise:
            myapplication.EndScene()
    print('Maximum number of steps reached: ending simulation.')
    return np.nan


def output_repeatability(mesh, stoplevel=4):
    # dropxs = [0.1, 1.1, 2.1]
    # dropys = [-1, 0, 1]
    # rotations = [-np.pi/36, 0, np.pi/36]
    # restitutions = [0.2, 0.3, 0.4]
    #
    # positions = [0]*(3**4)
    #
    # for i in range(3):
    #     for j in range(3):
    #         for k in range(3):
    #             for m in range(3):
    #                 position = drop_disc(mesh, dropxs[i], dropys[j], rotations[k], restitutions[m])
    #                 if position is None:
    #                     position = [np.nan]
    #                 positions[m + 3*k + 9*j + 27*i] = (dropxs[i], dropys[j], rotations[k],
    #                                                    restitutions[m], position[0])
    #                 print(m + 3*k + 9*j + 27*i)

    sliderspeeds = [2.5, 3.0, 3.5, 4.0]
    sliderends = [-1.0, -0.5, 0.5, 1.0]
    restitutions = [0.2, 0.275, 0.35, 0.4]

    positions = []

    for i in range(4):
        for j in range(4):
            for k in range(4):
                position = drop_disc(mesh, sliderspeed=sliderspeeds[i], sliderend=sliderends[j],
                                     restitution=restitutions[k], stoplevel=stoplevel)
                if position is None:
                    position = [np.nan]

                positions.append([sliderspeeds[i], sliderends[j], restitutions[k], position[0]])

                print(k + 4*j + 16*i)

    np.save('C:/Users/dshar/OneDrive - University of Cambridge/Documents/PhD/Plinko/Simulations/Meshes/' + mesh,
            positions)

output_repeatability('simulated', 0)