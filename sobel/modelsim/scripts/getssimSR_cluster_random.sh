#!/bin/bash 

#parameters
nStatements=38
clusterFile="../harm/outSR/rank/rank_sr.csv"
src="rtl/template/sobel_sr_template.v rtl/template/utilsSR/*.v"
tb="rtl/tb/sobel_tb.v"
include="+incdir+rtl/template/utilsSR"
top="sobel_tb"
sizeList=$1
reps=$2


function simulateCluster() {

    local stmList=$1
    local nStms=$2
    local compDefine=""

    for stm in ${stmList//,/ }
    do
        compDefine="$compDefine +define+$stm"
    done

    #clear
    rm -rf work
    vlib work
    #simulate
    vlog $compDefine +define+"s$i" $include $tb $src
    vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
    mv IO/out/512x512sobel_out_nbits.txt imgs/SR_cluster/"cluster_random_$nStms.txt"

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
    local nStms=$1
    #to jpeg
    python3 scripts/sobel_IO_to_jpeg.py imgs/SR_cluster/"cluster_random_"$nStms".txt" imgs/SR_cluster/"cluster_random_$nStms.jpeg"

#get ssim
python3 -W ignore scripts/calc_SSIM.py imgs/SR_cluster/golden.jpeg imgs/SR_cluster/"cluster_random_$nStms.jpeg"
returnSSIM=$(head -n 1 ssim_out.txt)
rm ssim_out.txt

}



###################START########################

declare -A idToStm

nElements=0

rm ssimSR_cluster_random.csv

#gather statements
while IFS=, read -r stm cluster score
do

    idToStm[$nElements]="$stm"
    ((nElements++))
done < <(tail -n +2 $clusterFile)

rm -rf imgs/SR_cluster
mkdir imgs/SR_cluster

simulateGolden
tojpgGolden


echo "size,ssim" >> ssimSR_cluster_random.csv

#for each input size
for size in ${sizeList//,/ }
do

    sumSSIM=0
    #gather random list of statements of size '$size'
    for ((j=0;j<reps;j++)); do
        tmpList=""
        for ((i=0;i<size;i++)); do
            random=$((RANDOM % $nElements))
            if [[ $tmpList == "" ]]; then
                tmpList="${idToStm[$random]}"
            else
                tmpList="$tmpList, ${idToStm[$random]}"
            fi
        done

        simulateCluster "$tmpList" "$size"
        getSSIMcluster "$size"
        sumSSIM=$(awk "BEGIN{ print ($sumSSIM + $returnSSIM)}")
    done
    avgSSIM=$(awk "BEGIN{ print ($sumSSIM / $reps)}")

    echo "$size,$avgSSIM" >> ssimSR_cluster_random.csv

done
mv ssimSR_cluster_random.csv ssim/














