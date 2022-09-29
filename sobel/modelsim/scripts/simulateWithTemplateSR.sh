#!/bin/bash 

#parameters
nStatements="38"
src="rtl/template/sobel_sr_template.v rtl/template/utilsSR/*.v"
tb="rtl/tb/sobel_tb.v"
include="+incdir+rtl/template/utilsSR"
traceLength=1000
top="sobel_tb"
vcd="$top/*"

#clear working directories
rm -rf vcd/latest
mkdir vcd/latest
rm -rf work

#generate golden trace
vlib work
vlog +define+TRACE_LENGTH=""$traceLength"" $include $tb $src
vsim work.$top -c -voptargs="+acc" -do "vcd file vcd/latest/golden.vcd; vcd add $vcd; run -all; quit" 

for ((i=0;i<nStatements;i++)); do
    #clear
    rm -rf work
    vlib work
    #simulate
    vlog +define+TRACE_LENGTH=""$traceLength"" +define+"s$i" $include $tb $src
    vsim work.$top -c -voptargs="+acc" -do "vcd file vcd/latest/s"$i".vcd; vcd add $vcd; run -all; quit" 
done

#move traces to final directories
rm vcd/faultSR/*
cp vcd/latest/golden.vcd vcd/goldenSR.vcd
cp vcd/latest/* vcd/faultSR/
