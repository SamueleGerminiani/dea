#!/bin/bash 

cd simulator
#generate faults
bash scripts/simulateBR.sh
bash scripts/simulateVBR.sh
bash scripts/simulateSR.sh

#generate Err
bash scripts/getErrBR.sh -s
bash scripts/getErrVBR.sh -s
bash scripts/getErrSR.sh -s
cd ../evaluator/

#mine assertions
bash scripts/mineAssertions.sh

#evaluate assertions
bash scripts/evaluateAssertionsBR.sh
bash scripts/evaluateAssertionsVBR.sh
bash scripts/evaluateAssertionsSR.sh

#print results
bash scripts/printRankToErrBR.sh
bash scripts/printRankToErrVBR.sh
bash scripts/printRankToErrSR.sh
cd ../


