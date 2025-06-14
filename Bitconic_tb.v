`timescale 1ns/1ps

module bitconicSort_tb;
    logic clk, rst, valid_in;
    logic [0:63] in;  
    logic [0:63] out;  
    logic valid_out;

    bitconicSort dut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .valid_in(valid_in),
        .out(out),
        .valid_out(valid_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        valid_in = 0;
        in = 64'b0; 

        #100 rst = 0;  
        
        #100;        
        #10 in = {8'd35, 8'd12, 8'd24, 8'd9, 8'd15, 8'd44, 8'd31, 8'd50};
            valid_in = 1;
        #10 valid_in = 0;
        #100;

        //wait(valid_out);
        $display("Zestaw 1 - Posortowane wartości: %d %d %d %d %d %d %d %d", 
                 out[0:7], out[8:15], out[16:23], out[24:31], out[32:39], out[40:47], out[48:55], out[56:63]);

        repeat(20) begin
//            #10 in = {$random, $random, $random, $random, $random, $random, $random, $random};
            #10 in = {8'd7, 8'd6, 8'd5, 8'd4, 8'd3, 8'd2, 8'd1, 8'd0};
                valid_in = 1;
            #10 valid_in = 0;
            
            //wait(valid_out);
            #100;
            $display("Nowy zestaw - Posortowane wartości: %d %d %d %d %d %d %d %d", 
                     out[0:7], out[8:15], out[16:23], out[24:31], out[32:39], out[40:47], out[48:55], out[56:63]);
        end

//        #10 $finish;
    end
endmodule
