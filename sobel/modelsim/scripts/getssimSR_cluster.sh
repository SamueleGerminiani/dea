#!/bin/bash 

#parameters
nStatements=38
clusterFile="../harm/outSR/rank/rank_sr.csv"
src="rtl/template/sobel_sr_template.v rtl/template/utilsSR/*.v"
tb="rtl/tb/sobel_tb.v"
include="+incdir+rtl/template/utilsSR"
top="sobel_tb"


function simulateCluster() {

    local tokenList=$1
    local clusterName=$2
    local compDefine=""

    for id in ${tokenList//,/ }
    do
        compDefine="$compDefine +define+${idToName[$id]}"
    done

    #clear
    rm -rf work
    vlib work
    #simulate
    vlog $compDefine $include $tb $src
    vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
    mv IO/out/512x512sobel_out_nbits.txt imgs/SR_cluster/"cluster_$clusterName.txt"

}


function simulateGolden() {

#clear working directories
rm -rf work

#generate golden trace
vlib work
vlog $include $tb $src
vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
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
rm ssim_out.txt

}



###################START########################

declare -A idToStm
declare -A cToIds
declare -A idToName

nElements=0

rm ssimSR_cluster.csv

#gather statements
while IFS=, read -r stm cluster score
do

    idToStm[$nElements]="$stm"
    idToName[$nElements]="$stm"
    if [ ! -v 'cToIds[$cluster]' ]; then
        #populate the mask with 1s if token was unkown until now
        cToIds[$cluster]="$nElements"
    else
        cToIds[$cluster]="${cToIds[$cluster]},$nElements"
    fi
    ((nElements++))
done < <(tail -n +2 $clusterFile)

if [ "$1" = "-s" ]; then
    rm -rf imgs/SR_cluster
    mkdir imgs/SR_cluster

    simulateGolden
fi




#for each input size
echo "cluster,ssim" >> ssimSR_cluster.csv

tojpgGolden

for c in "${!cToIds[@]}"
do
    if [ "$1" = "-s" ]; then
        simulateCluster "${cToIds[$c]}" "$c"
    fi
    getSSIMcluster "$c"
    echo "$c,$returnSSIM" >> ssimSR_cluster.csv

done

mv ssimSR_cluster.csv ssim/




























