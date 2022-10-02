#!/bin/bash 

#parameters
clusterFile="../evaluator/rank/rank_vbr.csv"
src="rtl/vbr_cluster/*.v"
tb="rtl/tb/sobel_tb.v"
include=""
top="sobel_tb"


function simulateCluster() {
    local tokenList=$1
    local clusterName=$2
    local compDefine=""
    declare -A nameToMask
    declare -A nameToSize

    for id in ${tokenList//,/ }
    do

        #retrieve info
        local size=${idToSize[$id]}
        local bit=${idToBit[$id]}
        local name=${idToName[$id]}
        if [ ! -v 'nameToMask[$name]' ]; then
            #populate the mask with 1s if token was unkown until now
            nameToMask[$name]=$(head -c "$size" < /dev/zero | tr '\0' '1')
        fi

        #turn the ith bit to 0
        let index="$((size - bit))"
        nameToMask[$name]=$(echo ${nameToMask[$name]} | sed s/./0/$index)
        nameToSize[$name]=$size
    done

    for name in "${!nameToMask[@]}"
    do
        compDefine="$compDefine +define+$name +define+MASK_$name=${nameToSize[$name]}'b${nameToMask[$name]}"
    done

#clear working directories
rm -rf work

#generate golden trace
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog $include $compDefine $tb $src
$MODELSIM_BIN/vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/512x512sobel_out_nbits.txt imgs/VBR_cluster/cluster_$clusterName.txt

}


function simulateGolden() {

#clear working directories
rm -rf work

#generate golden trace
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog $include $tb $src
$MODELSIM_BIN/vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/512x512sobel_out_nbits.txt imgs/VBR_cluster/golden.txt
}

tojpgGolden () {
    #to jpeg golden
    python3 -W ignore scripts/sobel_IO_to_jpeg.py imgs/VBR_cluster/golden.txt imgs/VBR_cluster/golden.jpeg
}

getSSIMcluster () {
    local clusterName=$1
    #to jpeg
    python3 scripts/sobel_IO_to_jpeg.py imgs/VBR_cluster/"cluster_"$clusterName".txt" imgs/VBR_cluster/"cluster_$clusterName.jpeg"

    #get ssim
    python3 -W ignore scripts/calc_SSIM.py imgs/VBR_cluster/golden.jpeg imgs/VBR_cluster/"cluster_$clusterName.jpeg"
    returnSSIM=$(head -n 1 ssim_out.txt)
    rm ssim_out.txt

}


###################START########################

declare -A idToName
declare -A idToSize
declare -A idToBit
declare -A cToIds
declare -A cToSize

#we use it to generate the ids
nElements=0
#used to keep track of the original order in the input file
clustList=""

rm ssimVBR_cluster.csv

#gather tokens
while IFS=, read -r var size bit cluster score
do

    idToName[$nElements]="$var"
    idToSize[$nElements]="$size"
    idToBit[$nElements]="$bit"

    if [ ! -v 'cToIds[$cluster]' ]; then
        cToSize[$cluster]=1
        cToIds[$cluster]="$nElements"
        #generate clustList
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
done < <(tail -n +2 $clusterFile)


if [ "$1" = "-s" ]; then

    rm -rf imgs/VBR_cluster
    mkdir imgs/VBR_cluster

    simulateGolden
fi



echo "cluster,size,ssim" >> ssimVBR_cluster.csv

tojpgGolden

for c in ${clustList//,/ }
do
    if [ "$1" = "-s" ]; then
        simulateCluster "${cToIds[$c]}" "$c"
    fi
    getSSIMcluster "$c"
    echo "$c,${cToSize[$c]},$returnSSIM" >> ssimVBR_cluster.csv

done

mv ssimVBR_cluster.csv ssim/














