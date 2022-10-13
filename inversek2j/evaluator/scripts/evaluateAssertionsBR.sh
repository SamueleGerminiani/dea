#!/bin/bash 
$HARM_ROOT/build/evaluator --tech "br" --ass-file ass/axc_ass.txt --clk clk --csv ../simulator/csv/goldenBR.csv --cs 3000 --fd ../simulator/csv/faultBR/ --info-list ../simulator/info/brList.csv --dump-to rank/ --cluster -1
