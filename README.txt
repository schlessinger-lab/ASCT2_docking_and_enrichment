Enrichment Scripts are:
Job_AUC.sh 
enrich.sh
calc_logauc.py
1-graph.py

These scripts calculate the AUC and log AUC and generate a plot.

The master script that launches enrichment is job_AUC.sh and it requires all.txt and actives.txt as input.
e.g.
$./job_AUC.sh all.txt actives.txt

If *dud and *dat files are not removed between uses, errors result.


