#!/bin/bash 
$HARM_ROOT/build/evaluator --tech "br" --ass-file ass/axc_ass.txt --clk clk --vcd ../simulator/vcd/goldenBR.vcd --cs 3000 --fd ../simulator/vcd/faultBR/ --info-list ../simulator/info/brList.csv --dump-to rank/ --cluster -1
