module adder_tb();

reg clk;
wire [8:0] out;
reg [7:0] a,b;
reg [7:0] a0,b0;
integer count;

initial begin
    clk = 1'b0;
    count = 0;
    #1;
end

always @(negedge clk)
begin
    if(count > 1000)
    begin
        $finish;
    end
    else
    begin
        a0=$urandom;
        b0=$urandom;
        a=a0>>2;
        b=b0>>2;
        count = count + 1;
    end
end

always
begin
    #5 clk = ~clk;
end

adder U0 (clk,a,b,out);

endmodule
