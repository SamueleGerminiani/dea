#!/bin/bash 
#$1 is the map file
rm -rf vcd/latest
mkdir vcd/latest

#original
rm -rf work
vcd="adder_tb/*"
vlib work
vlog rtl/tb/adder_tb.v rtl/template/adder_sa_template.v
vsim work.adder_tb -c -voptargs="+acc" -do "vcd file vcd/latest/adder.vcd; vcd add $vcd; run -all; quit" 

#with sa 0
while IFS=, read -r pad1 signal size pad2
do
    for ((bit=0;bit<=size;bit++)); do
        rm -rf work
        vlib work
        vlog +define+bit=""$bit"" +define+"$signal" rtl/tb/adder_tb.v rtl/template/adder_sa_template.v
        vsim work.adder_tb -c -voptargs="+acc" -do "vcd file vcd/latest/"$signal[$bit]".vcd; vcd add $vcd; run -all; quit" 
    done
done < "$1"
