# initially run in C:\Users\dshar\miniconda3\pkgs\pychrono-6.0.0-py36_0\Lib\site-packages\pychrono\demos\irrlicht
# textures seem to be referenced directly from there

import pychrono.core as chrono
import pychrono.irrlicht as chronoirr
import os

def dropdisc(dropx, dropy, number, discradius=0.008, pegradius=0.001, pegspacing=0.022):

    my_system = chrono.ChSystemNSC()

    chrono.ChCollisionModel.SetDefaultSuggestedEnvelope(0.001)
    chrono.ChCollisionModel.SetDefaultSuggestedMargin(0.01)

    my_system.SetSolverMaxIterations(70)

    peg_mat = chrono.ChMaterialSurfaceNSC()
    peg_mat.SetFriction(0.5)
    peg_mat.SetDampingF(0.2)
    peg_mat.SetCompliance(0.0000001)
    peg_mat.SetComplianceT(0.0000001)
    # peg_mat.SetRollingFriction(rollfrict_param)
    # peg_mat.SetSpinningFriction(0)
    # peg_mat.SetComplianceRolling(0.0000001)
    # peg_mat.SetComplianceSpinning(0.0000001)

    disc_mat = chrono.ChMaterialSurfaceNSC()
    disc_mat.SetFriction(0.5)
    disc_mat.SetDampingF(0.2)
    disc_mat.SetCompliance(0.0000001)
    disc_mat.SetComplianceT(0.0000001)
    # disc_mat.SetRollingFriction(rollfrict_param)
    # disc_mat.SetSpinningFriction(0)
    # disc_mat.SetComplianceRolling(0.0000001)
    # disc_mat.SetComplianceSpinning(0.0000001)

    # Add wall
    body_wall = chrono.ChBody()
    body_wall.SetBodyFixed(True)
    body_wall.SetPos(chrono.ChVectorD(2*pegspacing, -3*pegspacing, -0.003))

    body_wall.GetCollisionModel().ClearModel()
    body_wall.GetCollisionModel().AddBox(peg_mat, 0.08, 0.10, 0.001)
    body_wall.GetCollisionModel().BuildModel()
    body_wall.SetCollide(True)

    body_wall_shape = chrono.ChBoxShape()
    body_wall_shape.GetBoxGeometry().Size = chrono.ChVectorD(0.08, 0.10, 0.001)
    body_wall.GetAssets().push_back(body_wall_shape)

    body_wall_texture = chrono.ChTexture()
    body_wall_texture.SetTextureFilename('concrete.jpg')#chrono.GetChronoDataFile('textures/concrete.jpg'))
    body_wall.GetAssets().push_back(body_wall_texture)

    my_system.Add(body_wall)

    # Add disc
    body_disc = chrono.ChBodyEasyCylinder(discradius, discradius/10, 1000)

    body_disc.GetCollisionModel().ClearModel()
    body_disc.GetCollisionModel().AddCylinder(peg_mat, discradius, discradius, discradius/10)
    body_disc.GetCollisionModel().BuildModel()
    body_disc.SetCollide(True)

    body_disc.SetBodyFixed(False)
    body_disc.SetPos(chrono.ChVectorD(dropx, dropy, 0))
    body_disc.SetRot(chrono.Q_ROTATE_Y_TO_Z)
    my_system.Add(body_disc)

    mjointC = chrono.ChLinkLockParallel()
    mjointC.Initialize(body_disc, body_wall, chrono.ChCoordsysD(chrono.ChVectorD(0, 0, 1)))
    my_system.Add(mjointC)


    def add_peg(x,y):
        body_peg = chrono.ChBodyEasyCylinder(pegradius, pegradius*10, 1000)

        body_peg.GetCollisionModel().ClearModel()
        body_peg.GetCollisionModel().AddCylinder(peg_mat, pegradius, pegradius, pegradius*10)
        body_peg.GetCollisionModel().BuildModel()
        body_peg.SetCollide(True)

        body_peg.SetBodyFixed(True)
        body_peg.SetPos(chrono.ChVectorD(x, y, 0))
        body_peg.SetRot(chrono.Q_ROTATE_Y_TO_Z)
        my_system.Add(body_peg)

    for i in range(5):
        for j in range(4):
            add_peg(i*pegspacing, -j*2*pegspacing)

    for i in range(4):
        for j in range(3):
            add_peg(i*pegspacing+pegspacing/2, -j*2*pegspacing-pegspacing)
    # ---------------------------------------------------------------------
    #
    #  Create an Irrlicht application to visualize the system
    #

    myapplication = chronoirr.ChIrrApp(my_system, 'Plinko Simulator', chronoirr.dimension2du(1024, 768))

    myapplication.AddTypicalSky()
    myapplication.AddTypicalCamera(chronoirr.vector3df(0, 0, 0.2), chronoirr.vector3df(2*pegspacing, -3*pegspacing, 0))
    myapplication.AddLightWithShadow(chronoirr.vector3df(0, 0, 0.5),    # point
                                     chronoirr.vector3df(0, 0, 0),    # aimpoint
                                     20,                 # radius (power)
                                     1, 9,               # near, far
                                     30)                # angle of FOV

    myapplication.AssetBindAll()
    myapplication.AssetUpdateAll()
    myapplication.AddShadowAll()

    myapplication.SetTimestep(0.001)
    myapplication.SetTryRealtime(True)
    #f = open("Path" + str(number) + ".txt", "w")
    while myapplication.GetDevice().run():
        myapplication.BeginScene()
        myapplication.DrawAll()
        for substep in range(0, 5):
            myapplication.DoStep()
        #f.write(str(body_disc.GetCoord().pos.x) + ", " + str(body_disc.GetCoord().pos.y) + "\n")

        if body_disc.GetCoord().pos.y < -6*pegspacing:
            return [1, body_disc.GetCoord().pos.x]
        elif body_disc.GetCoord().pos.x < 0:
            return [2, body_disc.GetCoord().pos.y]
        elif body_disc.GetCoord().pos.x > 4*pegspacing:
            return [3, body_disc.GetCoord().pos.y]
        myapplication.EndScene()
    #f.close()


# for i in range(13):
#     for j in range(21):
#         dropdisc(0.03+i*0.0005, 0.0005*j, i*21+j+1, 0.001)

dropdisc(0.03, 0.002, 3, 0.007)  # evidence of periodicity
