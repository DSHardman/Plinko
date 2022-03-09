# Shader issues on laptop running DirectX 12
# Downloaded DX9 runtime from https://www.microsoft.com/en-us/download/confirmation.aspx?id=8109 & ran setup to fix

import pychrono.core as chrono
import pychrono.irrlicht as chronoirr
import os


# Simulation defined in here:
def dropdisc(dropx, dropy, mesh, number=1, pegradius=1, pegspacing=35, write=False):
    obj_path = 'C:/Users/dshar/OneDrive - University of Cambridge/Documents/PhD/Plinko/Simulations/Meshes/' + mesh + '.obj'
    my_system = chrono.ChSystemNSC()
    my_system.Set_G_acc(chrono.ChVectorD(0, -9810, 0)) # mm used as base length unit to import stl

    chrono.ChCollisionModel.SetDefaultSuggestedEnvelope(0.01)
    chrono.ChCollisionModel.SetDefaultSuggestedMargin(0.01)
    chrono.SetChronoDataPath("C:/Users/dshar/miniconda3/pkgs/pychrono-7.0.0-py39_0/Library/data/")

    my_system.SetSolverMaxIterations(150)

    peg_dens = 1e-6
    peg_mat = chrono.ChMaterialSurfaceNSC()
    peg_mat.SetFriction(0.2)  # Static and kinetic set simultaneously
    peg_mat.SetRestitution(0.3)
    peg_mat.SetCompliance(0)  # Normal direction: rigid
    peg_mat.SetComplianceT(0)  # Tangential direction: rigid
    # Rolling & spinning frictions & compliances are left as zero default

    disc_dens = 7e-6
    disc_mat = chrono.ChMaterialSurfaceNSC()
    disc_mat.SetFriction(0.2)
    disc_mat.SetRestitution(0.3)
    peg_mat.SetCompliance(100)  # Normal direction
    peg_mat.SetComplianceT(100)  # Tangential direction
    # disc_mat.SetDampingF(0.2)
    #disc_mat.SetCompliance(0.0000001)
    #disc_mat.SetComplianceT(0.0000001)

    # Add wall
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

    # Add disc
    # Uses 'Method A' from irrlicht/demo_IRR_collision_trimesh.py example - automatically calculates properties
    body_disc = chrono.ChBodyEasyMesh(obj_path, disc_dens, True, True, True, disc_mat)
    # Trues are for: automatically compute mass and inertia, visualise, collide

    body_disc.SetBodyFixed(False)
    body_disc.SetPos(chrono.ChVectorD(dropx, dropy, 1))
    body_disc.SetRot(chrono.Q_ROTATE_X_TO_Y)
    my_system.Add(body_disc)

    mjointC = chrono.ChLinkLockParallel()
    mjointC.Initialize(body_disc, body_wall, chrono.ChCoordsysD(chrono.ChVectorD(0, 0, 1)))
    my_system.Add(mjointC)

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

    add_peg(3.5*pegspacing, pegspacing)
    # ---------------------------------------------------------------------
    #
    #  Create an Irrlicht application to visualize the system
    #

    myapplication = chronoirr.ChIrrApp(my_system, 'Plinko Simulator', chronoirr.dimension2du(1024, 768))

    myapplication.AddTypicalSky()
    myapplication.AddTypicalCamera(chronoirr.vector3df(-20, 60, 200), chronoirr.vector3df(2*pegspacing, -2*pegspacing, 0))
    myapplication.AddLightWithShadow(chronoirr.vector3df(0, 0, 500),    # point
                                     chronoirr.vector3df(0, 0, 0),    # aimpoint
                                     2000,                 # radius (power)
                                     1000, 9000,               # near, far
                                     40)                # angle of FOV

    myapplication.AssetBindAll()
    myapplication.AssetUpdateAll()
    myapplication.AddShadowAll()

    myapplication.SetTimestep(0.001)
    myapplication.SetTryRealtime(True)

    if write:
        f = open("Path" + str(number) + ".txt", "w")
    while myapplication.GetDevice().run():
        myapplication.BeginScene()
        myapplication.DrawAll()
        for substep in range(0, 5):
            myapplication.DoStep()
        if write:
            f.write(str(body_disc.GetCoord().pos.x) + ", " + str(body_disc.GetCoord().pos.y) + "\n")
        if body_disc.GetCoord().pos.y < -5.5*pegspacing:
            return [body_disc.GetCoord().pos.x]
        myapplication.EndScene()
    if write:
        f.close()


dropdisc(120, 100, 'examplecross', write=False)
