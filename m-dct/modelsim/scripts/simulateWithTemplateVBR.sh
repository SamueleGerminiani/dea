#!/bin/bash 
#$1 is the map file
rm -rf vcd/latest
mkdir vcd/latest

#original
rm -rf work
vcd="tb_PEA14_DPA/*"
vlib work
vcom  rtl/utils/Packages.vhd rtl/utils/RippleCarry.vhd rtl/utils/FullAdder.vhd rtl/utils/GenericRegister.vhd rtl/utils/generic_adder_subtractor.vhd rtl/utils/PEA14DPAWrapper.vhd rtl/template/PEA141D.vhd rtl/utils/PEA14.vhd rtl/tb/tb_PEA14_DPA.vhd 

vsim work.tb_PEA14_DPA -c -voptargs="+acc" -do "vcd file vcd/latest/m-dct.vcd; vcd add $vcd; run -all; quit" 

##with sa 0
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
