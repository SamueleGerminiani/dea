`timescale 1ns/1ps

`define BIT_WIDTH 32
`define FRACTIONS 15


module inv_kin_tb;
	reg [`BIT_WIDTH-1:0] x,y;
	wire [`BIT_WIDTH-1:0] theta1,theta2;
	reg clock,rst;
    integer i=0;
    integer f=0;

	initial begin
        f = $fopen("IO/out/output.txt","w");
        $fwrite(f,"x,y,theta1,theta2\n");
		$display("theta1, theta2, theta2_num, theta1_num, theta1_in, theta2_in");
		clock = 0;
		#2 rst = 0;
		#100 rst =  1;
		#10 rst = 0;
        //init random
		    x = {$urandom(7) % 100000} << `FRACTIONS; 
		    y = {$urandom(7) % 100000} << `FRACTIONS; 

        for (i = 0; i < 100; i=i+1) begin
		    x = {$urandom % 100} << `FRACTIONS; 
		    y = {$urandom % 100} << `FRACTIONS; 
            $display("%b.%b,%b.%b,%b.%b,%b.%b,",theta1[31:15],theta1[14:0],theta2[31:15],theta2[14:0],x[31:15],x[14:0],y[31:15],y[14:0]);
            $fwrite(f,"%d,%d,%d,%d\n",x,y,theta1,theta2);
            #2000;
        end

    $fclose(f); 
	$finish;

	end

	always begin
	#10 clock <= ~clock;
	end


	inv_kin X1 (x, y, theta1, theta2, clock, rst);

	
endmodule
