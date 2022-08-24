
`define SA(SIGNAL,SIZE) \
`ifdef SIGNAL  \
    {SIGNAL & ~({{SIZE-1{1'b0}}, 1'b1} << `bit)}\
`else\
    SIGNAL\
`endif

module adder( clk, a, b, out);
input  [7:0] a,b;
input clk;
output [8:0] out;					

reg [8:0] sum;					

always @(posedge clk)
begin
    sum=`SA(a,8)+`SA(b,8);
end

assign out=sum;

endmodule
