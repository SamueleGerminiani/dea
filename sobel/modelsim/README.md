#All scripts in the 'scripts' directory must be executed from the 'modelsim' directory

##To generate the traces
* Generate the golden and faulty traces for the bit reduction technique :
```
bash scripts/simulateWithTemplateVBR.sh map/varList.csv

```
* Generate the golden and faulty traces for the statement reduction technique :
```
bash scripts/simulateWithTemplateSR.sh <nStatements>

```
nStatements is the number of approx. candidates in the design (right now we have 38 candidates spread across the source files)

The traces will be stored in vcd/latest/

##To generate the ssim
* Generate the ssim for the bit reduction technique :
```
bash scripts/getssimVBR.sh map/varList.csv -s

```
Results are stored in the ssimVBR.csv file

* Generate the ssim for the statement reduction technique :
```
bash scripts/getssimSR.sh <nStatements> -s

```
Results are stored in the ssimSR.csv file

