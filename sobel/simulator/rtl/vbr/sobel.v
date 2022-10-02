
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


    //mock variables
	wire [8:0] de_p2_p0, de_p8_p6, de_p0_p6, de_p2_p8, de_p5_p3, de_p1_p7, de_center_rm, de_center_tm;
	wire [9:0] de_center_1, de_center_2, de_center_3, de_center_4, de_gx_temp, de_gy_temp;

	wire de_or_out, de_add_out_1, de_add_out_2, de_add_out_3, de_add_out_4;
	wire [10:0] de_gx , de_gy, de_gx_comp, de_gy_comp;
	wire [10:0] de_gx_2s_comp, de_gy_2s_comp;   
				 	
	wire [10:0] de_abs_gx,de_abs_gy;	

	wire [10:0] de_sum;
	wire [10:0] de_gx_reg, de_gy_reg;		

    //mock logic to inject faults on the whole variable
    assign de_p2_p0=`SA(p2_p0,9);
    assign de_p8_p6=`SA(p8_p6,9);
    assign de_p0_p6=`SA(p0_p6,9);
    assign de_p2_p8=`SA(p2_p8,9);
    assign de_p5_p3=`SA(p5_p3,9);
    assign de_p1_p7=`SA(p1_p7,9);
    assign de_center_rm=`SA(center_rm,9);
    assign de_center_tm=`SA(center_tm,9);
    assign de_center_1=`SA(center_1,10);
    assign de_center_2=`SA(center_2,10);
    assign de_center_3=`SA(center_3,10);
    assign de_center_4=`SA(center_4,10);
    assign de_gx_temp=`SA(gx_temp,10);
    assign de_gy_temp=`SA(gy_temp,10);
    assign de_or_out=`SA(or_out,1);
    assign de_add_out_1=`SA(add_out_1,1);
    assign de_add_out_2=`SA(add_out_2,1);
    assign de_add_out_3=`SA(add_out_3,1);
    assign de_add_out_4=`SA(add_out_4,1);
    assign de_gx=`SA(gx,11);
    assign de_gy=`SA(gy,11);
    assign de_gx_comp=`SA(gx_comp,11);
    assign de_gy_comp=`SA(gy_comp,11);
    assign de_gx_2s_comp=`SA(gx_2s_comp,11);
    assign de_gy_2s_comp=`SA(gy_2s_comp,11);
    assign de_abs_gx=`SA(abs_gx,11);
    assign de_abs_gy=`SA(abs_gy,11);
    assign de_gx_reg=`SA(gx_reg,11);
    assign de_gy_reg=`SA(gy_reg,11);
    assign de_sum=`SA(sum,11);

	//Horizontal Gradient
	sobel_add_nb #(9) S0 (.a(p2),.b(p0),.ans_out(p2_p0),.subtract(1'b1),.cout()); 		//9-bit Subtractor
	sobel_add_nb #(9) S1 (.a(p5),.b(p3),.ans_out(p5_p3),.subtract(1'b1),.cout()); 		//9-bit Subtractor
	assign center_1 = de_p5_p3 << 1;
	sobel_add_nb #(9) S2 (.a(p8),.b(p6),.ans_out(p8_p6),.subtract(1'b1),.cout()); 		//9-bit Subtractor
	sobel_add_nb #(9) S3 (.a(de_p2_p0),.b(de_p8_p6),.ans_out(center_rm),.subtract(1'b0),.cout(add_out_1)); 	//9-bit Adder
	assign center_2 = {de_add_out_1,de_center_rm};
	sobel_add_nb #(10) S4 (.a(de_center_1),.b(de_center_2),.ans_out(gx_temp),.subtract(1'b0),.cout(add_out_2)); 	//10-bit Adder
	assign gx = {de_add_out_2,de_gx_temp};


	//Vertical Gradient
	sobel_add_nb #(9) S5 (.a(p0),.b(p6),.ans_out(p0_p6),.subtract(1'b1),.cout()); 		//9-bit Subtractor
	sobel_add_nb #(9) S6 (.a(p1),.b(p7),.ans_out(p1_p7),.subtract(1'b1),.cout()); 		//9-bit Subtractor
	assign center_3 = de_p1_p7 << 1; 
	sobel_add_nb #(9) S7 (.a(p2),.b(p8),.ans_out(p2_p8),.subtract(1'b1),.cout()); 		//9-bit Subtractor
	sobel_add_nb #(9) S8 (.a(de_p2_p8),.b(de_p0_p6),.ans_out(center_tm),.subtract(1'b0),.cout(add_out_3));  	//9-bit Adder
	assign center_4 = {de_add_out_3,de_center_tm};
	sobel_add_nb #(10) S9 (.a(de_center_3),.b(de_center_4),.ans_out(gy_temp),.subtract(1'b0),.cout(add_out_4));  //10-bit Adder
	assign gy = {de_add_out_4,de_gy_temp};

	
	always @(posedge clk)
	begin
		gx_reg <= de_gx;
		gy_reg <= de_gy;
	end




	not_11b N0 (de_gx_reg,gx_comp);
	not_11b N1 (de_gy_reg,gy_comp);
	
	sobel_add_nb #(11) S10 (.a(11'b1), .b(de_gx_comp), .ans_out(gx_2s_comp), .subtract(1'b0), .cout());	//11-bit Adder
	sobel_add_nb #(11) S11 (.a(11'b1), .b(de_gy_comp), .ans_out(gy_2s_comp), .subtract(1'b0), .cout());	//11-bit Adder

	mux_11b M0 (de_gx_reg, de_gx_2s_comp, de_gx_reg[8], abs_gx);
	mux_11b M1 (de_gy_reg, de_gy_2s_comp, de_gy_reg[8], abs_gy);

	sobel_add_nb #(11) S12 (.a(de_abs_gx), .b(de_abs_gy), .ans_out(sum), .subtract(1'b0), .cout());	//11-bit Adder

	//or_4b O0 (sum[8], sum[9], sum[10], sum[11], or_out);
	mux_8b M2 (de_sum[7:0], 8'hff, de_sum[8], out); 

endmodule
