#!/bin/bash 

#parameters
nStatements="64"
src="rtl/sr/*.v"
tb="rtl/tb/inv_kin_tb.v"
include=""
traceLength=1000
top="inv_kin_tb"

#clear working directories
rm -rf csv/latest
mkdir csv/latest
rm -rf work

#generate golden trace
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog -quiet +define+TRACE_LENGTH=""$traceLength"" $include $tb $src
$MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 
cp IO/out/trace.csv csv/latest/golden.csv

for ((i=0;i<nStatements;i++)); do
    #clear
    rm -rf work
    $MODELSIM_BIN/vlib work
    #simulate with fault
    $MODELSIM_BIN/vlog -quiet +define+TRACE_LENGTH=""$traceLength"" +define+"s$i" $include $tb $src
    $MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 
    cp IO/out/trace.csv csv/latest/"s$i.csv"
done

#move traces to final directories
rm csv/faultSR/*
cp csv/latest/golden.csv csv/goldenSR.csv
cp csv/latest/* csv/faultSR/
