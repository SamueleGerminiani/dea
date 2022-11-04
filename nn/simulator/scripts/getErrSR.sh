#!/bin/bash 

#parameters
nStatements=64
src="rtl/sr/*"
tb="rtl/tb/inv_kin_tb.v"
include=""
traceLength=1000
top="inv_kin_tb"

#============[1]====================================
#simulate

#do not simulate if -s is not given as input
if [ "$1" = "-s" ]; then

#clear working directories
rm -rf csv/latest
mkdir csv/latest

#clear working directories
rm -rf theta/SR
mkdir theta/SR

#generate golden trace
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog -quiet $include $tb $src
$MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 
#store output
mv IO/out/output.csv theta/SR/golden.csv
#store trace
mv IO/out/trace.csv csv/latest/golden.csv

fi


#============[2]====================================

rm errSR.csv

#dump csv header 
echo "token,err" >> errSR.csv

#get err

for ((i=0;i<nStatements;i++)); do

    if [ "$1" = "-s" ]; then
        #clear
        rm -rf work
        $MODELSIM_BIN/vlib work
        #simulate
        $MODELSIM_BIN/vlog -quiet +define+"s$i" $include $tb $src
        $MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 
    fi

    #store output
    mv IO/out/output.csv theta/SR/"s$i.csv"
    #store trace
    mv IO/out/trace.csv csv/latest/"s$i.csv"

    retErr=$(./scripts/getError/getError.x "theta/SR/golden.csv" "theta/SR/s$i.csv" "2,3")

    echo "s$i,$retErr" >> errSR.csv
done

#move the result to the proper directory
mv errSR.csv err/

#move traces to the proper directory
rm csv/faultSR/*
cp csv/latest/golden.csv csv/goldenSR.csv
cp csv/latest/* csv/faultSR/

