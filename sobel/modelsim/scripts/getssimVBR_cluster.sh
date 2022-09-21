








if [ -z "$1" ]
then
    echo "Must give the map cl uster file"
fi

#read map cluster file
declare -A sToSize
declare -A cToMask
declare -A cToMock


#find how many vars and clusters
while IFS=, read -r var size bit cluster ssim
do
    if ["$var" = "var" && "$size" = "size" ]; then
        continue
    fi

    sToSize[$var]=$size
    cToMock[$cluster]="mock"
    #populate the mask with 1s
    key="$cluster""_""$var"
    cToMask[$key]=$(head -c "$size" < /dev/zero | tr '\0' '1')
done < "$1"

if [ "$2" = "-s" ]; then

##simulate
rm -rf imgs/planeVBR_cluster
mkdir imgs/planeVBR_cluster

#original
rm -rf work
vlib work
vlog rtl/tb/sobel_tb.v rtl/template/sobel_br_template_cluster.v rtl/utils/*.v
vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/512x512sobel_out_nbits.txt imgs/planeVBR_cluster/golden.txt


vcd="sobel_tb/U0/*"



#create the masks
while IFS=, read -r var size bit cluster ssim
do
    if ["$var" = "var" && "$size" = "size" ]; then
        continue
    fi

    #echo "$var""_""$bit"
    key="$cluster""_""$var"
    tmp=${cToMask[$key]}
    let index="$((size - bit))"
    tmp=$(echo $tmp | sed s/./0/$index)
    cToMask[$key]=$tmp
done < "$1"

for cluster in "${!cToMock[@]}"
do
    compDefine=""
    for var in "${!sToSize[@]}"
    do
        key="$cluster""_""$var"
        if [[ ${cToMask[$key]} != "" ]]; then
            echo "$key : ${cToMask[$key]}"
            compDefine="$compDefine +define+$var +define+MASK_$var=${sToSize[$var]}'b${cToMask[$key]}"
        fi
    done

    rm -rf work
    vlib work
    vlog $compDefine rtl/tb/sobel_tb.v rtl/template/sobel_br_template_cluster.v rtl/utils/*.v
    #vsim work.sobel_tb -c -voptargs="+acc" -do "vcd file cluster$cluster.vcd; vcd add $vcd;run -all; quit" 
    vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
    mv IO/out/512x512sobel_out_nbits.txt imgs/planeVBR_cluster/cluster$cluster.txt
done

fi

rm ssimVBR_cluster.csv

    #to jpeg
    python3 scripts/sobel_IO_to_jpeg.py imgs/planeVBR_cluster/golden.txt imgs/planeVBR_cluster/golden.jpeg
    for cluster in "${!cToMock[@]}"
    do
        python3 scripts/sobel_IO_to_jpeg.py imgs/planeVBR_cluster/"cluster$cluster.txt" imgs/planeVBR_cluster/"cluster$cluster.jpeg"
    done

##get ssim
for cluster in "${!cToMock[@]}"
do
    python3 scripts/calc_SSIM.py imgs/planeVBR_cluster/golden.jpeg imgs/planeVBR_cluster/"cluster$cluster.jpeg"
    ssim=$(head -n 1 ssim_out.txt)
    echo "c$cluster,$ssim" >> ssimVBR_cluster.csv
done

rm ssim_out.txt
