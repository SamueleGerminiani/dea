#!/bin/bash 

rankFile="rank/rank_sr.csv"
errFile="../simulator/err/errSR.csv"

if [ "$1" = "2d" ]; then
    #=====================2D==========================
    declare -A tokenToErr
    declare -A rankToToken

#used to assign IDs to the tokens
i=0
while IFS=',' read -r stm1 cluster score
do
    rankToToken[$i]="$stm1"
    ((i++))
done < <(tail -n +2 $rankFile)


while IFS=',' read -r stm2 err 
do
    err=${err//[^[:alnum:]^[.]]/}

    tokenToErr[$stm2]=$err
done < <(tail -n +2 $errFile)


rm plotSingleSR2d.csv


for ((j=0;j<i;j++)); do
    var=${rankToToken[$j]}
    err="${tokenToErr[$var]}"
    if [ ! -z "$err" ]
    then
        echo "$j, $err" >> "plotSingleSR2d.csv"
    else
        echo "Error!" 1>&2
        exit 64
    fi
done



gnuplot -p -e "set datafile separator ',';set title 'SR'; set style circle radius 1;set xlabel 'Ranking of statement tokens';set ylabel 'err'; set style fill solid; plot 'plotSingleSR2d.csv' with circles lc 'blue' notitle"

if [ "$1" = -p ]; then
    sed -i '1 i\x, err' "plotSingleSR2d.csv"
else
    rm plotSingleSR2d.csv
fi

else

#=====================3D==========================

    declare -A tokenToErr
    declare -A rankToErrlist
    declare -A rankToTokenList

    #gather err
    while IFS=',' read -r stm1 err
    do
        #remove hidden char
        err=${err//[^[:alnum:]^[.]]/}
        tokenToErr[$stm1]=$err
    done < <(tail -n +2 $errFile)

    i=-1
    prevScore="initial"

    #gather rank
    while IFS=',' read -r stm2 cluster score
    do
        #remove hidden char
        err=${score//[^[:alnum:]^[.]]/}

        if [ "$score" != "$prevScore" ]; then
            ((i++))
            prevScore=$score
            rankToTokenList[$i]="$stm2"
        else
            rankToTokenList[$i]="${rankToTokenList[$i]}, $stm2"
        fi
    done < <(tail -n +2 $rankFile)


    rm plotSingleSR3d.csv

    for ((x=0;x<=i;x++)); do
        tokenList=${rankToTokenList[$x]}
        y=0
        for token in ${tokenList//,/ }
        do
            z="${tokenToErr[$token]}"
            echo "$x, $y, $z" >> "plotSingleSR3d.csv"
            ((y++))
        done
    done


    gnuplot -p -e "set datafile separator ',';set title 'SR'; set style circle radius 1;set xlabel 'Ranking of statement tokens';set zlabel 'Err'; set ylabel 'Number of tokens with equal ranking'; set style fill solid; splot 'plotSingleSR3d.csv' with circles lc 'blue' notitle"

    if [ "$2" = -p ]; then
        sed -i '1 i\x, y, z' "plotSingleSR3d.csv"
    else
        rm plotSingleSR3d.csv
    fi

fi
