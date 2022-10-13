#!/bin/bash 

rankFile="rank/rank_br.csv"
errFile="../simulator/err/errBR.csv"

if [ "$1" = "2d" ]; then
    #=====================2D==========================


    declare -A tokenToErr
    declare -A rankToToken

    #used to assign IDs to the tokens
    i=0
    while IFS=',' read -r token size bit cluster score
    do
        rankToToken[$i]="${token}_$bit"
        ((i++))
    done < <(tail -n +2 $rankFile)


    while IFS=',' read -r token err 
    do
        #remove hidden char
        err=${err//[^[:alnum:]^[._]]/}

        tokenToErr[$token]="$err"
    done < <(tail -n +2 $errFile)

    rm plotSingleBR.csv

    for ((j=0;j<i;j++)); do
        token=${rankToToken[$j]}
        err="${tokenToErr[$token]}"
        if [ ! -z "$err" ]
        then
            echo "$j, $err" >> "plotSingleBR2d.csv"
        else
            echo "Error!" 1>&2
            exit 64
        fi
    done


    gnuplot -p -e "set datafile separator ',';set title 'BR'; set style circle radius 1;set xlabel 'Ranking of bit reduction tokens';set ylabel 'Err'; set style fill solid; plot 'plotSingleBR2d.csv' with circles lc 'blue' notitle"

    if [ "$2" = -p ]; then
        sed -i '1 i\x, err' "plotSingleBR2d.csv"
    else
        rm plotSingleBR2d.csv
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
    prevScore=99999

    #gather rank
    while IFS=',' read -r token size bit cluster score
    do
        #remove hidden char
        err=${score//[^[:alnum:]^[.]]/}

        if [ "$score" -ne "$prevScore" ]; then
            ((i++))
            prevScore=$score
            rankToTokenList[$i]="${token}_$bit"
        else
            rankToTokenList[$i]="${rankToTokenList[$i]}, ${token}_$bit"
        fi
    done < <(tail -n +2 $rankFile)


    rm plotSingleBR3d.csv

    for ((x=0;x<=i;x++)); do
        tokenList=${rankToTokenList[$x]}
        y=0
        for token in ${tokenList//,/ }
        do
            z="${tokenToErr[$token]}"
            echo "$x, $y, $z" >> "plotSingleBR3d.csv"
            ((y++))
        done
    done


    gnuplot -p -e "set datafile separator ',';set title 'BR'; set style circle radius 1;set xlabel 'Ranking of bit reduction tokens';set zlabel 'Err'; set ylabel 'Number of tokens with equal ranking'; set style fill solid; splot 'plotSingleBR3d.csv' with circles lc 'blue' notitle"

    if [ "$2" = -p ]; then
        sed -i '1 i\x, y, z' "plotSingleBR3d.csv"
    else
        rm plotSingleBR3d.csv
    fi

fi
