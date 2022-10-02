#All scripts in the 'scripts' directory must be executed from the 'modelsim' directory, each script contains a set of adjustable parameters in the header

##To generate the traces
* Generate the golden and faulty traces for the variable bit reduction technique :
```
bash scripts/simulateWithTemplateVBR.sh

```
* Generate the golden and faulty traces for the statement reduction technique :
```
bash scripts/simulateWithTemplateSR.sh

```
nStatements is the number of approx. candidates in the design (right now we have 38 candidates spread across the source files)

The traces will be stored in the vcd/ directory

##To generate the ssim for single tokens
* Generate the ssim for the bit reduction technique :
```
bash scripts/getssimVBR.sh -s

```
Results are stored in the ssim/ssimVBR.csv file

* Generate the ssim for the statement reduction technique :
```
bash scripts/getssimSR.sh -s

```
Results are stored in the ssim/ssimSR.csv file

##To generate the ssim for multiple tokens (clusters)
* Generate the ssim for the bit reduction technique :
```
getssimVBR\_cluster.sh -s

```
Results are stored in the ssim/ssimVBR\_cluster.csv file

* Generate the ssim for the bit reduction technique (random) :

getssimVBR\_cluster.sh <"size1, size2, ... sizeN"> <Nrepetitions>

Results are stored in the ssim/ssimVBR\_cluster\_random.csv file

* Generate the ssim for the statement reduction technique :

```
bash scripts/getssimSR_cluster.sh -s

```

Results are stored in the ssimSR\_cluster.csv file

* Generate the ssim for the statement reduction technique (random) :

getssimSR\_cluster.sh <"size1, size2, ... sizeN"> <Nrepetitions>

Results are stored in the ssim/ssimSR\_cluster\_random.csv file
