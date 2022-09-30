#!/bin/bash 
$HARM_ROOT/build/evaluator --tech "vbr" --ass-file ass/axc_ass.txt --clk clk --vcd ../modelsim/vcd/goldenVBR.vcd --cs 3000 --fd ../modelsim/vcd/faultVBR/ --var-list ../modelsim/info/varList.csv --dump-to rank/ --cluster -1
