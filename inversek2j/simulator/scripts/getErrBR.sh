#!/bin/bash 

#parameters
brListFile="info/brList.csv"
src="rtl/br/*.v"
tb="rtl/tb/inv_kin_tb.v"
include=""
top="inv_kin_tb"


#============[1]====================================
#simulate

#do not simulate if -s is not given as input
if [ "$1" = "-s" ]; then

#clear working directories
rm -rf theta/BR
mkdir theta/BR

#generate golden output
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog -quiet $include $tb $src
$MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 

#store output
mv IO/out/output.csv theta/BR/golden.csv

#store trace
mv IO/out/trace.csv csv/latest/golden.csv
fi

#============[2]====================================

#get err

rm errBR.csv

#dump csv header 
echo "token,err" >> errBR.csv

#for each id
while IFS=, read -r id size 
do

    #remove hidden chars
    size=${size//[^[:alnum:]]/}

#for each bit in id of size 'size'
for ((bit=0;bit<size;bit++)); do
    if [ "$1" = "-s" ]; then
        #clear
        rm -rf work
        $MODELSIM_BIN/vlib work
        #simulate
        $MODELSIM_BIN/vlog -quiet $include +define+bit=""$bit"" +define+"$id" $tb $src
        $MODELSIM_BIN/vsim -quiet work.$top -c -voptargs="+acc" -do "run -all; quit" 

        #store output
        mv IO/out/output.csv theta/BR/"${id}_$bit.csv"

        #store trace
        mv IO/out/trace.csv csv/latest/"${id}_$bit.csv"
    fi

    retErr=$(./scripts/getError/getError.x "theta/BR/golden.csv" "theta/BR/${id}_$bit.csv" "2,3")

    echo "${id}_$bit,$retErr" >> errBR.csv

done

#this is to remove the csv header
done < <(tail -n +2 $brListFile)


#move the result to the proper directory
mv errBR.csv err/

#move traces to the proper directory
rm csv/faultBR/*
cp csv/latest/golden.csv csv/goldenBR.csv
cp csv/latest/* csv/faultBR/
