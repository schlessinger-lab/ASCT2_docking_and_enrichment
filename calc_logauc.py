#!/usr/bin/python
import sys, os
import numpy as np
from math import log10, log
from scipy.integrate import trapz
from numpy import trapz
#DB = sys.argv[1]

f = open("enr1000.dud","r")

malistey = []
malistex = []
malistex2 = []
lines = f.readlines()

#print lines

for i in lines:
#  print i
  splited=i.split()
  xla=float(splited[0])
  xla2=float(splited[0])/1000
  #print xla, xla2
  if float(xla) < 0.01:
     xl1=log10(0.01)
     #pass
  else:
      xl1=log10(xla)
  #print xl1
  #print xla, xla2, xl1
  xl2=xl1/3
  #print xl2
  yla=float(splited[1])
  #print yla

  malistey.append(yla)
  malistex.append(xl2)
  malistex2.append(xla2)

area=trapz(malistey,malistex)
area2=trapz(malistey,malistex2)
print "AUC= %.3f  logAUC= %.3f" % (area2,area)



f.close()
