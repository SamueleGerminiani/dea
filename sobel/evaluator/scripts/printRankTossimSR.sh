#!/bin/bash 

rankFile="rank/rank_sr.csv"
ssimFile="../simulator/ssim/ssimSR.csv"

if [ "$1" = "2d" ]; then
    #=====================2D==========================
    declare -A tokenToSSIM
    declare -A rankToToken

#used to assign IDs to the tokens
i=0
while IFS=',' read -r stm1 cluster score
do
    rankToToken[$i]="$stm1"
    ((i++))
done < <(tail -n +2 $rankFile)


while IFS=',' read -r stm2 ssim 
do
    ssim=${ssim//[^[:alnum:]^[.]]/}

    tokenToSSIM[$stm2]=$ssim
done < <(tail -n +2 $ssimFile)


rm plotSingleSR2d.csv


for ((j=0;j<i;j++)); do
    var=${rankToToken[$j]}
    ssim="${tokenToSSIM[$var]}"
    if [ ! -z "$ssim" ]
    then
        echo "$j, $ssim" >> "plotSingleSR2d.csv"
    else
        echo "Error!" 1>&2
        exit 64
    fi
done



gnuplot -p -e "set datafile separator ',';set title 'SR'; set style circle radius 1;set xlabel 'Ranking of statement tokens';set ylabel 'ssim'; set style fill solid; plot 'plotSingleSR2d.csv' with circles lc 'blue' notitle"

if [ "$1" = -p ]; then
    sed -i '1 i\x, ssim' "plotSingleSR2d.csv"
else
    rm plotSingleSR2d.csv
fi

else

#=====================3D==========================

    declare -A tokenToSSIM
    declare -A rankToSSIMlist
    declare -A rankToTokenList

    #gather ssim
    while IFS=',' read -r stm1 ssim
    do
        #remove hidden char
        ssim=${ssim//[^[:alnum:]^[.]]/}
        tokenToSSIM[$stm1]=$ssim
    done < <(tail -n +2 $ssimFile)

    i=-1
    prevScore=99999

    #gather rank
    while IFS=',' read -r stm2 cluster score
    do
        #remove hidden char
        ssim=${score//[^[:alnum:]^[.]]/}

        if [ "$score" -ne "$prevScore" ]; then
            ((i++))
            prevScore=$score
            rankToTokenList[$i]="$stm2"
        else
            rankToTokenList[$i]="${rankToTokenList[$i]}, $stm2"
        fi
    done < <(tail -n +2 $rankFile)


    rm plotSingleSR3d.csv

    for ((x=0;x<i;x++)); do
        tokenList=${rankToTokenList[$x]}
        y=0
        for token in ${tokenList//,/ }
        do
            z="${tokenToSSIM[$token]}"
            echo "$x, $y, $z" >> "plotSingleSR3d.csv"
            ((y++))
        done
    done


    gnuplot -p -e "set datafile separator ',';set title 'SR'; set style circle radius 1;set xlabel 'Ranking of statement tokens';set zlabel 'SSIM'; set ylabel 'Number of tokens with equal ranking'; set style fill solid; splot 'plotSingleSR3d.csv' with circles lc 'blue' notitle"

    if [ "$2" = -p ]; then
        sed -i '1 i\x, y, z' "plotSingleSR3d.csv"
    else
        rm plotSingleSR3d.csv
    fi

fi
