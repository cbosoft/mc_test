#!/usr/bin/env python

from matplotlib import pyplot as plt

with open("data.csv") as df:
    data = [f for f in df.read().split('\n') if f]
    data = [float(d) for d in data]

f, (axh, axp) = plt.subplots(2)
axp.plot(data)
axh.hist(data, bins=100)
plt.show()
