#!/bin/bash 
#$1 is the map file

retTheta1=0
retTheta2=0

collectListTheta () {
    retNList=0
    while IFS=, read -r x y theta1 theta2
    do
        #remove hidden char
        theta2=${theta2::-1}

        if [ "$theta1" = "theta1" ]; then
            continue
        fi
        ((retNList++))

        retTheta1List[$retNList]="$theta1"
        retTheta2List[$retNList]="$theta2"

    done < "$1"
}


rm -rf csv/latest
mkdir -p csv/latest

rm -rf work
vlib work
vlog -quiet rtl/utils/*.v rtl/template/inv_kin_vbr_template.v rtl/tb/inv_kin_tb_new.v
vsim -quiet work.inv_kin_tb -c -voptargs="+acc" -do "run -all; quit"
mv IO/out/output.csv theta/vbr/golden.csv
mv IO/out/trace.csv csv/latest/inv_kin.csv


collectListTheta "theta/vbr/golden.csv"

theta1GoldenList=(${retTheta1List[*]})
theta2GoldenList=(${retTheta2List[*]})

rm vbr.csv
touch vbr.csv
echo "var, rae" >> "vbr.csv"
while IFS=, read -r var size 
do
    #remove hidden char
    size=${size::-1}

    if [ "$size" = "size" ]; then
        continue
    fi

    for ((bit=0;bit<size;bit++)); do
        rm -rf work
        vlib work
        vlog -quiet +define+bit=""$bit"" +define+"$var" rtl/utils/*.v rtl/template/inv_kin_vbr_template.v rtl/tb/inv_kin_tb_new.v
        vsim -quiet work.inv_kin_tb -c -voptargs="+acc" -do "run -all; quit"
        mv IO/out/output.csv theta/vbr/"$var[$bit]".csv
        collectListTheta "theta/vbr/$var[$bit].csv"
        mv IO/out/trace.csv csv/latest/"$var[$bit]".csv
        theta1FList=(${retTheta1List[*]})
        theta2FList=(${retTheta2List[*]})

        final=0
        for ((i=0;i<retNList;i++)); do
            theta1RErr=$(awk -F'\t' "function abs(x){return ((x < 0.0) ? -x : x)} BEGIN{ print abs(${theta1GoldenList[$i]}-${theta1FList[$i]})/(${theta1GoldenList[$i]})}")
            theta2RErr=$(awk -F'\t' "function abs(x){return ((x < 0.0) ? -x : x)} BEGIN{ print abs(${theta2GoldenList[$i]}-${theta2FList[$i]})/(${theta2GoldenList[$i]})}")
            #echo "abs(${theta1GoldenList[$i]}-${theta1FList[$i]})/${theta1GoldenList[$i]}"
            #echo "$theta1RErr, $theta2RErr"

            if [ "$theta1RErr" != "0" ] || [ "$theta2RErr" != "0" ]; then
                thetaAVGErr=$(awk "BEGIN{ print ($theta1RErr+$theta2RErr)/2}")
            else
                thetaAVGErr=0
            fi
                final=$(awk "BEGIN{ print $final + $thetaAVGErr }")
        done

        final=$(awk "BEGIN{printf \"%.8f\", $final/$retNList }")

        echo "$var[$bit], $final" >> "vbr.csv"
        echo "$var[$bit], $final" 
    done
done < "$1"
