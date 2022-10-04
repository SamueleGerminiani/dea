
`include "deMacro.v"


module sobel( clk, p0, p1, p2, p3, p5, p6, p7, p8, out);

input  [8:0] p0,p1,p2,p3,p5,p6,p7,p8;
input clk;

output [7:0] out;

wire [8:0] p2_p0, p8_p6, p0_p6, p2_p8, p5_p3, p1_p7, center_rm, center_tm;
wire [9:0] center_1, center_2, center_3, center_4, gx_temp, gy_temp;

wire or_out, add_out_1, add_out_2, add_out_3, add_out_4;
wire [10:0] gx , gy, gx_comp, gy_comp;
wire [10:0] gx_2s_comp, gy_2s_comp;

wire [10:0] abs_gx,abs_gy;
wire [10:0] sum;


reg [10:0] gx_reg, gy_reg;

//Horizontal Gradient
sobel_add_nb #(9) S0 (.a(p2),.b(p0),.ans_out(p2_p0),.subtract(1'b1),.cout()); 		//9-bit Subtractor
sobel_add_nb #(9) S1 (.a(p5),.b(p3),.ans_out(p5_p3),.subtract(1'b1),.cout()); 		//9-bit Subtractor
assign center_1 = `SA(br0,p5_p3,9) << 1;
sobel_add_nb #(9) S2 (.a(p8),.b(p6),.ans_out(p8_p6),.subtract(1'b1),.cout()); 		//9-bit Subtractor
sobel_add_nb #(9) S3 (.a(`SA(br1,p2_p0,9)),.b(`SA(br2,p8_p6,9)),.ans_out(center_rm),.subtract(1'b0),.cout(add_out_1)); 	//9-bit Adder
assign center_2 = {`SA(br3,add_out_1,1),`SA(br4,center_rm,9)};
sobel_add_nb #(10) S4 (.a(`SA(br5,center_1,10)),.b(`SA(br6,center_2,10)),.ans_out(gx_temp),.subtract(1'b0),.cout(add_out_2)); 	//10-bit Adder
assign gx = {`SA(br7,add_out_2,1),`SA(br8,gx_temp,10)};


//Vertical Gradient
sobel_add_nb #(9) S5 (.a(p0),.b(p6),.ans_out(p0_p6),.subtract(1'b1),.cout()); 		//9-bit Subtractor
sobel_add_nb #(9) S6 (.a(p1),.b(p7),.ans_out(p1_p7),.subtract(1'b1),.cout()); 		//9-bit Subtractor
assign center_3 = `SA(br9,p1_p7,9) << 1;
sobel_add_nb #(9) S7 (.a(p2),.b(p8),.ans_out(p2_p8),.subtract(1'b1),.cout()); 		//9-bit Subtractor
sobel_add_nb #(9) S8 (.a(`SA(br10,p2_p8,9)),.b(`SA(br11,p0_p6,9)),.ans_out(center_tm),.subtract(1'b0),.cout(add_out_3));  	//9-bit Adder
assign center_4 = {`SA(br12,add_out_3,1),`SA(br13,center_tm,9)};
sobel_add_nb #(10) S9 (.a(`SA(br14,center_3,10)),.b(`SA(br15,center_4,10)),.ans_out(gy_temp),.subtract(1'b0),.cout(add_out_4));  //10-bit Adder
assign gy = {`SA(br16,add_out_4,1),`SA(br17,gy_temp,10)};


always @(posedge clk)
begin
    gx_reg <= `SA(br18,gx,11);
    gy_reg <= `SA(br19,gy,11);
end



not_11b N0 (`SA(br20,gx_reg,11),gx_comp);
not_11b N1 (`SA(br21,gy_reg,11),gy_comp);

sobel_add_nb #(11) S10 (.a(11'b1), .b(`SA(br22,gx_comp,11)), .ans_out(gx_2s_comp), .subtract(1'b0), .cout());	//11-bit Adder
sobel_add_nb #(11) S11 (.a(11'b1), .b(`SA(br23,gy_comp,11)), .ans_out(gy_2s_comp), .subtract(1'b0), .cout());	//11-bit Adder

mux_11b M0 (`SA(br24,gx_reg,11), `SA(br25,gx_2s_comp,11), `SA(br26,gx_reg[8],1), abs_gx);
mux_11b M1 (`SA(br27,gy_reg,11), `SA(br28,gy_2s_comp,11), `SA(br29,gy_reg[8],1), abs_gy);

sobel_add_nb #(11) S12 (.a(`SA(br30,abs_gx,11)), .b(`SA(br31,abs_gy,11)), .ans_out(sum), .subtract(1'b0), .cout());	//11-bit Adder

//or_4b O0 (sum[8], sum[9], sum[10], sum[11], or_out);
mux_8b M2 (`SA(br32,sum[7:0],8), 8'hff, `SA(br33,sum[8],1), out);

endmodule
