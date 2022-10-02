#!/bin/bash 

rankFile="rank/rank_vbr.csv"
ssimFile="../simulator/ssim/ssimVBR.csv"


declare -A sTss

i=0
while IFS=',' read -r var1 size bit cluster score
do
    sTr[$i]="$var1[$bit]"
    ((i++))
done < <(tail -n +2 $rankFile)


while IFS=',' read -r var2 ssim 
do
    #remove hidden char
    ssim=${ssim//[^[:alnum:]^[._]]/}

    sTss[$var2]=$ssim
done < <(tail -n +2 $ssimFile)

rm plotSingleVBR.csv

for ((j=0;j<i;j++)); do
    var=${sTr[$j]}
    ssim="${sTss[$var]}"
    if [ ! -z "$ssim" ]
    then
        echo "$j, $ssim" >> "plotSingleVBR.csv"
    else
        echo "Error!" 1>&2
        exit 64
    fi
done


gnuplot -p -e "set datafile separator ',';set title 'VBR'; set style circle radius 1;set xlabel 'Ranking of bit tokens';set ylabel 'SSIM'; set style fill solid; plot 'plotSingleVBR.csv' with circles lc 'blue' notitle"

if [ "$1" = -p ]; then
    sed -i '1 i\x, ssim' "plotSingleVBR.csv"
else
    rm plotSingleVBR.csv
fi
