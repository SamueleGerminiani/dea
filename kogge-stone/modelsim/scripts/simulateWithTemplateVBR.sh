#!/bin/bash 
#$1 is the map file
rm -rf vcd/latest
mkdir vcd/latest

#original
rm -rf work
vcd="-r inv_kin_tb/*"
vlib work
vlog -quiet rtl/utils/*.v rtl/template/inv_kin.v rtl/tb/inv_kin_tb_new.v
vsim -quiet work.inv_kin_tb -c -voptargs="+acc" -do "vcd file vcd/latest/inv_kin.vcd; vcd add $vcd; run -all; quit" 

#with sa 0
#while IFS=, read -r signal size 
#do
#    #remove hidden char
#    size=${size::-1}
#
#    if ["$var" = "var" && "$size" = "size" ]; then
#        continue
#    fi
#
#    for ((bit=0;bit<size;bit++)); do
#        rm -rf work
#        vlib work
#        vlog +define+bit=""$bit"" +define+"$signal" rtl/tb/sobel_tb.v rtl/template/sobel_br_template.v rtl/utils/*.v
#        vsim work.sobel_tb -c -voptargs="+acc" -do "vcd file vcd/latest/"$signal[$bit]".vcd; vcd add $vcd; run -all; quit" 
#    done
#done < "$1"
