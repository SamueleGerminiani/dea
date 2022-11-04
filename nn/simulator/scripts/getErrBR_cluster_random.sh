#!/bin/bash 

#parameters
clusterFile="../evaluator/rank/rank_br.csv"
src="rtl/br_cluster/*.v"
tb="rtl/tb/inv_kin_tb.v"
include=""
top="inv_kin_tb"
reps=3


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
        #check if the key $name is contained in the dictionary 'nameToMask'
        if [ ! -v 'nameToMask[$name]' ]; then
            #populate the mask with 1s if token was unkown until now
            nameToMask[$name]=$(head -c "$size" < /dev/zero | tr '\0' '1')
        fi

        #set the ith bit to 0
        let index="$((size - bit))"
        nameToMask[$name]=$(echo ${nameToMask[$name]} | sed s/./0/$index)
        nameToSize[$name]=$size
    done

    #generate the compile options required to inject the faults into the design
    for name in "${!nameToMask[@]}"
    do
        compDefine="$compDefine +define+$name +define+MASK_$name=${nameToSize[$name]}'b${nameToMask[$name]}"
    done

#clear working directories
rm -rf work

#generate the faulty trace
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog -quiet $include $compDefine $tb $src
$MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/output.csv theta/BR_cluster/"cluster_random_$clusterName.csv"

}


function simulateGolden() {

#clear working directories
rm -rf work

#generate golden trace
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog -quiet $include $tb $src
$MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/output.csv theta/BR_cluster/golden.csv
}


###################START########################

declare -A idToName
declare -A idToSize
declare -A idToBit
declare -A cToSize

#we use it to generate the ids
nElements=0
clusterID=0
#used to keep track of the original order in the input file
clustList=""

rm errBR_cluster_random.csv

#gather tokens
while IFS=, read -r token size bit cluster score
do

    idToName[$nElements]="$token"
    idToSize[$nElements]="$size"
    idToBit[$nElements]="$bit"

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

rm -rf theta/BR_cluster
mkdir theta/BR_cluster

simulateGolden


#dump csv header
echo "cluster,size,err" >> errBR_cluster_random.csv


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
                tmpList="$random"
            else
                tmpList="$tmpList, $random"
            fi
        done
        unset usedIds

        simulateCluster "$tmpList" "$cluster"

        retErr=$(./scripts/getError/getError.x "theta/BR_cluster/golden.csv" "theta/BR_cluster/cluster_random_${cluster}.csv" "2,3")
        sumErr=$(awk "BEGIN{ print ($sumErr + $retErr)}")
    done
    #compute the avg err
    avgErr=$(awk "BEGIN{ print ($sumErr / $reps)}")

    #dump csv header 
    echo "$cluster,$size,$avgErr" >> errBR_cluster_random.csv

done

#move the result to the proper directory
mv errBR_cluster_random.csv err/
