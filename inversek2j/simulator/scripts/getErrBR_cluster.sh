#!/bin/bash 

#parameters
clusterFile="../evaluator/rank/rank_br.csv"
src="rtl/br_cluster/*.v"
tb="rtl/tb/inv_kin_tb.v"
include=""
top="inv_kin_tb"


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
mv IO/out/output.csv theta/BR_cluster/"cluster_$clusterName.csv"

}


function simulateGolden() {

#clear working directories
rm -rf work

#generate the golden trace
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog -quiet $include $tb $src
$MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/output.csv theta/BR_cluster/golden.csv
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

rm errBR_cluster.csv

#gather tokens
while IFS=, read -r token size bit cluster score
do

    idToName[$nElements]="$token"
    idToSize[$nElements]="$size"
    idToBit[$nElements]="$bit"

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

    rm -rf theta/BR_cluster
    mkdir theta/BR_cluster

    simulateGolden
fi



#dump csv header 
echo "cluster,size,err" >> errBR_cluster.csv

for c in ${clustList//,/ }
do
    if [ "$1" = "-s" ]; then
        #generate the err for this cluster and save it in 'returnErr'
        simulateCluster "${cToIds[$c]}" "$c"
    fi
    retErr=$(./scripts/getError/getError.x "theta/BR_cluster/golden.csv" "theta/BR_cluster/cluster_${c}.csv" "2,3")

    #dump err to file
    echo "$c,${cToSize[$c]},$retErr" >> errBR_cluster.csv

done

#move the result to the proper directory
mv errBR_cluster.csv err/

