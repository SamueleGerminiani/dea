#!/bin/bash 
$HARM_ROOT/build/harm --vcd ../modelsim/vcd/goldenVBR.vcd --clk clk --conf conf.xml --dont-fill-ass --dump-to ass/ --max-ass 1000
