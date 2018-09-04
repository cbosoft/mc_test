#!/usr/bin/env python
import sys
from matplotlib import pyplot as plt
import numpy as np

data = [f for f in sys.stdin if f]
data = [[float(a) for a in d.split(',')] for d in data]
data = list(zip(*data))

f, axes = plt.subplots(len(data), 1, squeeze=False)

for i, d in enumerate(data):
    bins, edges = np.histogram(d)
    axes[i, 0].plot(edges[1:], bins, 'o--')
    #axes[i, 1].hist(d, bins=100)
    
plt.show()
