import Simulate
import sys

position = Simulate.drop_disc(sys.argv[1], visualise=bool(int(sys.argv[2])))
