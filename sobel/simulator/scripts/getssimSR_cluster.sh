#!/bin/bash 

#parameters
nStatements=38
clusterFile="../evaluator/rank/rank_sr.csv"
src="rtl/sr/*.v"
tb="rtl/tb/sobel_tb.v"
include=""
top="sobel_tb"


function simulateCluster() {

    local tokenList=$1
    local clusterName=$2
    local compDefine=""

    #generate the compile options required to inject the faults into the design
    for id in ${tokenList//,/ }
    do
        compDefine="$compDefine +define+${idToName[$id]}"
    done

    #clear
    rm -rf work
    $MODELSIM_BIN/vlib work
    #generate the faulty trace
    $MODELSIM_BIN/vlog $compDefine $include $tb $src
    $MODELSIM_BIN/vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
    mv IO/out/512x512sobel_out_nbits.txt imgs/SR_cluster/"cluster_$clusterName.txt"

}


function simulateGolden() {

#clear working directories
rm -rf work

#generate golden trace
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog $include $tb $src
$MODELSIM_BIN/vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
#store output
mv IO/out/512x512sobel_out_nbits.txt imgs/SR_cluster/golden.txt
}

tojpgGolden () {
    python3 scripts/sobel_IO_to_jpeg.py imgs/SR_cluster/golden.txt imgs/SR_cluster/golden.jpeg
}

getSSIMcluster () {
    local clusterName=$1
    #to jpeg
    python3 scripts/sobel_IO_to_jpeg.py imgs/SR_cluster/"cluster_"$clusterName".txt" imgs/SR_cluster/"cluster_$clusterName.jpeg"

#get ssim
python3 -W ignore scripts/calc_SSIM.py imgs/SR_cluster/golden.jpeg imgs/SR_cluster/"cluster_$clusterName.jpeg"
returnSSIM=$(head -n 1 ssim_out.txt)

#remove temporary file
rm ssim_out.txt

}



###################START########################

declare -A idToStm
declare -A cToIds
declare -A idToName
declare -A cToSize

#we use it to generate the ids
nElements=0
#used to keep track of the original order in the input file
clustList=""

rm ssimSR_cluster.csv

#gather statements
while IFS=, read -r stm cluster score
do

    idToStm[$nElements]="$stm"
    idToName[$nElements]="$stm"
    if [ ! -v 'cToIds[$cluster]' ]; then
        cToSize[$cluster]=1
        cToIds[$cluster]="$nElements"
        #generate clustList
        #dirty way of creating a list
        if [ "$clustList" = "" ]; then
            clustList="$cluster"
        else
            clustList="$clustList,$cluster"
        fi
    else
        cToIds[$cluster]="${cToIds[$cluster]},$nElements"
        ((cToSize[$cluster]++))
    fi
    ((nElements++))

#this is to remove the csv header
done < <(tail -n +2 $clusterFile)

#do not simulate if -s is not given as input
if [ "$1" = "-s" ]; then
    rm -rf imgs/SR_cluster
    mkdir imgs/SR_cluster

    simulateGolden
fi




#dump csv header 
echo "cluster,size,ssim" >> ssimSR_cluster.csv

tojpgGolden

for c in ${clustList//,/ }
do
    if [ "$1" = "-s" ]; then
        #generate the ssim for this cluster and save it in 'returnSSIM'
        simulateCluster "${cToIds[$c]}" "$c"
    fi
    getSSIMcluster "$c"
    #dump ssim to file
    echo "$c,${cToSize[$c]},$returnSSIM" >> ssimSR_cluster.csv

done

#move the result to the proper directory
mv ssimSR_cluster.csv ssim/




























