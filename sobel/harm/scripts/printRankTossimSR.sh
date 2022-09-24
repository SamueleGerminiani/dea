#!/bin/bash 
#$1 is the stm to rank
#$2 is the stm to ssim


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


while IFS=',' read -r stm2 ssim 
do
    #remove hidden char
    ssim=${ssim::-1}
    if [ "$stm2" = "statement" ]; then
        continue
    fi
    sTss[$stm2]=$ssim
done < "$2"

touch plot.csv
j=0;
for stm in "${sTr[@]}"
do
    ssim="${sTss[$stm]}"
    if [ ! -z "$ssim" ]
    then
        echo "$j, $ssim" >> "plot.csv"
        ((j++))
    fi
done


gnuplot -p -e "set datafile separator ','; set style circle radius 1;set xlabel 'ranking';set ylabel 'ssim'; set style fill solid; plot 'plot.csv' with circles lc 'blue' notitle"

#rm plot.csv
