#!/bin/bash 

export HARM_ROOT=/home/sam/harm/
cd modelsim
bash scripts/simulateWithTemplateVBR.sh
bash scripts/simulateWithTemplateSR.sh
bash scripts/getssimVBR.sh -s
bash scripts/getssimSR.sh -s
cd ../evaluator/
bash scripts/mineAssertions.sh
bash scripts/evaluateAssertionsSR.sh
bash scripts/evaluateAssertionsVBR.sh
bash scripts/printRankTossimVBR.sh
bash scripts/printRankTossimSR.sh
bash scripts/evaluateAssertionsSR.sh
cd ../


