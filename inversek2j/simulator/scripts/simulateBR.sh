#!/bin/bash 

#parameters
brListFile="info/brList.csv"
src="rtl/br/*.v"
tb="rtl/tb/inv_kin_tb.v"
top="inv_kin_tb"
include=""
traceLength=1000

#clear working directories
rm -rf csv/latest
mkdir csv/latest
rm -rf work

#generate golden trace
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog -quiet +define+TRACE_LENGTH=""$traceLength"" $include $tb $src
$MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 
cp IO/out/trace.csv csv/latest/golden.csv

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
    $MODELSIM_BIN/vlog -quiet +define+TRACE_LENGTH=""$traceLength"" +define+bit=""$bit"" +define+"$id" $include $tb $src
    $MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 
    cp IO/out/trace.csv csv/latest/"${id}_$bit.csv"
done

#this is to remove the csv header
done < <(tail -n +2 $brListFile)

#move traces to final directories
rm csv/faultBR/*
cp csv/latest/golden.csv csv/goldenBR.csv
cp csv/latest/* csv/faultBR/
