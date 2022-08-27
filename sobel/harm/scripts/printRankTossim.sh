#!/bin/bash 
#$1 is the signal to rank
#$2 is the signal to ssim


declare -A sTss

i=0
while IFS=';' read -r sig1 rank
do
    sTr[$i]=$sig1;
    ((i++))
done < "$1"


while IFS=';' read -r sig2 ssim 
do
    sTss[$sig2]=$ssim;
done < "$2"

touch plot.csv
j=0;
for signal in "${sTr[@]}"
do
    ssim="${sTss[$signal]}"
    if [ ! -z "$ssim" ]
    then
        echo "$j; $ssim" >> "plot.csv"
        ((j++))
    fi
done


gnuplot -p -e "set datafile separator ';'; set style circle radius 1; set style fill solid; plot 'plot.csv' with circles lc 'blue' notitle"

rm plot.csv
