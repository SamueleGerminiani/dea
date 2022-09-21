#ifndef DEFINES_H_
#define DEFINES_H_

#include "ap_int.h"
#include "ap_fixed.h"
#include "nnet_utils/nnet_types.h"
#include <cstddef>
#include <cstdio>

//hls-fpga-machine-learning insert numbers
#define N_INPUT_1_1 784
#define N_LAYER_2 50
#define N_LAYER_5 10

//hls-fpga-machine-learning insert layer-precision
typedef ap_fixed<16,6> model_default_t;
typedef ap_fixed<16,8> input_t;
typedef ap_fixed<16,8> layer2_t;
typedef ap_fixed<16,8> fc1_weight_t;
typedef ap_fixed<16,8> fc1_bias_t;
typedef ap_fixed<16,8> relu1_default_t;
typedef ap_fixed<16,8> layer4_t;
typedef ap_fixed<16,8> layer5_t;
typedef ap_fixed<16,8> output_weight_t;
typedef ap_fixed<16,8> output_bias_t;
typedef ap_fixed<16,8> softmax_default_t;
typedef ap_fixed<16,8> result_t;

#endif
