#!/bin/bash 

rankFile="rank/rank_sr.csv"
ssimFile="../modelsim/ssim/ssimSR.csv"

declare -A sTss

i=0
while IFS=',' read -r stm cluster score
do
    sTr[$i]="$stm"
    ((i++))
done < <(tail -n +2 $rankFile)


while IFS=',' read -r stm2 ssim 
do
    ssim=${ssim//[^[:alnum:]^[._]]/}

    sTss[$stm2]=$ssim
done < <(tail -n +2 $ssimFile)


rm plotSingleSR.csv


for ((j=0;j<i;j++)); do
    var=${sTr[$j]}
    ssim="${sTss[$var]}"
    if [ ! -z "$ssim" ]
    then
        echo "$j, $ssim" >> "plotSingleSR.csv"
    else
        echo "Error!" 1>&2
        exit 64
    fi
done



gnuplot -p -e "set datafile separator ',';set title 'SR'; set style circle radius 1;set xlabel 'Ranking of statement tokens';set ylabel 'ssim'; set style fill solid; plot 'plotSingleSR.csv' with circles lc 'blue' notitle"

if [ "$1" = -p ]; then
    sed -i '1 i\x, ssim' "plotSingleSR.csv"
else
    rm plotSingleSR.csv
fi
