# CS 61 - Final Project
# Database Systems
# Carter Kruse

from connect import *
from grid_search import *
from implement import *

import time
start = time.time()
print()

features, target = connect()
# grid_search(features, target)
# implement(features, target)

end = time.time()
print()
print("Time: " + str(round(end - start, 2)) + "Seconds")
