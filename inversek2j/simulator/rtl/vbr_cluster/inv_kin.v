//inv_kin.v
//theta1 = acos((x^2+y^2-11^2-12^2)/(2*11*12))
//
//
//theta2  = asin [y(11+12*cos(theta2))-x(12*sin(theta2))/(x^2+y^2)]
//
//
`include "deMacro.v"


`timescale 1ns/1ps

`define BIT_WIDTH 32
`define FRACTIONS 15
module inv_kin(x, y, theta1, theta2, clock, rst);



	input [`BIT_WIDTH-1:0] x, y;

	output [`BIT_WIDTH-1:0] theta1, theta2;

	input clock;
	input rst;

	wire [`BIT_WIDTH-1:0] xy_sum, cos_theta2_reg, sin_theta2_reg;
 	reg [`BIT_WIDTH-1:0] cos_theta2, sin_theta2;
	reg [`BIT_WIDTH-1:0] cos12, x_sqr, y_sqr, sin12;
	reg [`BIT_WIDTH-1:0]  part_1, part_y, part_x;
	wire [`BIT_WIDTH-1:0] theta2_num, theta1_num, theta2_in,theta1_in;
	wire [`BIT_WIDTH-1:0] x_sqr_reg, y_sqr_reg, part_y_reg, part_x_reg, cos12_reg, sin12_reg, part_1_reg;
	reg [`BIT_WIDTH-2:0] throw_away;
	reg signed_bit;
	wire overflow_flag;
	wire clock;
	reg start, done;

	wire [`BIT_WIDTH-1:0] _xy_sum, _cos_theta2_reg, _sin_theta2_reg;
 	wire [`BIT_WIDTH-1:0] _cos_theta2, _sin_theta2;
	wire [`BIT_WIDTH-1:0] _cos12, _x_sqr, _y_sqr, _sin12;
	wire [`BIT_WIDTH-1:0]  _part_1, _part_y, _part_x;
	wire [`BIT_WIDTH-1:0] _theta2_num, _theta1_num, _theta2_in,_theta1_in;
	wire [`BIT_WIDTH-1:0] _x_sqr_reg, _y_sqr_reg, _part_y_reg, _part_x_reg, _cos12_reg, _sin12_reg, _part_1_reg;
	wire _signed_bit;
	wire _overflow_flag;
	wire _start, _done;

    assign _xy_sum = `SAC(xy_sum,`MASK_xy_sum);
    assign _cos_theta2_reg = `SAC(cos_theta2_reg,`MASK_cos_theta2_reg);
    assign _sin_theta2_reg = `SAC(sin_theta2_reg,`MASK_sin_theta2_reg);
    assign _cos_theta2 = `SAC(cos_theta2,`MASK_cos_theta2);
    assign _sin_theta2 = `SAC(sin_theta2,`MASK_sin_theta2);
    assign _cos12 = `SAC(cos12,`MASK_cos12);
    assign _x_sqr = `SAC(x_sqr,`MASK_x_sqr);
    assign _y_sqr = `SAC(y_sqr,`MASK_y_sqr);
    assign _sin12 = `SAC(sin12,`MASK_sin12);
    assign _part_1 = `SAC(part_1,`MASK_part_1);
    assign _part_y = `SAC(part_y,`MASK_part_y);
    assign _part_x = `SAC(part_x,`MASK_part_x);
    assign _theta2_num = `SAC(theta2_num,`MASK_theta2_num);
    assign _theta1_num = `SAC(theta1_num,`MASK_theta1_num);
    assign _theta2_in = `SAC(theta2_in,`MASK_theta2_in);
    assign _theta1_in = `SAC(theta1_in,`MASK_theta1_in);
    assign _x_sqr_reg = `SAC(x_sqr_reg,`MASK_x_sqr_reg);
    assign _y_sqr_reg = `SAC(y_sqr_reg,`MASK_y_sqr_reg);
    assign _part_y_reg = `SAC(part_y_reg,`MASK_part_y_reg);
    assign _part_x_reg = `SAC(part_x_reg,`MASK_part_x_reg);
    assign _cos12_reg = `SAC(cos12_reg,`MASK_cos12_reg);
    assign _sin12_reg = `SAC(sin12_reg,`MASK_sin12_reg);
    assign _part_1_reg = `SAC(part_1_reg,`MASK_part_1_reg);
    assign _signed_bit = `SAC(signed_bit,`MASK_signed_bit);
    assign _overflow_flag = `SAC(overflow_flag,`MASK_overflow_flag);
    assign _start = `SAC(start,`MASK_start);
    assign _done = `SAC(done,`MASK_done);



	parameter const_1 = `BIT_WIDTH'b10000000100001001000000000000000;  // -(11^2 + 12^2)
	parameter const_2 = `BIT_WIDTH'b00000000100001000000000000000000;  // 11*12*2


		qmult #(`FRACTIONS,`BIT_WIDTH) x_multiplier(.i_multiplicand(x), .i_multiplier(x), .o_result(x_sqr_reg), .ovr(overflow_flag), .clk(clock), .rst(rst));
		qmult #(`FRACTIONS,`BIT_WIDTH) y_multiplier(.i_multiplicand(y), .i_multiplier(y), .o_result(y_sqr_reg), .ovr(overflow_flag), .clk(clock), .rst(rst));
		always @ (posedge clock) begin
			x_sqr <= _x_sqr_reg;
			y_sqr <= _y_sqr_reg;
			sin12 <= _sin12_reg;
			cos12 <= _cos12_reg;
			part_x<= _part_x_reg;
			part_y<= _part_y_reg;
			part_1<= _part_1_reg;
			sin_theta2 <= _sin_theta2_reg;
			cos_theta2 <= _cos_theta2_reg;
		end
		qadd #(`FRACTIONS,`BIT_WIDTH) xy_adder(.a(_x_sqr), .b(_y_sqr), .c(xy_sum));
		qadd #(`FRACTIONS,`BIT_WIDTH) num_adder(.a(const_1), .b(_xy_sum), .c(theta2_num));
		qdiv #(`FRACTIONS,`BIT_WIDTH) my_divider(.i_dividend(_theta2_num), .i_divisor(const_2), .i_start(1'b1), .i_clk(clock), .o_quotient_out(theta2_in), .rst(rst), 
		.o_complete(), .o_overflow());

		acos_lut U0 (_theta2_in,theta2);



		cos_lut U1 (theta2,cos_theta2_reg);
		sin_lut U2 (theta2,sin_theta2_reg);
		qmult #(`FRACTIONS,`BIT_WIDTH) cos_multiplier(.i_multiplicand(_cos_theta2), .i_multiplier(`BIT_WIDTH'b00000000000001100000000000000000), .o_result(cos12_reg), .ovr(overflow_flag), .clk(clock), .rst(rst));		
		qmult #(`FRACTIONS,`BIT_WIDTH) sin_multiplier(.i_multiplicand(_sin_theta2), .i_multiplier(`BIT_WIDTH'b00000000000001100000000000000000), .o_result(sin12_reg), .ovr(overflow_flag), .clk(clock), .rst(rst));
		qadd #(`FRACTIONS,`BIT_WIDTH) n_adder(.a(_cos12), .b(`BIT_WIDTH'b00000000000001011000000000000000), .c(part_1_reg));
		qmult #(`FRACTIONS,`BIT_WIDTH) multiplier_1(.i_multiplicand(_part_1), .i_multiplier(y), .o_result(part_y_reg), .ovr(overflow_flag), .clk(clock), .rst(rst));
		qmult #(`FRACTIONS,`BIT_WIDTH) multiplier_2(.i_multiplicand(_sin12), .i_multiplier(x), .o_result(part_x_reg), .ovr(overflow_flag), .clk(clock), .rst(rst));

	always@(_part_x) begin
		if (_part_x[31]) begin
			signed_bit=1'b0;
		end
		else begin
			signed_bit=1'b1;
		end
	end
		qadd #(`FRACTIONS,`BIT_WIDTH) adder_123 (.a({_signed_bit,_part_x[30:0]}), .b(_part_y), .c(theta1_num));
		qdiv #(`FRACTIONS,`BIT_WIDTH) m_divider(.i_dividend(_theta1_num), .i_divisor(_xy_sum), .i_start(1'b1), .i_clk(clock), .rst(rst), .o_quotient_out(theta1_in), 
		.o_complete(), .o_overflow());
		asin_lut U3 (_theta1_in,theta1);

endmodule
