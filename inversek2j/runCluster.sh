#!/bin/bash 

cd simulator
bash scripts/getErrBR_cluster.sh -s
bash scripts/getErrVBR_cluster.sh -s
bash scripts/getErrSR_cluster.sh -s
bash scripts/getErrBR_cluster_random.sh
bash scripts/getErrVBR_cluster_random.sh
bash scripts/getErrSR_cluster_random.sh
cd ../evaluator/
bash scripts/printErrClusterBR.sh
bash scripts/printErrClusterVBR.sh
bash scripts/printErrClusterSR.sh
cd ../


