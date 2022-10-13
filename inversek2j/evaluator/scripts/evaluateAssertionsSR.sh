#!/bin/bash 
$HARM_ROOT/build/evaluator --tech "sr" --ass-file ass/axc_ass.txt --clk clk --csv ../simulator/csv/goldenSR.csv --cs 3000 --fd ../simulator/csv/faultSR/ --n-stm 64 --dump-to rank/ --cluster -1
