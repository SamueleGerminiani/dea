#!/bin/bash 
$HARM_ROOT/build/evaluator --tech "vbr" --ass-file ass/axc_ass.txt --clk clk --vcd ../simulator/vcd/goldenVBR.vcd --cs 3000 --fd ../simulator/vcd/faultVBR/ --info-list ../simulator/info/varList.csv --dump-to rank/ --cluster -1
