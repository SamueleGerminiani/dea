module adder( clk, a, b, out);
input  [7:0] a,b;
input clk;
output [8:0] out;					

reg [8:0] sum;					


always @(posedge clk)
begin
    sum=a+b;
end

assign out=sum;

endmodule
