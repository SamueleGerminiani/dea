#!/bin/bash 

#parameters
varListFile="info/varList.csv"
src="rtl/template/sobel_vbr_template.v rtl/utils/*.v"
tb="rtl/tb/sobel_tb.v"
top="sobel_tb"
vcd="$top/*"
traceLength=1000

#clear working directories
rm -rf vcd/latest
mkdir vcd/latest
rm -rf work

#generate golden trace
vlib work
vlog +define+TRACE_LENGTH=""$traceLength"" $tb $src
vsim work.$top -c -voptargs="+acc" -do "vcd file vcd/latest/golden.vcd; vcd add $vcd; run -all; quit" 

#for each var
while IFS=, read -r var size 
do
    #remove hidden chars
    size=${size//[^[:alnum:]]/}

#for each bit var in var of size 'size'
for ((bit=0;bit<size;bit++)); do
    #clear
    rm -rf work
    vlib work
    #simulate
    vlog +define+TRACE_LENGTH=""$traceLength"" +define+bit=""$bit"" +define+"$var" $tb $src
    vsim work.$top -c -voptargs="+acc" -do "vcd file vcd/latest/"$var[$bit]".vcd; vcd add $vcd; run -all; quit" 
done

done < <(tail -n +2 $varListFile)

#move traces to final directories
rm vcd/faultVBR/*
cp vcd/latest/golden.vcd vcd/goldenVBR.vcd
cp vcd/latest/* vcd/faultVBR/
