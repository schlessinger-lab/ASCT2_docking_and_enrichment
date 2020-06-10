#!/bin/csh

##########################################################################
#
#	Peter M.U. Ung @ MSSM
#	v1.0	- 15.06.16
#
#	Run Schrodinger's Glide. Optional to choose to prepare protein(s)
#	with default settings.
#
#	Require all setup files in the home directory
#	Dock precision level: HTVS or SP
#	Grid file has the extension: .grid.zip
#
##########################################################################
set script = '~/Documents/ASCT2_project/2-Enrichment/1-glide-enrichment/4-glide_enrichment_2020/1-ASCT2_outopen_structure_02-2020/0.8_vdw_scaling_enrichment_glide'
set locald = `pwd`

if ($#argv != 6) then
  echo ''
  echo '    Usage: x.csh'
  echo '             [List of Protein] [List of Ligand Database]'
  echo '             [PDB Directory] [Dock Precision (HTVS|SP)]'
  echo '             [Prepare Protein? (1|0)]'
  echo '             [Start Docking    (1|0)]'
  echo ''
  echo '    e.g.:  x.csh top10.list lig.list grid SP 0 1'
  echo ''
  exit
endif
if (! -e $script/glide-dock.HTVS_SP.template.in) then
  echo ''
  echo '    Error: Missing glide-dock.HTVS_SP.template.in'
  echo ''
  exit
endif
#if (! -e 'glide-dock.template.lsf') then
#  echo ''
#  echo '    Error: Missing glide-dock.template.lsf'
#  echo ''
#  exit
#endif

set pdb_list  = $argv[1]
set lig_list  = $argv[2]
set pdb_dir   = $argv[3]
set precision = $argv[4]
set prepare   = $argv[5]
set docking   = $argv[6]

##########################################################################
#module load schrodinger/2015-2
foreach pdb_file (`cat $pdb_list`)

  set pdb_name   = `basename $pdb_file .pdb`
  echo $pdb_name

  ## Prepare Protein/Grid for Glide
  if ($prepare == 1) then
    cd $pdb_dir

    if (! -e $locald/glide-grid_template.in) then
      echo ''
      echo '    Error: Missing glide-grid_template.in'
      echo ''
      exit
    endif
    if (-e ./glide-grid.$pdb_name.in) then
      echo "  ## Found existing grid. Skip..."
    else
      # -fix	only do H minimerization
      # -f '3' 	use OPLS3 (default in prepwizard is 2005)
      ${SCHRODINGER}/utilities/prepwizard -WAIT -SAVE -NOJOBID -NOLOCAL \
      -disulfides \
      -rehtreat \
      -captermini \
      -propka_pH '7.0' \
      -fix \
      -f '3' \
      -j $pdb_name.run \
      $pdb_file $pdb_name.maegz

      sed "s/GNAME/$pdb_name/g" $locald/glide-grid_template.in | \
      sed "s/GPROTNAME/$pdb_name.maegz/g" \
        > glide-grid.$pdb_name.in

      ${SCHRODINGER}/glide -WAIT -SAVE -NOJOBID -NOLOCAL -OVERWRITE \
        glide-grid.$pdb_name.in
    endif

    cd ..

  endif

  #up to here works and iterates.
  if ($docking == 1) then
    foreach lig_db (`cat $lig_list`)
      set lig_name = `basename $lig_db .sdf.gz`
      echo $lig_name

      if (-e $pdb_name.$lig_name\.sdfgz) then
        echo " Found previous dock $pdb_name.$lig_name . Skip..."
      else
	sed "s/GGRIDNAME/$pdb_name.zip/g" $locald/glide-dock.HTVS_SP.template.in | \
#        sed "s/GGRIDNAME/$pdb_name.grid.zip/g" $locald/glide-dock.HTVS_SP.template.in | \
        sed "s/HOMEDIR/$pdb_dir/g" | \
        sed "s/GDOCKPRECIS/$precision/g" | \
        sed "s/GLIGNAME/$lig_db/g" \
          > $pdb_name.$lig_name.in

        time ${SCHRODINGER}/glide $pdb_name.$lig_name.in \
            -WAIT -SUBLOCAL -SAVE \
            -noforce \
            -OVERWRITE \
            -HOST localhost:8 \
            -NJOBS 8

      # GLIDE stopped supporting .rept writeout since 2016-3
        $SCHRODINGER/utilities/glide_sort -norecep -o  $pdb_name.$lig_name\_sort.sdf.gz \
          -r $pdb_name.$lig_name.rept $pdb_name.$lig_name\_lib.sdfgz
          echo "Finished $pdb_name.$lig_name"
      endif
    end

  endif
  echo " Looping around..."

end
