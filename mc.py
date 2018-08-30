#!/usr/bin/env python

from matplotlib import pyplot as plt
import numpy as np

class System(object):

    def __init__(self, p=None, N=100, box_length=3.0):
        
        if p is None:
            self.positions = np.array([np.random.rand(3) for __ in range(N)])
        else:
            self.positions = np.array(p)

        self.box_length = box_length
            

def permutate(system, dr=1.0):
    pos = system.positions
    for i in range(len(list(pos))):
        pos[i] += dr*(1.0 - 2.0 * np.random.rand(3))
        for d in range(3):
            if pos[i,d] > system.box_length:
                pos[i,d] -= system.box_length
            elif pos[i,d] < 0.0:
                pos[i,d] += system.box_length
    return System(p=pos)

def get_distance(system, ri, rj):
    dr = np.subtract(ri, rj)
    dist2 = np.dot(dr, dr)
    return float(dist2) ** 0.5

def lennard_jones(r):
    return r#np.power(r,-12.0) - np.power(r, -6.0)

potential = lennard_jones

def energy(system):
    tot = 0.0
    for i, ri in enumerate(list(system.positions)):
        for j, rj in enumerate(list(system.positions)[:i]):
            tot += potential(get_distance(system, ri, rj) )
    return tot

if __name__ == "__main__":
    system = System()

    res = list()
    for i in range(1000):
        if i % 10 == 0: print(i)
        new_system = permutate(system)

        p_new = energy(new_system)
        p_old = energy(system)
        p_ratio = p_new / p_old

        if p_ratio > 1.0 or np.random.random() < p_ratio:
            res.append(p_new)
            system = new_system

    plt.hist(res, bins=100)
    plt.show()
