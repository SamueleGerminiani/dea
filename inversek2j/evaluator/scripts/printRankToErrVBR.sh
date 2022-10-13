#!/bin/bash 

rankFile="rank/rank_vbr.csv"
errFile="../simulator/err/errVBR.csv"

if [ "$1" = "2d" ]; then
    #=====================2D==========================


    declare -A tokenToErr
    declare -A rankToToken

    #used to assign IDs to the tokens
    i=0
    while IFS=',' read -r var size bit cluster score
    do
        rankToToken[$i]="$var[$bit]"
        ((i++))
    done < <(tail -n +2 $rankFile)


    while IFS=',' read -r token err 
    do
        #remove hidden char
        err=${err//[^[:alnum:]^[.]]/}

        tokenToErr[$token]=$err
    done < <(tail -n +2 $errFile)

    rm plotSingleVBR.csv

    for ((j=0;j<i;j++)); do
        var=${rankToToken[$j]}
        err="${tokenToErr[$var]}"
        if [ ! -z "$err" ]
        then
            echo "$j, $err" >> "plotSingleVBR2d.csv"
        else
            echo "Error!" 1>&2
            exit 64
        fi
    done


    gnuplot -p -e "set datafile separator ',';set title 'VBR'; set style circle radius 1;set xlabel 'Ranking of bit tokens';set ylabel 'Err'; set style fill solid; plot 'plotSingleVBR2d.csv' with circles lc 'blue' notitle"

    if [ "$2" = -p ]; then
        sed -i '1 i\x, err' "plotSingleVBR2d.csv"
    else
        rm plotSingleVBR2d.csv
    fi

else

    #=====================3D==========================

    declare -A tokenToErr
    declare -A rankToErrlist
    declare -A rankToTokenList

    #gather err
    while IFS=',' read -r token err 
    do
        #remove hidden char
        err=${err//[^[:alnum:]^[.]]/}
        tokenToErr[$token]=$err
    done < <(tail -n +2 $errFile)

    i=-1
    prevScore="initial"

    #gather rank
    while IFS=',' read -r var size bit cluster score
    do
        #remove hidden char
        err=${score//[^[:alnum:]^[.]]/}

        if [ "$score" != "$prevScore" ]; then
            ((i++))
            prevScore=$score
            rankToTokenList[$i]="$var[$bit]"
        else
            rankToTokenList[$i]="${rankToTokenList[$i]}, $var[$bit]"
        fi
    done < <(tail -n +2 $rankFile)


    rm plotSingleVBR3d.csv

    for ((x=0;x<=i;x++)); do
        tokenList=${rankToTokenList[$x]}
        y=0
        for token in ${tokenList//,/ }
        do
            z="${tokenToErr[$token]}"
            echo "$x, $y, $z" >> "plotSingleVBR3d.csv"
            ((y++))
        done
    done


    gnuplot -p -e "set datafile separator ',';set title 'VBR'; set style circle radius 1;set xlabel 'Ranking of bit tokens';set zlabel 'Err'; set ylabel 'Number of tokens with equal ranking'; set style fill solid; splot 'plotSingleVBR3d.csv' with circles lc 'blue' notitle"

    if [ "$2" = -p ]; then
        sed -i '1 i\x, y, z' "plotSingleVBR3d.csv"
    else
        rm plotSingleVBR3d.csv
    fi

fi
