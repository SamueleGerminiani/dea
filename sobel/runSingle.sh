#!/bin/bash 

cd simulator
#generate faults
bash scripts/simulateWithTemplateBR.sh
bash scripts/simulateWithTemplateVBR.sh
bash scripts/simulateWithTemplateSR.sh

#generate ssim
bash scripts/getssimBR.sh -s
bash scripts/getssimVBR.sh -s
bash scripts/getssimSR.sh -s
cd ../evaluator/

#mine assertions
bash scripts/mineAssertions.sh

#evaluate assertions
bash scripts/evaluateAssertionsBR.sh
bash scripts/evaluateAssertionsVBR.sh
bash scripts/evaluateAssertionsSR.sh

#print results
bash scripts/printRankTossimBR.sh
bash scripts/printRankTossimVBR.sh
bash scripts/printRankTossimSR.sh
cd ../


