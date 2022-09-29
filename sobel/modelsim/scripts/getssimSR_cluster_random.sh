


function simulateCluster() {
    local stmList=$1
    local compDefine=""
    local nStms=0

    for stm in ${stmList//,/ }
    do
        compDefine="$compDefine +define+$stm"
        ((nStms++))
    done
    rm -rf work
    vlib work
    vlog $compDefine +incdir+rtl/template/utilsSR rtl/template/utilsSR/*.v rtl/tb/sobel_tb.v rtl/template/sobel_sr_template.v 
    vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
    mv IO/out/512x512sobel_out_nbits.txt imgs/planeSR_cluster/"cluster_random_$nStms.txt"

}


function simulateGolden() {


rm -rf work
vlib work
vlog +incdir+rtl/template/utilsSR rtl/template/utilsSR/*.v rtl/tb/sobel_tb.v rtl/template/sobel_sr_template.v 
vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/512x512sobel_out_nbits.txt imgs/planeSR_cluster/golden.txt
}

getSSIM () {
    local nStms=$1
    #to jpeg
    python3 scripts/sobel_IO_to_jpeg.py imgs/planeSR_cluster/golden.txt imgs/planeSR_cluster/golden.jpeg
    python3 scripts/sobel_IO_to_jpeg.py imgs/planeSR_cluster/"cluster_random_"$nStms".txt" imgs/planeSR_cluster/"cluster_random_$nStms.jpeg"

#get ssim
python3 scripts/calc_SSIM.py imgs/planeSR_cluster/golden.jpeg imgs/planeSR_cluster/"cluster_random_$nStms.jpeg"
returnSSIM=$(head -n 1 ssim_out.txt)
rm ssim_out.txt

}



declare -A idToStm

in=$2
nElements=0

rm ssimSR_cluster_random.csv

#gather statements
while IFS=, read -r stm cluster score
do
    if [ "$stm" = "statement" ]; then
        continue
    fi

    idToStm[$nElements]="$stm"

    ((nElements++))
done < "$1"

rm -rf imgs/planeSR_cluster
mkdir imgs/planeSR_cluster

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
                tmpList="${idToStm[$random]}"
            else
                tmpList="$tmpList, ${idToStm[$random]}"
            fi
        done

        simulateCluster "$tmpList"
        getSSIM "$size"
        sumSSIM=$(awk "BEGIN{ print ($sumSSIM + $returnSSIM)}")
    done
    avgSSIM=$(awk "BEGIN{ print ($sumSSIM / $reps)}")

    echo "$size,$avgSSIM" >> ssimSR_cluster_random.csv

done














