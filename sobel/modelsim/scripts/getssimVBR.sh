#!/bin/bash 

#parameters
varListFile="info/varList.csv"
src="rtl/template/sobel_vbr_template.v rtl/utils/*.v"
tb="rtl/tb/sobel_tb.v"
top="sobel_tb"


#============[1]====================================
#simulate

if [ "$1" = "-s" ]; then

#clear working directories
rm -rf imgs/VBR
mkdir imgs/VBR

#generate golden output
vlib work
vlog $tb $src
vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
#store output
mv IO/out/512x512sobel_out_nbits.txt imgs/VBR/golden.txt

#for each var
while IFS=, read -r var size 
do

    #remove hidden chars
    size=${size//[^[:alnum:]]/}

#for each bit var in var of size 'size'
for ((bit=0;bit<size;bit++)); do
    #clear
    rm -rf work
    vlib work
    #simulate
    vlog +define+bit=""$bit"" +define+"$var" $tb $src
    vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
    #store output
    mv IO/out/512x512sobel_out_nbits.txt imgs/VBR/"$var[$bit].txt"

done

done < <(tail -n +2 $varListFile)

fi

#============[2]====================================

#to jpeg, golden
python3 scripts/sobel_IO_to_jpeg.py imgs/VBR/golden.txt imgs/VBR/golden.jpeg

while IFS=, read -r var size
do

    #remove hidden chars
    size=${size//[^[:alnum:]]/}

#for each bit var in var of size 'size'
for ((bit=0;bit<size;bit++)); do
    ##to jpeg, faulty
    python3 scripts/sobel_IO_to_jpeg.py imgs/VBR/"$var[$bit].txt" imgs/VBR/"$var[$bit].jpeg"
done

done < <(tail -n +2 $varListFile)

#============[3]====================================
#get ssim

rm ssimVBR.csv

echo "token,ssim" >> ssimVBR.csv

while IFS=, read -r var size
do

    #remove hidden chars
    size=${size//[^[:alnum:]]/}

    for ((bit=0;bit<size;bit++)); do
        python3 -W ignore scripts/calc_SSIM.py imgs/VBR/golden.jpeg imgs/VBR/"$var[$bit].jpeg"
        ssim=$(head -n 1 ssim_out.txt)
        echo "$var[$bit],$ssim" >> ssimVBR.csv
    done
done < <(tail -n +2 $varListFile)

rm ssim_out.txt
mv ssimVBR.csv ssim/
