#!/bin/bash 

rankFile="rank/rank_br.csv"
ssimFile="../simulator/ssim/ssimBR.csv"

if [ "$1" = "2d" ]; then
    #=====================2D==========================


    declare -A tokenToSSIM
    declare -A rankToToken

    #used to assign IDs to the tokens
    i=0
    while IFS=',' read -r token size bit cluster score
    do
        rankToToken[$i]="${token}_$bit"
        ((i++))
    done < <(tail -n +2 $rankFile)


    while IFS=',' read -r token ssim 
    do
        #remove hidden char
        ssim=${ssim//[^[:alnum:]^[._]]/}

        tokenToSSIM[$token]="$ssim"
    done < <(tail -n +2 $ssimFile)

    rm plotSingleBR.csv

    for ((j=0;j<i;j++)); do
        token=${rankToToken[$j]}
        ssim="${tokenToSSIM[$token]}"
        if [ ! -z "$ssim" ]
        then
            echo "$j, $ssim" >> "plotSingleBR2d.csv"
        else
            echo "Error!" 1>&2
            exit 64
        fi
    done


    gnuplot -p -e "set datafile separator ',';set title 'BR'; set style circle radius 1;set xlabel 'Ranking of bit reduction tokens';set ylabel 'SSIM'; set style fill solid; plot 'plotSingleBR2d.csv' with circles lc 'blue' notitle"

    if [ "$2" = -p ]; then
        sed -i '1 i\x, ssim' "plotSingleBR2d.csv"
    else
        rm plotSingleBR2d.csv
    fi

else

    #=====================3D==========================

    declare -A tokenToSSIM
    declare -A rankToSSIMlist
    declare -A rankToTokenList

    #gather ssim
    while IFS=',' read -r token ssim 
    do
        #remove hidden char
        ssim=${ssim//[^[:alnum:]^[.]]/}
        tokenToSSIM[$token]=$ssim
    done < <(tail -n +2 $ssimFile)

    i=-1
    prevScore=99999

    #gather rank
    while IFS=',' read -r token size bit cluster score
    do
        #remove hidden char
        ssim=${score//[^[:alnum:]^[.]]/}

        if [ "$score" -ne "$prevScore" ]; then
            ((i++))
            prevScore=$score
            rankToTokenList[$i]="${token}_$bit"
        else
            rankToTokenList[$i]="${rankToTokenList[$i]}, ${token}_$bit"
        fi
    done < <(tail -n +2 $rankFile)


    rm plotSingleBR3d.csv

    for ((x=0;x<i;x++)); do
        tokenList=${rankToTokenList[$x]}
        y=0
        for token in ${tokenList//,/ }
        do
            z="${tokenToSSIM[$token]}"
            echo "$x, $y, $z" >> "plotSingleBR3d.csv"
            ((y++))
        done
    done


    gnuplot -p -e "set datafile separator ',';set title 'BR'; set style circle radius 1;set xlabel 'Ranking of bit reduction tokens';set zlabel 'SSIM'; set ylabel 'Number of tokens with equal ranking'; set style fill solid; splot 'plotSingleBR3d.csv' with circles lc 'blue' notitle"

    if [ "$2" = -p ]; then
        sed -i '1 i\x, y, z' "plotSingleBR3d.csv"
    else
        rm plotSingleBR3d.csv
    fi

fi
