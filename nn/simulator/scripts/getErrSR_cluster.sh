#!/bin/bash 

#parameters
nStatements=64
clusterFile="../evaluator/rank/rank_sr.csv"
src="rtl/sr/*.v"
tb="rtl/tb/inv_kin_tb.v"
include=""
top="inv_kin_tb"


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
    $MODELSIM_BIN/vlog -quiet $compDefine $include $tb $src
    $MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 
    mv IO/out/output.csv theta/SR_cluster/"cluster_$clusterName.csv"

}


function simulateGolden() {

#clear working directories
rm -rf work

#generate golden trace
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog -quiet $include $tb $src
$MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 
#store output
mv IO/out/output.csv theta/SR_cluster/"golden.csv"
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

rm errSR_cluster.csv

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
    rm -rf theta/SR_cluster
    mkdir theta/SR_cluster

    simulateGolden
fi




#dump csv header 
echo "cluster,size,err" >> errSR_cluster.csv

for c in ${clustList//,/ }
do
    if [ "$1" = "-s" ]; then
        #generate the err for this cluster and save it in 'returnErr'
        simulateCluster "${cToIds[$c]}" "$c"
    fi

    retErr=$(./scripts/getError/getError.x "theta/SR_cluster/golden.csv" "theta/SR_cluster/cluster_${c}.csv" "2,3")
    #dump err to file
    echo "$c,${cToSize[$c]},$retErr" >> errSR_cluster.csv

done

#move the result to the proper directory
mv errSR_cluster.csv err/




























