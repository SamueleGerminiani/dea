#!/bin/bash 
#$1 is the map file
rm -rf vcd/latest
mkdir vcd/latest

#original
rm -rf work
vcd="sobel_tb/*"
vlib work
vlog rtl/tb/sobel_tb.v rtl/template/sobel_sa_template.v rtl/utils/*.v
vsim work.sobel_tb -c -voptargs="+acc" -do "vcd file vcd/latest/sobel.vcd; vcd add $vcd; run -all; quit" 

#with sa 0
while IFS=, read -r pad1 signal size pad2
do
    for ((bit=0;bit<=size;bit++)); do
        rm -rf work
        vlib work
        vlog +define+bit=""$bit"" +define+"$signal" rtl/tb/sobel_tb.v rtl/template/sobel_sa_template.v rtl/utils/*.v
        vsim work.sobel_tb -c -voptargs="+acc" -do "vcd file vcd/latest/"$signal[$bit]".vcd; vcd add $vcd; run -all; quit" 
    done
done < "$1"
