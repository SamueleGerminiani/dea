#!/bin/bash 
#$1 is the var to rank
#$2 is the var to rae


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


while IFS=',' read -r var2 rae 
do
    #remove hidden char
    rae=${rae::-1}
    if [ "$var2" = "var" ]; then
        continue
    fi
    sTss[$var2]=$rae
done < "$2"

touch plot.csv
j=0;
for var in "${sTr[@]}"
do
    rae="${sTss[$var]}"
    if [ ! -z "$rae" ]
    then
        echo "$j, $rae" >> "plot.csv"
        ((j++))
    fi
done


#gnuplot -p -e "set datafile separator ','; set logscale y 2; set style circle radius 1;set xlabel 'ranking';set ylabel 'rae'; set style fill solid; plot 'plot.csv' with circles lc 'blue' notitle"
gnuplot -p -e "set datafile separator ','; set style circle radius 1;set xlabel 'ranking';set ylabel 'rae'; set style fill solid; plot 'plot.csv' with circles lc 'blue' notitle"

rm plot.csv
