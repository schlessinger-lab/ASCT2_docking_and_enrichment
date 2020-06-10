#!/usr/bin/python

import os
import matplotlib
matplotlib.use('Agg')
import pylab
from math import log10
l = []
x = []
y = []
w = []
j = 0
for file in os.listdir('.'): #for each file in this directory
	if file.endswith("enr.dud"):
		k= open(file)
		for line in k:
			l.append('empty')
			x.append('empty')
			y.append('empty')
			w.append('empty')
			l[j] = line.split(None,2)
			x[j] = l[j][0]
			y[j] = l[j][1]

			if x[j] is "empty":
				pass
			else:
				if float(x[j]) < 0.01:
					w[j] = log10(0.01)
					pass
				else:
					w[j] = log10(float(x[j]))
					#print w[j]

			j = j+1


for file in os.listdir('.'): #for each file in this directory
	if file.endswith(".dat"):
		p= open(file)
		for line in p:
	  		a = line.split(None,4)


pylab.figure(1, figsize=(10,20))
pylab.subplot(211)
#pylab.xlabel('% of ranked database')
#pylab.ylabel('% of known ligands found')
pylab.plot(x, y, color='darkviolet', linewidth=2, label='Model')
pylab.plot(x, x, color='slategray', linewidth=2, label='Random', linestyle='--')
#pylab.legend(loc=2)
pylab.text(80, 2, a[0]+' '+a[1], fontsize=14)
pylab.savefig('enrichment_profile.png', dpi=300)

pylab.subplot(212)
#pylab.xlabel('% of ranked database')
#pylab.ylabel('% of known ligands found')
pylab.plot(x, y, color='darkviolet', linewidth=2, label='Model')
pylab.plot(x, x, color='slategray', linewidth=2, label='Random', linestyle='--')
pylab.xscale('log')
#pylab.legend(loc=2)
pylab.text(10.5, 2, a[2]+' '+a[3], fontsize=14)
pylab.savefig('enrichment_profile.png', dpi=300)
