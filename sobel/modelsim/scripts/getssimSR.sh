#!/bin/bash 

#parameters
nStatements=38
src="rtl/template/sobel_sr_template.v rtl/template/utilsSR/*.v"
tb="rtl/tb/sobel_tb.v"
include="+incdir+rtl/template/utilsSR"
traceLength=1000
top="sobel_tb"

#============[1]====================================
#simulate

if [ "$1" = "-s" ]; then

#clear working directories
rm -rf imgs/SR
mkdir imgs/SR

#generate golden trace
vlib work
vlog $include $tb $src
vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
#store output
mv IO/out/512x512sobel_out_nbits.txt imgs/SR/golden.txt

for ((i=0;i<nStatements;i++)); do
    #clear
    rm -rf work
    vlib work
    #simulate
    vlog +define+"s$i" $include $tb $src
    vsim work.$top -c -voptargs="+acc" -do "run -all; quit" 
    #store output
    mv IO/out/512x512sobel_out_nbits.txt imgs/SR/"s$i".txt
done


fi

#============[2]====================================

##to jpeg
python3 scripts/sobel_IO_to_jpeg.py imgs/SR/golden.txt imgs/SR/golden.jpeg

for ((i=0;i<nStatements;i++)); do
    python3 scripts/sobel_IO_to_jpeg.py imgs/SR/"s$i.txt" imgs/SR/"s$i.jpeg"
done

#============[3]====================================
#get ssim

rm ssimSR.csv

echo "token,ssim" >> ssimSR.csv
for ((i=0;i<nStatements;i++)); do
    python3 -W ignore scripts/calc_SSIM.py imgs/SR/golden.jpeg imgs/SR/"s$i.jpeg"
    ssim=$(head -n 1 ssim_out.txt)
   echo "s$i,$ssim" >> ssimSR.csv
done

rm ssim_out.txt
mv ssimSR.csv ssim/
