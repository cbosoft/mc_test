#!/usr/bin/env python

import math

from matplotlib import pyplot as plt
import numpy as np

class System(object):

    def __init__(self, sys=None):
        if sys is None:
            self.positions = None
            self.box_length = None
        else:
            self.positions = sys.positions
            self.box_length = sys.box_length
        
    def init(self, N=3, box_length=3.0):

        rcell = float(box_length) / float(N)

        positions = list()
        for i in range(N):
            for j in range(N):
                for k in range(N):
                    positions.append(np.array([i*rcell, j*rcell, k*rcell]))
        print(len(positions))
        self.positions = np.array(positions)
        self.box_length = box_length
            

def permutate(system, dr=1.0):
    pos = system.positions
    i = math.floor(np.random.random()*len(pos))
    pos[i] += dr*(1.0 - 2.0 * np.random.rand(3))
    for d in range(3):
        if pos[i,d] > system.box_length:
            pos[i,d] -= system.box_length
        elif pos[i,d] < 0.0:
            pos[i,d] += system.box_length
    rv = System(system)
    rv.positions = pos
    return rv


def get_distance(system, ri, rj):
    dr = np.subtract(ri, rj)
    dist2 = np.dot(dr, dr)
    return float(dist2) ** 0.5

def lennard_jones(r):
    return np.power(r,-12.0) - 2.0*np.power(r, -6.0)

def yukawa(r):
    rinv = 1.0/r
    return rinv*np.exp(rinv)

potential = yukawa

def energy(system):
    tot = 0.0
    for i, ri in enumerate(list(system.positions)):
        for j, rj in enumerate(list(system.positions)[:i]):
            tot += potential(get_distance(system, ri, rj) )
    return tot

if __name__ == "__main__":
    system = System()
    system.init()

    res = list()
    T = 100000
    for t in range(T):
        perc = int(100.0*float(t)/float(T))
        if perc % 10 == 0: print(f"\r{perc}%", flush=True, end='')
        new_system = permutate(system)

        p_new = np.exp(-energy(new_system))
        p_old = np.exp(-energy(system))
        p_ratio = p_new / p_old

        if p_ratio >= 1.0 or np.random.random() <= p_ratio:
            res.append(p_new)
            system = new_system
    print("\r100% done!")
    plt.hist(res, bins=100)
    plt.show()
