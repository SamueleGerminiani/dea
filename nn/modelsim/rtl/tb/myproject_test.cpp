//
//    rfnoc-hls-neuralnet: Vivado HLS code for neural-net building blocks
//
//    Copyright (C) 2017 EJ Kreinar
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
#include <fstream>
#include <iostream>
#include <algorithm>
#include <vector>
#include <map>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "firmware/myproject.h"
#include "firmware/nnet_utils/nnet_helpers.h"

//hls-fpga-machine-learning insert bram

#define CHECKPOINT 5000

namespace nnet {
    bool trace_enabled = true;
    std::map<std::string, void *> *trace_outputs = NULL;
    size_t trace_type_size = sizeof(double);
}

#define INPUT_DATA_SIZE 784 // Non dimenticare che parte da zero, in 784 c'e il valore di riferimento
#define OUTPUT_DATA_SIZE 10

int main(int argc, char **argv)
{
    std::cout << "=============================================================" << std::endl;

	using namespace std;
	float verified_match = 0;
	int N_data = 14000;
	size_t vector_size_bytes = sizeof(input_t) * INPUT_DATA_SIZE;
	size_t result_size_bytes = sizeof(result_t) * OUTPUT_DATA_SIZE;

	vector<input_t> source_a(INPUT_DATA_SIZE);
	vector<input_t> source_results(OUTPUT_DATA_SIZE);



	// Qui c'e' la parte aggiunta
	    FILE * pFile;
	    pFile = fopen ( "/local/mtraiola/workspace/mnist_14000_binary.txt" , "rb" );
	    //std::ifstream ifs("mnist_14000.txt");
	    //std::ifstream ifs("mnist_test_100.txt");
	    //std::string content;

	    //int stop=0;

	    // while there is an image, read the image
	    //while ( fread ( (void *) &source_a[0], sizeof(input_t), INPUT_DATA_SIZE, pFile ))
	    //{
	    	fread ( (void *) &source_a[0], sizeof(input_t), INPUT_DATA_SIZE, pFile);
	    	//t_end = std::chrono::steady_clock::now();
	    	//std::cout << "Time difference read= " << std::chrono::duration_cast<std::chrono::nanoseconds> (t_end - t_begin).count() << "[ns]" << std::endl;


	    	//create the variable and read the reference value
	    	input_t ref;
	        float bufReference;
	        fread ( (void *) &ref, sizeof(input_t), 1, pFile );
	        std::copy(&ref, &ref+1, &bufReference);

	        unsigned short size_in1,size_out1;

	        //t_begin = std::chrono::steady_clock::now();

	        myproject(&source_a[0],&source_results[0]);

	        //t_end = std::chrono::steady_clock::now();
	        //std::cout << "Time difference sendinput = " << std::chrono::duration_cast<std::chrono::nanoseconds> (t_end - t_begin).count() << "[ns]" << std::endl;



	        int index_max = 0;
	        input_t max = source_results[0];
	        std::cout << source_results[0] << " ";
	        for(int i = 1; i < OUTPUT_DATA_SIZE; i++)
	        {
	        	std::cout << source_results[i] << " ";

	        	if (source_results[i] > max)
	        	{
	        		 max = source_results[i];
	        		 index_max = i;
	        	}
	        }


	        // Validate our results
	        std::cout << index_max << ' '<< bufReference<<endl;
	        if (index_max == bufReference)
	        {
	        	verified_match += 1;
	        }
	        //t_begin = std::chrono::steady_clock::now();
	    //}
	    fclose(pFile);


	    long double Accuracy = verified_match/ N_data;
		std::cout << "Accuracy is: "<<std::setprecision(20)<< Accuracy ;
		std::cout<<endl;
	    return 0;

}
