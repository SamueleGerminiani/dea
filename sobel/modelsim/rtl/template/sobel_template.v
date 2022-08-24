
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


	`ifndef axc_21
	assign center_1 = p5_p3 << 1;
	`else
	assign center_1 = {p5_p3[8:`k],1'b0,p5_p3[`k-1:0]}  << 1;
	`endif




	sobel_add_nb #(9) S2 (.a(p8),.b(p6),.ans_out(p8_p6),.subtract(1'b1),.cout()); 		//9-bit Subtractor

	`ifndef axc_3
		`ifndef axc_22
			sobel_add_nb #(9) S3 (.a(p2_p0),.b(p8_p6),.ans_out(center_rm),.subtract(1'b0),.cout(add_out_1)); 	//9-bit Adder
		`else
			sobel_add_nb #(9) S3 (.a(p2_p0),.b({p8_p6[8:`k],1'b0,p8_p6[`k-1:0]}),.ans_out(center_rm),.subtract(1'b0),.cout(add_out_1)); 	//9-bit Adder
		`endif
	`else
	sobel_add_nb #(9) S3 (.a({p2_p0[8:`k],1'b0,p2_p0[`k-1:0]}),.b(p8_p6),.ans_out(center_rm),.subtract(1'b0),.cout(add_out_1)); 	//9-bit Adder
	`endif



	`ifndef axc_27
		`ifndef axc_6
		assign center_2 = {add_out_1,center_rm};
		`else
		assign center_2 = {add_out_1, {center_rm[8:`k],1'b0,center_rm[`k-1:0]} };
		`endif

	`else

	assign center_2 = {1'b0,center_rm};
	`endif


	`ifndef axc_13 
	sobel_add_nb #(10) S4 (.a(center_1),.b(center_2),.ans_out(gx_temp),.subtract(1'b0),.cout(add_out_2)); 	//10-bit Adder
	`else
	sobel_add_nb #(10) S4 (.a({center_1[9:`k],1'b0,center_1[`k-1:0]}),.b(center_2),.ans_out(gx_temp),.subtract(1'b0),.cout(add_out_2)); 	//10-bit Adder
	`endif

    `ifndef axc_23
        `ifndef axc_28

            assign gx = {add_out_2,gx_temp};
        `else
            assign gx = {1'b0,gx_temp};
        `endif
        assign gx = {add_out_2,{gx_temp [9:`k],1'b0,gx_temp [`k-1:0]}  };
    `endif



	//Vertical Gradient
	sobel_add_nb #(9) S5 (.a(p0),.b(p6),.ans_out(p0_p6),.subtract(1'b1),.cout()); 		//9-bit Subtractor
	sobel_add_nb #(9) S6 (.a(p1),.b(p7),.ans_out(p1_p7),.subtract(1'b1),.cout()); 		//9-bit Subtractor


	`ifndef axc_11
	assign center_3 = p1_p7 << 1; 
	`else

	assign center_3 = {p1_p7[8:`k],1'b0,p1_p7[`k-1:0]}  << 1; 
	`endif

	sobel_add_nb #(9) S7 (.a(p2),.b(p8),.ans_out(p2_p8),.subtract(1'b1),.cout()); 		//9-bit Subtractor



	`ifndef axc_5
		`ifndef axc_18
		sobel_add_nb #(9) S8 (.a(p2_p8),.b(p0_p6),.ans_out(center_tm),.subtract(1'b0),.cout(add_out_3));  	//9-bit Adder
		`else
		sobel_add_nb #(9) S8 (.a(p2_p8),.b({p0_p6[8:`k],1'b0,p0_p6[`k-1:0]}),.ans_out(center_tm),.subtract(1'b0),.cout(add_out_3));  	//9-bit Adder
		`endif
	`else
	sobel_add_nb #(9) S8 (.a({p2_p8[8:`k],1'b0,p2_p8[`k-1:0]}),.b(p0_p6),.ans_out(center_tm),.subtract(1'b0),.cout(add_out_3));  	//9-bit Adder
	`endif


	`ifndef axc_26
		`ifndef axc_24
		 assign center_4 = {add_out_3,center_tm};
		`else
		 assign center_4 = {add_out_3,{center_tm [8:`k],1'b0,center_tm [`k-1:0]}  };
		`endif
	assign center_4 = {1'b0,center_tm};
	`endif
		

	`ifndef axc_4
		`ifndef axc_8
		sobel_add_nb #(10) S9 (.a(center_3),.b(center_4),.ans_out(gy_temp),.subtract(1'b0),.cout(add_out_4));  //10-bit Adder
		`else
		sobel_add_nb #(10) S9 (.a({center_3[9:`k],1'b0,center_3[`k-1:0]}),.b(center_4),.ans_out(gy_temp),.subtract(1'b0),.cout(add_out_4));  //10-bit Adder
		`endif
	`else
	sobel_add_nb #(10) S9 (.a(center_3),.b({center_4[9:`k],1'b0,center_4[`k-1:0]}),.ans_out(gy_temp),.subtract(1'b0),.cout(add_out_4));  //10-bit Adder
	`endif


	`ifndef axc_14
		`ifndef axc_19
		assign gy = {add_out_4,gy_temp};
		`else
		assign gy = {add_out_4,{gy_temp[9:`k],1'b0,gy_temp[`k-1:0]}  };
		`endif
	`else
	assign gy = {1'b0,gy_temp};
	`endif

	

	always @(posedge clk)
	begin
		`ifndef axc_2
		gx_reg <= gx;
		`else
		gx_reg <= {gx[10:`k],1'b0,gx[`k-1:0]}; 
		`endif
		`ifndef axc_17
		gy_reg <= gy;
		`else
		gy_reg <= {gy[10:`k],1'b0,gy[`k-1:0]}; 
		`endif
	end


	not_11b N0 (gx_reg,gx_comp);
	not_11b N1 (gy_reg,gy_comp);
	
	sobel_add_nb #(11) S10 (.a(11'b1), .b(gx_comp), .ans_out(gx_2s_comp), .subtract(1'b0), .cout());	//11-bit Adder
	sobel_add_nb #(11) S11 (.a(11'b1), .b(gy_comp), .ans_out(gy_2s_comp), .subtract(1'b0), .cout());	//11-bit Adder

	`ifndef axc_1
	mux_11b M0 (gx_reg, gx_2s_comp, gx_reg[8], abs_gx);
	`else
	mux_11b M0 (gx_reg, {gx_2s_comp[10:`k],1'b0,gx_2s_comp[`k-1:0]}, gx_reg[8], abs_gx);
	`endif



	`ifndef axc_15
	mux_11b M1 (gy_reg, gy_2s_comp, gy_reg[8], abs_gy);
	`else
	mux_11b M1 (gy_reg, {gy_2s_comp  [10:`k],1'b0,gy_2s_comp  [`k-1:0]}, gy_reg[8], abs_gy);
	`endif

	`ifndef axc_16
	sobel_add_nb #(11) S12 (.a(abs_gx), .b(abs_gy), .ans_out(sum), .subtract(1'b0), .cout());	//11-bit Adder
	`else	
	sobel_add_nb #(11) S12 (.a({abs_gx [10:`k],1'b0,abs_gx [`k-1:0]} ), .b(abs_gy), .ans_out(sum), .subtract(1'b0), .cout());	//11-bit Adder
	`endif

	`ifndef axc_25
		`ifndef axc_25_1
		mux_8b M2 (sum[7:0], 8'hff, sum[8], out); 
		`else
		mux_8b M2 (sum[7:0], 8'hff, 1'b0, out); 
		`endif
	`else
	 mux_8b M2 ({sum[7:`k],1'b0,sum[`k-1:0]}, 8'hff, sum[8], out); 
	`endif


endmodule
