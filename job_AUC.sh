#!/bin/bash
 

./enrich.sh all.txt actives.txt
./calc_logauc.py > AUC.dat
for name in *fred_docked.txt; do                                 
    echo $name #checks to see if the right files are pulled.                                        
    mv enr1000.dud  "${name%.oeb.gz.fred_docked.txt}".dud
    mv enr.dud  "${name%.oeb.gz.fred_docked.txt}"_enr.dud
    mv AUC.dat "${name%.oeb.gz.fred_docked.txt}"_AUC.dat
    more "${name%.oeb.gz.fred_docked.txt}"_AUC.dat
done
./1-graph.py
for name in *dat; do
    sed -i "s/$/"_${name%.dat}"/" "$name" #this adds the thing to the end of the line.
    mv enrichment_profile.png "${name%.dat}"_enrichment_plot.png
    done
