#!/bin/bash
#05-7-19 rachel edits

USAGE="ERROR:
This script calculates AUC curves from two input files:
1) the docking compounds ranked and 2) the active compounds."

if [[ $# -lt 2 ]] ; then #if you have less than the 2 file requirements then it will show an error.

  echo "$USAGE"
  exit 1

fi
##################################################################
######less $dataSet | wc -l | LANG=C awk '{print $1}'` Reads through the all.txt file
### and sees how many lines aka compounds were docked.
### it is repeated to count the actives.
### And then the number of non relevant docked cmpds is calculated from the subtraction of the 2 figures.
dataSet=$1 #all.txt
activeSet=$2 #actives.txt
dataNb=`less $dataSet | wc -l | LANG=C awk '{print $1}'`
echo "Total : $dataNb"  #this prints it on screen

activeNb=`less $activeSet | wc -l | LANG=C awk '{print $1}'`
echo "Active : $activeNb"

inactiveNb=`expr $dataNb - $activeNb`
echo "Inactive : $inactiveNb"
###################################################################

col1=""
col2=""
coordinates=""
activesFound=0
activesNotFound=0
inactivesFound=0
inactivesNotFound=0
testauc=0
auc=0
logauc=0
toto=0
count=1
echo "0.00 0.00" >> enr1000.dud
echo "0.00 0.00" >> enr.dud
while [[ $count -le $dataNb ]] ; do

  item=`less $dataSet | sed -n "$count"p`
  # echo "item : $item"

  if [[ $count -le $activeNb && "`less $activeSet | grep -w $item`" != "" ]] ; then
    activesFound=`expr $activesFound + 1`
  elif [[ $count -gt $activeNb && "`less $activeSet | grep -w $item`" != "" ]] ; then
    activesNotFound=`expr $activesNotFound + 1`
  elif [[ $count -le $activeNb && "`less $activeSet | grep -w $item`" == "" ]] ; then
    inactivesNotFound=`expr $inactivesNotFound + 1`
  elif [[ $count -gt $activeNb && "`less $activeSet | grep -w $item`" == "" ]] ; then
    inactivesFound=`expr $inactivesFound + 1`

  fi
#-le       is less than or equal to

  dat=`echo "$count $dataNb $activesFound $activesNotFound $activeNb" | LANG=C awk '{printf("%.2f\t%.2f\n", ($1/$2)*1000, (($3+$4)/$5)*100)}'`
  echo $dat >> enr1000.dud
  dat=`echo "$count $dataNb $activesFound $activesNotFound $activeNb" | LANG=C awk '{printf("%.2f\t%.2f\n", ($1/$2)*100, (($3+$4)/$5)*100)}'`
  echo $dat >> enr.dud
  count=`expr $count + 1`

done
 
#p is prompt with what follows
# #Similar to more, less command allows you to view the contents of a file and navigate through file. The main difference between more and less is that less command is faster because it does not load the entire file
# #at once and allows navigation though file using page up/down keys.

# the LANG environment variable controls localization.
#It affects many standard command-line tools like sort, grep, awk.
#Setting its value to "C" tells all those tools to consider only basic ASCII characters and disable UTF-8 multibyte match.