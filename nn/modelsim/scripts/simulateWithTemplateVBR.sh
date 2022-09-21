#!/bin/bash 
#$1 is the map file
rm -rf vcd/latest
mkdir vcd/latest

#original
rm -rf work
vcd="myproject/*"
vlib work
vlog +acc=rnbp -ccflags "-I ./work -I ./rtl/tb/include/ -I ./rtl/tb/include/firmware -I ./rtl/tb/include/firmware/ap_types" -sv rtl/utils/*.v rtl/tb/myproject_test.cpp
vsim -quiet work.myproject -c -voptargs="+acc" -do "vcd file vcd/latest/myproject.vcd; vcd add $vcd; run -all; quit" 

#with sa 0
#while IFS=, read -r var size 
#do
#    #remove hidden char
#    size=${size::-1}
#
#    if [ "$size" = "size" ]; then
#        continue
#    fi
#
#    for ((bit=0;bit<size;bit++)); do
#        rm -rf work
#        vlib work
#        vlog -quiet +define+bit=""$bit"" +define+"$var" rtl/utils/*.v rtl/template/inv_kin_vbr_template.v rtl/tb/inv_kin_tb_new.v
#        vsim -quiet work.inv_kin_tb -c -voptargs="+acc" -do "vcd file vcd/latest/"$var[$bit]".vcd; vcd add $vcd; run -all; quit"
#    done
#done < "$1"
