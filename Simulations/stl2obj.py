import sys
import trimesh

mesh = trimesh.load_mesh('Meshes/' + sys.argv[1] + '.stl')
obj_string = trimesh.exchange.obj.export_obj(mesh)
f = open("Meshes/" + sys.argv[1] + ".obj", "w")
f.write(obj_string)
f.close()
