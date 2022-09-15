








if [ -z "$1" ]
then
    echo "Must give the map file"
fi


if [ "$2" = "-s" ]; then

##simulate
rm -rf imgs/planeBR
mkdir imgs/planeBR

#original
rm -rf work
vlib work
vlog rtl/tb/sobel_tb.v rtl/template/sobel_br_template.v rtl/utils/*.v
vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/512x512sobel_out_nbits.txt imgs/planeBR/golden.txt


#with sa 0
while IFS=, read -r pad1 signal size pad2
do
    for ((bit=0;bit<size;bit++)); do
        rm -rf work
        vlib work
        vlog +define+bit=""$bit"" +define+"$signal" rtl/tb/sobel_tb.v rtl/template/sobel_br_template.v rtl/utils/*.v
        vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
        mv IO/out/512x512sobel_out_nbits.txt imgs/planeBR/"$signal[$bit].txt"
    done
done < "$1"

fi

    ##to jpeg
    python3 scripts/sobel_IO_to_jpeg.py imgs/planeBR/golden.txt imgs/planeBR/golden.jpeg

    while IFS=, read -r pad1 signal size pad2
    do
        for ((bit=0;bit<size;bit++)); do
            python3 scripts/sobel_IO_to_jpeg.py imgs/planeBR/"$signal[$bit].txt" imgs/planeBR/"$signal[$bit].jpeg"
        done
    done < "$1"

##get ssim
rm ssimBR.csv

while IFS=, read -r pad1 signal size pad2
do
    for ((bit=0;bit<size;bit++)); do
        python3 scripts/calc_SSIM.py imgs/planeBR/golden.jpeg imgs/planeBR/"$signal[$bit].jpeg"
        ssim=$(head -n 1 ssim_out.txt)
        echo "$signal[$bit],$ssim" >> ssimBR.csv
    done
done < "$1"

rm ssim_out.txt
