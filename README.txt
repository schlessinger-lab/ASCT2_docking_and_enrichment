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

Scripts for Docking:

OpenEye FRED:
0_fred_multi_run.csh

Glide:
glide_run_setup_local.csh
glide-grid_template.in
glide-dock.HTVS.template.in

Final docking poses for manuscript: "Structural basis for stereospecific inhibition of ASCT2 from rational design":
Ligand pose and score files have extensions .sdf and .txt respectively.
