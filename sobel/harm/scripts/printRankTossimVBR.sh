#!/bin/bash 
#$1 is the var to rank
#$2 is the var to ssim


declare -A sTss

i=0
while IFS=',' read -r var1 size bit cluster score
do
    if [ "$var1" = "var" ]; then
        continue
    fi
    sTr[$i]="$var1[$bit]"
    ((i++))
done < "$1"


while IFS=',' read -r var2 ssim 
do
    #remove hidden char
    ssim=${ssim//[^[:alnum:]^[._]]/}

    if [ "$var2" = "var" ]; then
        continue
    fi
    sTss[$var2]=$ssim
done < "$2"

rm plot.csv

for ((j=0;j<i;j++)); do
    var=${sTr[$j]}
    ssim="${sTss[$var]}"
    if [ ! -z "$ssim" ]
    then
        echo "$j, $ssim" >> "plot.csv"
    else
        echo "Error!" 1>&2
        exit 64
    fi
done


gnuplot -p -e "set datafile separator ','; set style circle radius 1;set xlabel 'ranking';set ylabel 'ssim'; set style fill solid; plot 'plot.csv' with circles lc 'blue' notitle"

rm plot.csv
