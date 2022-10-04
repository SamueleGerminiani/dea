#!/bin/bash 

#parameters
brListFile="info/brList.csv"
src="rtl/br/*.v"
tb="rtl/tb/sobel_tb.v"
include=""
top="sobel_tb"


#============[1]====================================
#simulate

if [ "$1" = "-s" ]; then

#clear working directories
rm -rf imgs/BR
mkdir imgs/BR

#generate golden output
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog $include $tb $src
$MODELSIM_BIN/vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
#store output
mv IO/out/512x512sobel_out_nbits.txt imgs/BR/golden.txt

#for each var
while IFS=, read -r id size 
do

    #remove hidden chars
    size=${size//[^[:alnum:]]/}

#for each bit var in var of size 'size'
for ((bit=0;bit<size;bit++)); do
    #clear
    rm -rf work
    $MODELSIM_BIN/vlib work
    #simulate
    $MODELSIM_BIN/vlog $include +define+bit=""$bit"" +define+"$id" $tb $src
    $MODELSIM_BIN/vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
    #store output
    mv IO/out/512x512sobel_out_nbits.txt imgs/BR/"${id}_$bit.txt"

done

done < <(tail -n +2 $brListFile)

fi

#============[2]====================================

#to jpeg, golden
python3 scripts/sobel_IO_to_jpeg.py imgs/BR/golden.txt imgs/BR/golden.jpeg

while IFS=, read -r id size
do

    #remove hidden chars
    size=${size//[^[:alnum:]]/}

#for each bit var in var of size 'size'
for ((bit=0;bit<size;bit++)); do
    ##to jpeg, faulty
    python3 scripts/sobel_IO_to_jpeg.py imgs/BR/"${id}_$bit.txt" imgs/BR/"${id}_$bit.jpeg"
done

done < <(tail -n +2 $brListFile)

#============[3]====================================
#get ssim

rm ssimBR.csv

echo "token,ssim" >> ssimBR.csv

while IFS=, read -r id size
do

    #remove hidden chars
    size=${size//[^[:alnum:]]/}

    for ((bit=0;bit<size;bit++)); do
        python3 -W ignore scripts/calc_SSIM.py imgs/BR/golden.jpeg imgs/BR/"${id}_$bit.jpeg"
        ssim=$(head -n 1 ssim_out.txt)
        echo "${id}_$bit,$ssim" >> ssimBR.csv
    done
done < <(tail -n +2 $brListFile)

rm ssim_out.txt
mv ssimBR.csv ssim/
