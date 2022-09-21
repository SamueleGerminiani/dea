module UBBKA_31_0_31_0_tb;
wire [32:0] s;
reg [31:0] x;
reg [31:0] y;
reg clk;
always begin
    #5 clk=~clk;
end
initial begin
    clk=0;
	$monitor("Time = %t, x=%d, y=%d, s=%d", $time, x, y, s);
    #5;
	repeat(10) begin
		x = $random;
		y = $random;
        #10;
	end
    $finish;
end
UBBKA_31_0_31_0 U0(s,x,y);
endmodule
