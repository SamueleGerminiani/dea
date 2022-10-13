#!/bin/bash 

errCluster="../simulator/err/errBR_cluster.csv"
errClusterRandom="../simulator/err/errBR_cluster_random.csv"


declare -A xTcs
declare -A xTrcs
declare -A xTSize

i=0
while IFS=',' read -r cluster size err
do
    #remove hidden char
    err=${err//[^[:alnum:]^[.]]/}

    xTcs[$i]=$err
    xTSize[$i]=$size
    ((i++))
done < <(tail -n +2 $errCluster)


j=0
while IFS=',' read -r cluster size err
do
    #remove hidden char
    err=${err//[^[:alnum:]^[.]]/}

    xTrcs[$j]=$err
    ((j++))
done < <(tail -n +2 $errClusterRandom)

if [ "$i" != "$j" ]; then
    echo "Error: number of clusters differ"
    exit
fi

rm plotCluster.csv
rm plotClusterRandom.csv
rm plotClusterSize.csv

for ((k=0;k<i;k++)); do
    echo "$k, ${xTcs[$k]}" >> "plotCluster.csv"
    echo "$k, ${xTrcs[$k]}" >> "plotClusterRandom.csv"
    echo "$k, ${xTSize[$k]}" >> "plotClusterSize.csv"
done

((i--))

gnuplot -p -e "set datafile separator ',';set title 'BR';set xrange [0:$i];set y2tics nomirror;set ytics nomirror;set xlabel 'cluster ID';set ylabel 'Err';set y2label 'number of bit tokens'; set style fill solid; plot 'plotCluster.csv' with lines lc 'blue' notitle axes x1y1, 'plotClusterRandom.csv' with lines lc 'red' notitle axes x1y1, 'plotClusterSize.csv' with lines lc 'black' notitle axes x1y2"

rm plotCluster.csv
rm plotClusterRandom.csv
rm plotClusterSize.csv

if [ "$1" = -p ]; then
    rm plotClusterBR.csv
    echo "x,size,errCluster,errClusterRandom" >> "plotClusterBR.csv"
    for ((k=0;k<i;k++)); do
        echo "$k,${xTSize[$k]},${xTcs[$k]},${xTrcs[$k]}" >> "plotClusterBR.csv"
    done
else
    rm plotClusterBR.csv
fi
