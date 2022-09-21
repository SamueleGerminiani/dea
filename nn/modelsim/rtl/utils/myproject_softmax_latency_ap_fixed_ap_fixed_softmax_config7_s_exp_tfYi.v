// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
`timescale 1 ns / 1 ps
module myproject_softmax_latency_ap_fixed_ap_fixed_softmax_config7_s_exp_tfYi (
address0, ce0, q0, address1, ce1, q1, reset,clk);

parameter DataWidth = 17;
parameter AddressWidth = 10;
parameter AddressRange = 1024;

input[AddressWidth-1:0] address0;
input ce0;
output reg[DataWidth-1:0] q0;
input[AddressWidth-1:0] address1;
input ce1;
output reg[DataWidth-1:0] q1;
input reset;
input clk;

reg [DataWidth-1:0] ram[0:AddressRange-1];

initial begin
    $readmemh("rtl/utils/myproject_softmax_latency_ap_fixed_ap_fixed_softmax_config7_s_exp_tfYi.dat", ram);
end



always @(posedge clk)  
begin 
    if (ce0) 
    begin
        q0 <= ram[address0];
    end
end



always @(posedge clk)  
begin 
    if (ce1) 
    begin
        q1 <= ram[address1];
    end
end



endmodule

