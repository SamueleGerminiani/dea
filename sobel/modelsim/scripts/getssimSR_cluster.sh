








if [ -z "$1" ]
then
    echo "Must give the map cluster file"
fi

#read map cluster file
declare -A cToStm


while IFS=, read -r stm cluster score
do
    if [ "$stm" = "statement" ]; then
        continue
    fi

    if [ "${cToStm[$cluster]}" = "" ]; then
        cToStm[$cluster]="$stm"
    else
        cToStm[$cluster]="${cToStm[$cluster]}, $stm"
    fi


done < "$1"


if [ "$2" = "-s" ]; then

#simulate
rm -rf imgs/planeSR_cluster
mkdir imgs/planeSR_cluster

#original
rm -rf work
vlib work
vlog +incdir+rtl/template/utilsSR rtl/template/utilsSR/*.v rtl/tb/sobel_tb.v rtl/template/sobel_sr_template.v 
vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/512x512sobel_out_nbits.txt imgs/planeSR_cluster/golden.txt


vcd="sobel_tb/U0/*"


for cluster in "${!cToStm[@]}"
do
    compDefine=""
    echo "${cToStm[$cluster]}"
    stms=${cToStm[$cluster]}
    for stm in ${stms//,/ }
    do
        compDefine="$compDefine +define+$stm"
    done

    rm -rf work
    vlib work
    vlog $compDefine +incdir+rtl/template/utilsSR rtl/template/utilsSR/*.v rtl/tb/sobel_tb.v rtl/template/sobel_sr_template.v 
    #vsim work.sobel_tb -c -voptargs="+acc" -do "vcd file cluster$cluster.vcd; vcd add $vcd;run -all; quit" 
    vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
    mv IO/out/512x512sobel_out_nbits.txt imgs/planeSR_cluster/cluster$cluster.txt
done


fi

rm ssimSR_cluster.csv

    #to jpeg
    python3 scripts/sobel_IO_to_jpeg.py imgs/planeSR_cluster/golden.txt imgs/planeSR_cluster/golden.jpeg
    for cluster in "${!cToStm[@]}"
    do
        python3 scripts/sobel_IO_to_jpeg.py imgs/planeSR_cluster/"cluster$cluster.txt" imgs/planeSR_cluster/"cluster$cluster.jpeg"
    done

#get ssim
for cluster in "${!cToStm[@]}"
do
    python3 scripts/calc_SSIM.py imgs/planeSR_cluster/golden.jpeg imgs/planeSR_cluster/"cluster$cluster.jpeg"
    ssim=$(head -n 1 ssim_out.txt)
    echo "c$cluster,$ssim" >> ssimSR_cluster.csv
done

rm ssim_out.txt
