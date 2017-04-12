import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import random
import sys

f = open("/home/pranav/Desktop/ddp/data/"+sys.argv[1])
xs=[]
ys=[]
zs=[]
for line in f:
	l = line.split()
	xs.append(float(l[0]))
	ys.append(float(l[1]))
	zs.append(float(l[2])*1000)


fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

ax.scatter(xs, ys, zs)

ax.set_xlabel('n way coalescing')
ax.set_ylabel('sync atomic operations')
ax.set_zlabel('Time in microseconds')

plt.show()
