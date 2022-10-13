# All scripts in the 'scripts' directory must be executed from the 'simulator' directory, each script contains a set of adjustable parameters in the header

## To generate the traces

* Generate the golden and faulty traces for the bit reduction technique :

```
bash scripts/simulateBR.sh
```

* Generate the golden and faulty traces for the variable bit reduction technique :

```
bash scripts/simulateVBR.sh
```

* Generate the golden and faulty traces for the statement reduction technique :

```
bash scripts/simulateSR.sh
```

nStatements is the number of approximations candidates in the design (for this design, we have 38 candidates spread across the source files)

The traces will be stored in the vcd/ directory

## To generate the ssim for single tokens

* Generate the ssim for the bit reduction technique :

```
bash scripts/getssimBR.sh -s
```

Results are stored in the ssim/ssimBR.csv file

* Generate the ssim for the variable bit reduction technique :

```
bash scripts/getssimVBR.sh -s
```

Results are stored in the ssim/ssimVBR.csv file

* Generate the ssim for the statement reduction technique :

```
bash scripts/getssimSR.sh -s
```

Results are stored in the ssim/ssimSR.csv file

## To generate the ssim for multiple tokens (clusters)

* Generate the ssim for the bit reduction technique :

```
bash getssimBR\_cluster.sh -s
```
Results are stored in the ssim/ssimBR\_cluster.csv file

* Generate the ssim for the variable bit reduction technique :

```
bash getssimVBR\_cluster.sh -s
```

Results are stored in the ssim/ssimVBR\_cluster.csv file

* Generate the ssim for the statement reduction technique :

```
bash scripts/getssimSR_cluster.sh -s
```

Results are stored in the ssimSR\_cluster.csv file

* Generate the ssim for the random bit reduction technique :

```
bash getssimBR\_cluster.sh
```

Results are stored in the ssim/ssimBR\_cluster\_random.csv file

* Generate the ssim for the random variable bit reduction technique :

```
bash getssimVBR\_cluster.sh
```

Results are stored in the ssim/ssimVBR\_cluster\_random.csv file

* Generate the ssim for the statement reduction technique (random) :

```
bash getssimSR\_cluster_random.sh
```

Results are stored in the ssim/ssimSR\_cluster\_random.csv file
