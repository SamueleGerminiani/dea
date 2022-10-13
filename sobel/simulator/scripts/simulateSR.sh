#!/bin/bash 

#parameters
nStatements="38"
src="rtl/sr/*.v"
tb="rtl/tb/sobel_tb.v"
include=""
traceLength=1000
top="sobel_tb"
vcd="$top/*"

#clear working directories
rm -rf vcd/latest
mkdir vcd/latest
rm -rf work

#generate golden trace
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog +define+TRACE_LENGTH=""$traceLength"" $include $tb $src
$MODELSIM_BIN/vsim work.$top -c -voptargs="+acc" -do "vcd file vcd/latest/golden.vcd; vcd add $vcd; run -all; quit" 

for ((i=0;i<nStatements;i++)); do
    #clear
    rm -rf work
    $MODELSIM_BIN/vlib work
    #simulate with fault
    $MODELSIM_BIN/vlog +define+TRACE_LENGTH=""$traceLength"" +define+"s$i" $include $tb $src
    $MODELSIM_BIN/vsim work.$top -c -voptargs="+acc" -do "vcd file vcd/latest/s"$i".vcd; vcd add $vcd; run -all; quit" 
done

#move traces to final directories
rm vcd/faultSR/*
cp vcd/latest/golden.vcd vcd/goldenSR.vcd
cp vcd/latest/* vcd/faultSR/
