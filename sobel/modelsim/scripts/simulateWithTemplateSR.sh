#!/bin/bash 
#$1 is the number of statements
rm -rf vcd/latest
mkdir vcd/latest

#original
rm -rf work
vcd="sobel_tb/U0/*"
vlib work
vlog rtl/tb/sobel_tb.v rtl/template/sobel_sr_template.v rtl/utils/*.v
vsim work.sobel_tb -c -voptargs="+acc" -do "vcd file vcd/latest/sobel.vcd; vcd add $vcd; run -all; quit" 

nStatements=$1
for ((i=0;i<nStatements;i++)); do
    rm -rf work
    vlib work
    vlog +define+"s$i" +incdir+rtl/template/utilsSR rtl/tb/sobel_tb.v rtl/template/sobel_sr_template.v rtl/template/utilsSR/*.v
    vsim work.sobel_tb -c -voptargs="+acc" -do "vcd file vcd/latest/s"$i".vcd; vcd add $vcd; run -all; quit" 
done
