#!/bin/bash 
#$1 is the map file
rm -rf vcd/latest
mkdir vcd/latest

#original
rm -rf work
rm IO/out/*
vcd="nova_tb/nova/*"
vlib work
vlog +incdir+rtl/utils/ rtl/utils/*.v rtl/tb/nova_tb.v rtl/template/nova_vbr_template.v
vsim work.nova_tb -c -voptargs="+acc" -do "vcd file vcd/latest/nova.vcd; vcd add $vcd; run -all; quit" 

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
