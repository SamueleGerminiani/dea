#!/bin/bash 
#$1 is the map file
rm -rf vcd/latest
mkdir vcd/latest

#original
rm -rf work
vcd="sobel_tb/*"
vlib work
vlog rtl/tb/sobel_tb.v rtl/template/sobel_br_template.v rtl/utils/*.v
vsim work.sobel_tb -c -voptargs="+acc" -do "vcd file vcd/latest/sobel.vcd; vcd add $vcd; run -all; quit" 

#with sa 0
while IFS=, read -r var size 
do
    #remove hidden char
    size=${size::-1}

    if ["$var" = "var" && "$size" = "size" ]; then
        continue
    fi

    for ((bit=0;bit<size;bit++)); do
        rm -rf work
        vlib work
        vlog +define+bit=""$bit"" +define+"$var" rtl/tb/sobel_tb.v rtl/template/sobel_br_template.v rtl/utils/*.v
        vsim work.sobel_tb -c -voptargs="+acc" -do "vcd file vcd/latest/"$var[$bit]".vcd; vcd add $vcd; run -all; quit" 
    done
done < "$1"
