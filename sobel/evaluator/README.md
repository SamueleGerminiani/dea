# All scripts in the 'scripts' directory must be executed from the 'evaluator' directory, each script contains a set of adjustable parameters in the header

## To mine the assertions

* Mine the assertions (it is the same for all techniques)

```
bash scripts/mineAssertions.sh
```
The mined assertions are stored in the ass/axc\_ass.txt file

## To generate the ranking

* Generate the ranking for the bit reduction technique

```
bash scripts/evaluateAssertionsBR.sh
```

The ranking is stored in the rank/rank\_br.csv  file

* Generate the ranking for the variable bit reduction technique

```
bash scripts/evaluateAssertionsVBR.sh
```

The ranking is stored in file rank/rank\_vbr.csv  file

* Generate the ranking for the statement reduction technique

```
bash scripts/evaluateAssertionsSR.sh
```

The ranking is stored in the rank/rank\_sr.csv  file

## To print the results (Ranking vs SSIM)

The following charts can be ploted either in 2D or 3D, depending on the given input ("2d" or "3d")
For the 3d version, the y-axis is the number of tokens having the same ranking score; there is no such distinction in the 2d case.
Print the ranking of each token VS the ssim.

* For the bit reduction technique

```
bash scripts/printRankTossimBR.sh "3d"
```

* For the variable bit reduction technique

```
bash scripts/printRankTossimVBR.sh "3d"
```

* For the statement reduction technique

```
bash scripts/printRankTossimSR.sh "3d"
```

## To print the results of approximating clusters of tokens 

The following charts can be ploted only in 2D.
Blue line: approximation of cluster of tokens, on the first y-axis
Red line:  approximation of cluster of tokens, on the first y-axis
Black line: number of tokens, on the second y-axis


* For the bit reduction technique
```
bash scripts/printssimClusterBR.sh
```

* For the variable bit reduction technique
```
bash scripts/printssimClusterVBR.sh
```

* For the statement reduction technique
```
bash scripts/printssimClusterSR.sh
```
