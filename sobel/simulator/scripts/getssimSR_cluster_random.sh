#!/bin/bash 

#parameters
nStatements=38
clusterFile="../evaluator/rank/rank_sr.csv"
src="rtl/sr/*.v"
tb="rtl/tb/sobel_tb.v"
include=""
top="sobel_tb"
reps=20


function simulateCluster() {

    local stmList=$1
    local clusterName=$2
    local compDefine=""

    #generate the compile options required to inject the faults into the design
    for stm in ${stmList//,/ }
    do
        compDefine="$compDefine +define+$stm"
    done

#clear working directories
rm -rf work
#generate the faulty trace

$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog $compDefine +define+"s$i" $include $tb $src
$MODELSIM_BIN/vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/512x512sobel_out_nbits.txt imgs/SR_cluster/"cluster_random_$clusterName.txt"

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
    python3 scripts/sobel_IO_to_jpeg.py imgs/SR_cluster/"cluster_random_"$clusterName".txt" imgs/SR_cluster/"cluster_random_$clusterName.jpeg"

#get ssim
python3 -W ignore scripts/calc_SSIM.py imgs/SR_cluster/golden.jpeg imgs/SR_cluster/"cluster_random_$clusterName.jpeg"
returnSSIM=$(head -n 1 ssim_out.txt)
rm ssim_out.txt

}



###################START########################

declare -A idToStm
declare -A cToSize

#we use it to generate the ids
nElements=0
clusterID=0
#used to keep track of the original order in the input file
clustList=""

rm ssimSR_cluster_random.csv

#gather statements
while IFS=, read -r stm cluster score
do

    idToStm[$nElements]="$stm"

    if [ ! -v 'cToSize[$cluster]' ]; then
        cToSize[$cluster]=1
        #generate clustList
        if [ "$clustList" = "" ]; then
            clustList="$cluster"
        else
            clustList="$clustList, $cluster"
        fi
    else
        ((cToSize[$cluster]++))
    fi

    ((nElements++))

#this is to remove the csv header
done < <(tail -n +2 $clusterFile)

rm -rf imgs/SR_cluster
mkdir imgs/SR_cluster

simulateGolden
tojpgGolden


#dump csv header
echo "cluster,size,ssim" >> ssimSR_cluster_random.csv

#for each input size
for cluster in ${clustList//,/ }
do

    sumSSIM=0
    size=${cToSize[$cluster]}
    #gather random list of statements of size '$size'
    for ((j=0;j<reps;j++)); do
        declare -A usedIds
        tmpList=""
        for ((i=0;i<size;i++)); do
            #find a new random number (not present in the list)
            while [[ 1 ]]; do
                random=$((RANDOM % $nElements))
                if [ ! -v 'usedIds[$random]' ]; then
                    #found a new random number!
                    #store the number
                    usedIds[$random]="ok"
                    break
                fi
            done
            #dirty way of creating a list
            if [[ $tmpList == "" ]]; then
                tmpList="${idToStm[$random]}"
            else
                tmpList="$tmpList, ${idToStm[$random]}"
            fi
        done
        unset usedIds

        simulateCluster "$tmpList" "$cluster"
        getSSIMcluster "$cluster"
        sumSSIM=$(awk "BEGIN{ print ($sumSSIM + $returnSSIM)}")
    done
    #compute the avg ssim
    avgSSIM=$(awk "BEGIN{ print ($sumSSIM / $reps)}")

    #dump csv header 
    echo "$cluster,$size,$avgSSIM" >> ssimSR_cluster_random.csv

done

#move the result to the proper directory
mv ssimSR_cluster_random.csv ssim/
