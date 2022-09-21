








if [ -z "$1" ]
then
    echo "Must give the map file"
fi


if [ "$2" = "-s" ]; then

##simulate
rm -rf imgs/planeVBR
mkdir imgs/planeVBR

original
rm -rf work
vlib work
vlog rtl/tb/sobel_tb.v rtl/template/sobel_br_template.v rtl/utils/*.v
vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/512x512sobel_out_nbits.txt imgs/planeVBR/golden.txt


#with sa 0
while IFS=, read -r var size 
do
    #remove hidden char
    size=${size::-1}

    if ["$var" = "var" && "$size" = "size" ]; then
        continue
    fi


    for ((bit=0;bit<size;bit++)); do
        rm -rf work
        vlib work
        vlog +define+bit=""$bit"" +define+"$var" rtl/tb/sobel_tb.v rtl/template/sobel_br_template.v rtl/utils/*.v
        vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
        mv IO/out/512x512sobel_out_nbits.txt imgs/planeVBR/"$var[$bit].txt"
    done

done < "$1"

fi

    ##to jpeg
    python3 scripts/sobel_IO_to_jpeg.py imgs/planeVBR/golden.txt imgs/planeVBR/golden.jpeg

    while IFS=, read -r var size
    do
        #remove hidden char
        size=${size::-1}

        if ["$var" = "var" && "$size" = "size" ]; then
            continue
        fi

        for ((bit=0;bit<size;bit++)); do
            python3 scripts/sobel_IO_to_jpeg.py imgs/planeVBR/"$var[$bit].txt" imgs/planeVBR/"$var[$bit].jpeg"
        done
    done < "$1"

##get ssim
rm ssimVBR.csv

while IFS=, read -r var size
do
    #remove hidden char
    size=${size::-1}

    if ["$var" = "var" && "$size" = "size" ]; then
        continue
    fi

    for ((bit=0;bit<size;bit++)); do
        python3 scripts/calc_SSIM.py imgs/planeVBR/golden.jpeg imgs/planeVBR/"$var[$bit].jpeg"
        ssim=$(head -n 1 ssim_out.txt)
        echo "$var[$bit],$ssim" >> ssimVBR.csv
    done
done < "$1"

rm ssim_out.txt
