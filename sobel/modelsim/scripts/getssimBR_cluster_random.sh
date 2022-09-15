








if [ -z "$1" ]
then
    echo "Must give the map cl uster file"
fi

#read map cluster file
declare -A sToSize
declare -A cToMask
declare -A cToMock


nRows=0
#find how many signals and clusters
while IFS=, read -r pad1 signal size bit cluster pad2
do
    sToSize[$signal]=$size
    cToMock[$cluster]="mock"
    #populate the mask with 1s
    key="$cluster""_""$signal"
    cToMask[$key]=$(head -c "$size" < /dev/zero | tr '\0' '1')
    ((nRows++))
    if [[ $nRows -gt $2 ]]; then
        break
    fi
done < "$1"

if [ "$3" = "-s" ]; then

##simulate
rm -rf imgs/planeBR_cluster
mkdir imgs/planeBR_cluster

#original
rm -rf work
vlib work
vlog rtl/tb/sobel_tb.v rtl/template/sobel_br_template_cluster.v rtl/utils/*.v
vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/512x512sobel_out_nbits.txt imgs/planeBR_cluster/golden.txt


vcd="sobel_tb/U0/*"



nRows=0
#create the masks
while IFS=, read -r pad1 signal size bit cluster pad2
do
    echo "$signal""_""$bit"
    key="$cluster""_""$signal"
    tmp=${cToMask[$key]}
    let index="$((size - bit))"
    
    tmp=$(echo $tmp | sed s/./0/$index)
    cToMask[$key]=$tmp
    ((nRows++))
    if [[ $nRows -gt $2 ]]; then
        break
    fi
done < "$1"

for cluster in "${!cToMock[@]}"
do
    compDefine=""
    for signal in "${!sToSize[@]}"
    do
        key="$cluster""_""$signal"
        if [[ ${cToMask[$key]} != "" ]]; then
            echo "$key : ${cToMask[$key]}"
            compDefine="$compDefine +define+$signal +define+MASK_$signal=${sToSize[$signal]}'b${cToMask[$key]}"
        fi
    done

    rm -rf work
    vlib work
    vlog $compDefine rtl/tb/sobel_tb.v rtl/template/sobel_br_template_cluster.v rtl/utils/*.v
    #vsim work.sobel_tb -c -voptargs="+acc" -do "vcd file cluster$cluster.vcd; vcd add $vcd;run -all; quit" 
    vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
    mv IO/out/512x512sobel_out_nbits.txt imgs/planeBR_cluster/cluster_random$2.txt
done

fi

rm ssimBR_cluster_random$2.csv

    #to jpeg
    python3 scripts/sobel_IO_to_jpeg.py imgs/planeBR_cluster/golden.txt imgs/planeBR_cluster/golden.jpeg
        python3 scripts/sobel_IO_to_jpeg.py imgs/planeBR_cluster/"cluster_random$2.txt" imgs/planeBR_cluster/"cluster_random$2.jpeg"

##get ssim
    python3 scripts/calc_SSIM.py imgs/planeBR_cluster/golden.jpeg imgs/planeBR_cluster/"cluster_random$2.jpeg"
    ssim=$(head -n 1 ssim_out.txt)
    echo "$ssim,$2" >> ssimBR_cluster_random.csv

rm ssim_out.txt
