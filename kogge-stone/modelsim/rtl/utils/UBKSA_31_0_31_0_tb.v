module UBKSA_31_0_31_0_tb;
wire [32:0] s;
reg [31:0] x;
reg [31:0] y;
reg [32:0] my_out;
initial begin
	$monitor("Time = %t, x=%d, y=%d, s=%d, my_out=%d", $time, x, y, s,my_out);
	repeat(10) begin
		#1;
		x = $random;
		y = $random;
		my_out=x+y;
	end
end
UBKSA_31_0_31_0 U0(s,x,y);
endmodule
