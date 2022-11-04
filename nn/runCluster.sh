#!/bin/bash 

cd simulator
bash scripts/getssimBR_cluster.sh -s
bash scripts/getssimVBR_cluster.sh -s
bash scripts/getssimSR_cluster.sh -s
bash scripts/getssimBR_cluster_random.sh
bash scripts/getssimVBR_cluster_random.sh
bash scripts/getssimSR_cluster_random.sh
cd ../evaluator/
bash scripts/printssimClusterBR.sh
bash scripts/printssimClusterVBR.sh
bash scripts/printssimClusterSR.sh
cd ../


