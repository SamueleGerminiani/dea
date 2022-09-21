// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
`timescale 1 ns / 1 ps
module myproject_dense_resource_ap_fixed_ap_fixed_16_8_5_3_0_config2_s_outbkb (
address0, ce0, q0, reset,clk);

parameter DataWidth = 6;
parameter AddressWidth = 16;
parameter AddressRange = 39200;

input[AddressWidth-1:0] address0;
input ce0;
output reg[DataWidth-1:0] q0;
input reset;
input clk;

reg [DataWidth-1:0] ram[0:AddressRange-1];

initial begin
    $readmemh("rtl/utils/myproject_dense_resource_ap_fixed_ap_fixed_16_8_5_3_0_config2_s_outbkb.dat", ram);
end



always @(posedge clk)  
begin 
    if (ce0) 
    begin
        q0 <= ram[address0];
    end
end



endmodule

