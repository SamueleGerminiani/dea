

















function simulateCluster() {
    local tokenList=$1
    local compDefine=""
    local nTokens=0
    declare -A nameToMask
    declare -A nameToSize

    for id in ${tokenList//,/ }
    do

        #retrieve info
        local size=${idToSize[$id]}
        local bit=${idToBit[$id]}
        local name=${idToName[$id]}
        #populate the mask with 1s
        if [ ! -v 'nameToMask[name]' ]; then
            nameToMask[$name]=$(head -c "$size" < /dev/zero | tr '\0' '1')
        fi

        let index="$((size - bit))"
        nameToMask[$name]=$(echo ${nameToMask[$name]} | sed s/./0/$index)
        nameToSize[$name]=$size
        ((nTokens++))
    done

    local compDefine=""
    for name in "${!nameToMask[@]}"
    do
        compDefine="$compDefine +define+$name +define+MASK_$name=${nameToSize[$name]}'b${nameToMask[$name]}"
    done

    rm -rf work
    vlib work
    vlog $compDefine rtl/tb/sobel_tb.v rtl/template/sobel_br_template_cluster.v rtl/utils/*.v
    vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
    mv IO/out/512x512sobel_out_nbits.txt imgs/planeVBR_cluster/cluster_random_$nTokens.txt

}


function simulateGolden() {


rm -rf work
vlib work
vlog rtl/tb/sobel_tb.v rtl/template/sobel_br_template_cluster.v rtl/utils/*.v
vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/512x512sobel_out_nbits.txt imgs/planeVBR_cluster/golden.txt
}

getSSIM () {
    local nTokens=$1
    #to jpeg
    python3 scripts/sobel_IO_to_jpeg.py imgs/planeVBR_cluster/golden.txt imgs/planeVBR_cluster/golden.jpeg
    python3 scripts/sobel_IO_to_jpeg.py imgs/planeVBR_cluster/"cluster_random_"$nTokens".txt" imgs/planeVBR_cluster/"cluster_random_$nTokens.jpeg"

#get ssim
python3 scripts/calc_SSIM.py imgs/planeVBR_cluster/golden.jpeg imgs/planeVBR_cluster/"cluster_random_$nTokens.jpeg"
returnSSIM=$(head -n 1 ssim_out.txt)
rm ssim_out.txt

}



declare -A idToName
declare -A idToSize
declare -A idToBit

in=$2
nElements=0

rm ssimVBR_cluster_random.csv

#gather statements
while IFS=, read -r var size bit cluster score
do
    if [ "$var" = "var" ]; then
        continue
    fi

    idToName[$nElements]="$var"
    idToSize[$nElements]="$size"
    idToBit[$nElements]="$bit"

    ((nElements++))
done < "$1"

rm -rf imgs/planeVBR_cluster
mkdir imgs/planeVBR_cluster

simulateGolden

reps=$3

#for each input size
for size in ${in//,/ }
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

        simulateCluster "$tmpList"
        getSSIM "$size"
        sumSSIM=$(awk "BEGIN{ print ($sumSSIM + $returnSSIM)}")
    done
    avgSSIM=$(awk "BEGIN{ print ($sumSSIM / $reps)}")

    echo "$size,$avgSSIM" >> ssimVBR_cluster_random.csv

done














