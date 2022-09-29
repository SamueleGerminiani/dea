#!/bin/bash 

#parameters
clusterFile="../harm/outVBR/rank/rank_vbr.csv"
src="rtl/template/sobel_br_template_cluster.v rtl/utils/*.v"
tb="rtl/tb/sobel_tb.v"
top="sobel_tb"
sizeList=$1
reps=$2


function simulateCluster() {
    local tokenList=$1
    local nTokens=$2
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
vlib work
vlog $compDefine $tb $src
vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/512x512sobel_out_nbits.txt imgs/VBR_cluster/cluster_random_$nTokens.txt

}


function simulateGolden() {

#clear working directories
rm -rf work

#generate golden trace
vlib work
vlog $tb $src
vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/512x512sobel_out_nbits.txt imgs/VBR_cluster/golden.txt
}

tojpgGolden () {
    #to jpeg golden
    python3 scripts/sobel_IO_to_jpeg.py imgs/VBR_cluster/golden.txt imgs/VBR_cluster/golden.jpeg
}

getSSIMcluster () {
    local nTokens=$1
    #to jpeg
    python3 scripts/sobel_IO_to_jpeg.py imgs/VBR_cluster/"cluster_random_"$nTokens".txt" imgs/VBR_cluster/"cluster_random_$nTokens.jpeg"

    #get ssim
    python3 -W ignore scripts/calc_SSIM.py imgs/VBR_cluster/golden.jpeg imgs/VBR_cluster/"cluster_random_$nTokens.jpeg"
    returnSSIM=$(head -n 1 ssim_out.txt)
    rm ssim_out.txt

}


###################START########################

declare -A idToName
declare -A idToSize
declare -A idToBit

#we use it to generate the ids
nElements=0

rm ssimVBR_cluster_random.csv

#gather statements
while IFS=, read -r var size bit cluster score
do

    idToName[$nElements]="$var"
    idToSize[$nElements]="$size"
    idToBit[$nElements]="$bit"

    ((nElements++))
done < <(tail -n +2 $clusterFile)

rm -rf imgs/VBR_cluster
mkdir imgs/VBR_cluster

simulateGolden
tojpgGolden


echo "size,ssim" >> ssimVBR_cluster_random.csv

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
                tmpList="$random"
            else
                tmpList="$tmpList, $random"
            fi
        done

        simulateCluster "$tmpList" "$size"
        getSSIMcluster "$size"
        sumSSIM=$(awk "BEGIN{ print ($sumSSIM + $returnSSIM)}")
    done
    avgSSIM=$(awk "BEGIN{ print ($sumSSIM / $reps)}")

    echo "$size,$avgSSIM" >> ssimVBR_cluster_random.csv

done

mv ssimVBR_cluster_random.csv ssim/














