#!/bin/bash 

#parameters
varListFile="info/varList.csv"
src="rtl/vbr/*.v"
tb="rtl/tb/inv_kin_tb.v"
include=""
top="inv_kin_tb"



#============[1]====================================
#simulate


#clear working directories
rm -rf theta/VBR
mkdir theta/VBR

#do not simulate if -s is not given as input
if [ "$1" = "-s" ]; then
    #clear working directories
    rm -rf csv/latest
    mkdir csv/latest

    #generate golden output
    $MODELSIM_BIN/vlib work
    $MODELSIM_BIN/vlog -quiet $include $tb $src
    $MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 
    #store output
    mv IO/out/output.csv theta/VBR/golden.csv

    #store trace
    mv IO/out/trace.csv csv/latest/golden.csv
fi

#============[2]====================================

#get err

rm errVBR.csv

#dump csv header 
echo "token,err" >> errVBR.csv

#for each var
while IFS=, read -r var size 
do

    #remove hidden chars
    size=${size//[^[:alnum:]]/}

#for each bit in var of size 'size'
for ((bit=0;bit<size;bit++)); do
    if [ "$1" = "-s" ]; then
        #clear
        rm -rf work
        $MODELSIM_BIN/vlib work
        #simulate
        $MODELSIM_BIN/vlog -quiet $include +define+bit=""$bit"" +define+"$var" $tb $src
        $MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 

        #store output
        mv IO/out/output.csv theta/VBR/"$var[$bit].csv"

        #store trace
        mv IO/out/trace.csv csv/latest/"$var[$bit].csv"
    fi

    retErr=$(./scripts/getError/getError.x "theta/VBR/golden.csv" "theta/VBR/$var[$bit].csv" "2,3")

    echo "$var[$bit], $retErr" >> "errVBR.csv"
done

#this is to remove the csv header
done < <(tail -n +2 $varListFile)


#move the result to the proper directory
mv errVBR.csv err/

#move traces to the proper directory
rm csv/faultVBR/*
cp csv/latest/golden.csv csv/goldenVBR.csv
cp csv/latest/* csv/faultVBR/
