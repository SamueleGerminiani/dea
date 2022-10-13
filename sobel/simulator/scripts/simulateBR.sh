#!/bin/bash 

#parameters
brListFile="info/brList.csv"
src="rtl/br/*.v"
tb="rtl/tb/sobel_tb.v"
top="sobel_tb"
include=""
vcd="$top/*"
traceLength=1000

#clear working directories
rm -rf vcd/latest
mkdir vcd/latest
rm -rf work

#generate golden trace
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog +define+TRACE_LENGTH=""$traceLength"" $include $tb $src
$MODELSIM_BIN/vsim work.$top -c -voptargs="+acc" -do "vcd file vcd/latest/golden.vcd; vcd add $vcd; run -all; quit" 

#for each id
while IFS=, read -r id size 
do
    #remove hidden chars
    size=${size//[^[:alnum:]]/}

#for each bit in id of size 'size'
for ((bit=0;bit<size;bit++)); do
    #clear
    rm -rf work
    $MODELSIM_BIN/vlib work
    #simulate with fault
    $MODELSIM_BIN/vlog +define+TRACE_LENGTH=""$traceLength"" +define+bit=""$bit"" +define+"$id" $include $tb $src
    $MODELSIM_BIN/vsim work.$top -c -voptargs="+acc" -do "vcd file vcd/latest/${id}_$bit.vcd; vcd add $vcd; run -all; quit" 
done

#this is to remove the csv header
done < <(tail -n +2 $brListFile)

#move traces to final directories
rm vcd/faultBR/*
cp vcd/latest/golden.vcd vcd/goldenBR.vcd
cp vcd/latest/* vcd/faultBR/
