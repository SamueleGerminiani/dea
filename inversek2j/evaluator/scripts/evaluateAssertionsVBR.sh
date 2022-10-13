#!/bin/bash 
$HARM_ROOT/build/evaluator --tech "vbr" --ass-file ass/axc_ass.txt --clk clk --csv ../simulator/csv/goldenVBR.csv --cs 3000 --fd ../simulator/csv/faultVBR/ --info-list ../simulator/info/varList.csv --dump-to rank/ --cluster -1
