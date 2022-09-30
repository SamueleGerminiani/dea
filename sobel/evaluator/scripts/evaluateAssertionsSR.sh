#!/bin/bash 
$HARM_ROOT/build/evaluator --tech "sr" --ass-file ass/axc_ass.txt --clk clk --vcd ../modelsim/vcd/goldenSR.vcd --cs 3000 --fd ../modelsim/vcd/faultSR/ --n-stm 37 --dump-to rank/ --cluster -1
