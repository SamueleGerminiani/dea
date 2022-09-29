#!/bin/bash 
#$1 is the map file
rm -rf csv/latest
mkdir -p csv/latest

#original
rm -rf work
vlib work
vlog -quiet rtl/utils/*.v rtl/template/inv_kin_vbr_template.v rtl/tb/inv_kin_tb_new.v
vsim -quiet work.inv_kin_tb -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/trace.csv csv/latest/inv_kin.csv

#with sa 0
while IFS=, read -r var size 
do

    size=${size//[^[:alnum:]^[._]]/}

    if [ "$size" = "size" ]; then
        continue
    fi

    for ((bit=0;bit<size;bit++)); do
        rm -rf work
        vlib work
        vlog -quiet +define+bit=""$bit"" +define+"$var" rtl/utils/*.v rtl/template/inv_kin_vbr_template.v rtl/tb/inv_kin_tb_new.v
        vsim -quiet work.inv_kin_tb -c -voptargs="+acc" -do "run -all; quit"
        mv IO/out/trace.csv csv/latest/"$var[$bit]".csv
    done
done < "$1"
