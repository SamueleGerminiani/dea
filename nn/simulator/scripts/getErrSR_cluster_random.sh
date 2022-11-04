#!/bin/bash 

#parameters
nStatements=64
clusterFile="../evaluator/rank/rank_sr.csv"
src="rtl/sr/*.v"
tb="rtl/tb/inv_kin_tb.v"
include=""
top="inv_kin_tb"
reps=50


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
$MODELSIM_BIN/vlog -quiet $compDefine +define+"s$i" $include $tb $src
$MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/output.csv theta/SR_cluster/"cluster_random_$clusterName.csv"

}


function simulateGolden() {

#clear working directories
rm -rf work

#generate golden trace
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog -quiet $include $tb $src
$MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 
#store output
mv IO/out/output.csv theta/SR_cluster/golden.csv
}


###################START########################

declare -A idToStm
declare -A cToSize

#we use it to generate the ids
nElements=0
clusterID=0
#used to keep track of the original order in the input file
clustList=""

rm errSR_cluster_random.csv

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

rm -rf theta/SR_cluster
mkdir theta/SR_cluster

simulateGolden


#dump csv header
echo "cluster,size,err" >> errSR_cluster_random.csv

#for each input size
for cluster in ${clustList//,/ }
do

    sumErr=0
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
        retErr=$(./scripts/getError/getError.x "theta/SR_cluster/golden.csv" "theta/SR_cluster/cluster_random_${cluster}.csv" "2,3")
        sumErr=$(awk "BEGIN{ print ($sumErr + $retErr)}")
    done
    #compute the avg err
    avgErr=$(awk "BEGIN{ print ($sumErr / $reps)}")

    #dump csv header 
    echo "$cluster,$size,$avgErr" >> errSR_cluster_random.csv

done

#move the result to the proper directory
mv errSR_cluster_random.csv err/
