#!/bin/csh

if ($#argv != 3) then
  echo ""
  echo "  Usage: > x.csh"
  echo "             [list of Protein oeb.gz] *mod.oeb.gz"
  echo "             [ligand library]"
  echo "             [number of CPU]"
  echo ""
  exit
endif

set pdb  = $argv[1]
set lig  = $argv[2]
set cpu  = $argv[3]

foreach oeb (`cat $pdb`)
  set name = `basename $oeb .mod.oeb.gz`
  echo " ## Running on $name"

#  timeout  3h  \
  oempirun -np $cpu \
    fred -receptor $oeb \
         -dbase    $lig \
         -prefix   $name \
         -hitlist_size 10000 \
#         -save_component_scores true \
         -docked_molecule_file $name.fred_docked.sdf \
         -score_file $name.fred_docked.txt

  echo "  ## Done with $name"
end
