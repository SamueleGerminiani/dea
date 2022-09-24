#!/bin/bash 
#$1 is the map file
rm -rf csv/latest
mkdir -p csv/latest

#original
rm -rf work
vlib work
vlog -quiet +incdir+rtl/template/utilsSR rtl/template/utilsSR/*.v rtl/template/inv_kin_sr_template.v rtl/tb/inv_kin_tb_new.v
vsim -quiet work.inv_kin_tb -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/trace.csv csv/latest/inv_kin.csv

nStatements=$1
##74
for ((i=0;i<nStatements;i++)); do
    rm -rf work
    vlib work
    vlog -quiet +define+"s$i" +incdir+rtl/template/utilsSR rtl/template/utilsSR/*.v rtl/template/inv_kin_sr_template.v rtl/tb/inv_kin_tb_new.v
    vsim -quiet work.inv_kin_tb -c -voptargs="+acc" -do "run -all; quit"
    mv IO/out/trace.csv csv/latest/"s$i".csv
done
