#!/bin/bash 

cd simulator
bash scripts/getssimVBR_cluster.sh -s
bash scripts/getssimSR_cluster.sh -s
bash scripts/getssimVBR_cluster_random.sh
bash scripts/getssimSR_cluster_random.sh
cd ../evaluator/
bash scripts/printssimClusterVBR.sh
bash scripts/printssimClusterSR.sh
cd ../


