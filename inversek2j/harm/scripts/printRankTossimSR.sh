#!/bin/bash 
#$1 is the stm to rank
#$2 is the stm to rae


declare -A sTss

i=0
while IFS=',' read -r stm cluster score
do
    if [ "$stm" = "statement" ]; then
        continue
    fi
    sTr[$i]="$stm"
    ((i++))
done < "$1"


while IFS=',' read -r stm2 rae 
do
    rae=${rae//[^[:alnum:]^[._]]/}
    if [ "$stm2" = "statement" ]; then
        continue
    fi
    sTss[$stm2]=$rae
done < "$2"

rm plot.csv

for ((j=0;j<i;j++)); do
    stm=${sTr[$j]}
    rae="${sTss[$stm]}"
    if [ ! -z "$rae" ]
    then
        echo "$j, $rae" >> "plot.csv"
    else
        echo "Error!" 1>&2
        exit 64
    fi
done


gnuplot -p -e "set datafile separator ','; set style circle radius 1;set xlabel 'ranking';set ylabel 'rae'; set style fill solid; plot 'plot.csv' with circles lc 'blue' notitle"

rm plot.csv