from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import numpy as np
import sys

fig = plt.figure()
ax = fig.gca(projection='3d')

f = open("/home/pranav/Desktop/ddp/data/"+sys.argv[1])
x=[]
y=[]
z=[]
for line in f:
	l = line.split()
	x.append(float(l[0]))
	y.append(float(l[1]))
	z.append(float(l[2])*1000)

x, y = np.meshgrid(x, y)

#print x
#print y
# Plot the surface.
surf = ax.plot_surface(x, y, z, cmap=cm.coolwarm,linewidth=0, antialiased=False)

# Customize the z axis.
#ax.set_zlim(-1.01, 1.01)
#ax.zaxis.set_major_locator(LinearLocator(10))
#ax.zaxis.set_major_formatter(FormatStrFormatter('%.02f'))

# Add a color bar which maps values to colors.
fig.colorbar(surf, shrink=0.5, aspect=5)
plt.xlabel("n way divergence")
plt.ylabel("Barrier count")
#plt.zlabel("Time in microseconds")
plt.show()

