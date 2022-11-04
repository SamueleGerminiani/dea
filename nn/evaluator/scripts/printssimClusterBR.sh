#!/bin/bash 

ssimCluster="../simulator/ssim/ssimBR_cluster.csv"
ssimClusterRandom="../simulator/ssim/ssimBR_cluster_random.csv"


declare -A xTcs
declare -A xTrcs
declare -A xTSize

i=0
while IFS=',' read -r cluster size ssim
do
    #remove hidden char
    ssim=${ssim//[^[:alnum:]^[.]]/}

    xTcs[$i]=$ssim
    xTSize[$i]=$size
    ((i++))
done < <(tail -n +2 $ssimCluster)


j=0
while IFS=',' read -r cluster size ssim
do
    #remove hidden char
    ssim=${ssim//[^[:alnum:]^[.]]/}

    xTrcs[$j]=$ssim
    ((j++))
done < <(tail -n +2 $ssimClusterRandom)

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

gnuplot -p -e "set datafile separator ',';set title 'BR';set xrange [0:$i];set y2tics nomirror;set ytics nomirror;set xlabel 'cluster ID';set ylabel 'SSIM';set y2label 'number of bit tokens'; set style fill solid; plot 'plotCluster.csv' with lines lc 'blue' notitle axes x1y1, 'plotClusterRandom.csv' with lines lc 'red' notitle axes x1y1, 'plotClusterSize.csv' with lines lc 'black' notitle axes x1y2"

rm plotCluster.csv
rm plotClusterRandom.csv
rm plotClusterSize.csv

if [ "$1" = -p ]; then
    rm plotClusterBR.csv
    echo "x,size,ssimCluster,ssimClusterRandom" >> "plotClusterBR.csv"
    for ((k=0;k<i;k++)); do
        echo "$k,${xTSize[$k]},${xTcs[$k]},${xTrcs[$k]}" >> "plotClusterBR.csv"
    done
else
    rm plotClusterBR.csv
fi
