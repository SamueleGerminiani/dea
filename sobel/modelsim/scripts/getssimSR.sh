







nStatements=$1

if [ -z "$1" ]
  then
    echo "Must give the number of statements as first argument"
fi


if [ "$2" = "-s" ]; then

##simulate
rm -rf imgs/planeSR
mkdir imgs/planeSR

#original
rm -rf work
vlib work
vlog +incdir+rtl/template/utilsSR rtl/tb/sobel_tb.v rtl/template/sobel_sr_template.v rtl/utils/*.v
vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
mv IO/out/512x512sobel_out_nbits.txt imgs/planeSR/golden.txt

nStatements=$1
for ((i=0;i<nStatements;i++)); do
    rm -rf work
    vlib work
    vlog +define+"s$i" +incdir+rtl/template/utilsSR rtl/tb/sobel_tb.v rtl/template/sobel_sr_template.v rtl/template/utilsSR/*.v
    vsim work.sobel_tb -c -voptargs="+acc" -do "run -all; quit" 
    mv IO/out/512x512sobel_out_nbits.txt imgs/planeSR/"s$i".txt
done


fi

##to jpeg
python3 scripts/sobel_IO_to_jpeg.py imgs/planeSR/golden.txt imgs/planeSR/golden.jpeg

for ((i=0;i<nStatements;i++)); do
    python3 scripts/sobel_IO_to_jpeg.py imgs/planeSR/"s$i.txt" imgs/planeSR/"s$i.jpeg"
done

##get ssim

rm ssimSR.csv
for ((i=0;i<nStatements;i++)); do
    python3 scripts/calc_SSIM.py imgs/planeSR/golden.jpeg imgs/planeSR/"s$i.jpeg"
    ssim=$(head -n 1 ssim_out.txt)
   echo "s$i,$ssim" >> ssimSR.csv
done
rm ssim_out.txt
