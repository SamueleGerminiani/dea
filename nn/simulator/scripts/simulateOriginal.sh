#!/bin/bash 

#parameters
src="rtl/original/*.v rtl/original/*.sv"
top="apatb_myproject_top"
include="rtl/original/"
traceLength=5
tvPath="IO/tv"

##clear working directories
rm -rf work

#generate golden trace
$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog +define+TV_PATH=""$tvPath"" +define+TRACE_LENGTH=""$traceLength"" +incdir+$include -sv $src
$MODELSIM_BIN/vsim -c work.$top -voptargs="+acc" -L work -L unisims_ver -L xpm  -L floating_point_v7_0_20 -L floating_point_v7_1_14 glbl -suppress 6630 -do "run -all;quit"

#clear trash
rm *.csv myproject.result.lat.rb myproject.performance.result.transaction.xml

cd scripts/wrapc_pc/
source paths.source
./cosim.pc.exe $traceLength "../../$tvPath"
cd -

cp scripts/wrapc_pc/trace.csv csv/golden.csv
