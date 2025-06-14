`timescale 1ns/1ps

module comp_maxMin( //BN
    input logic clk, rst,
    input logic [0:7] A, B,
    output logic [0:7] max, min
);
    always_ff @(posedge clk) begin
        if (rst == 0) begin
            min <= 8'b0;
            max <= 8'b0;
        end
        else begin
            if (A < B) begin
                min <= A;
                max <= B;
            end
            else begin
                min <= B;
                max <= A;
            end
        end
    end
endmodule

module comp_minMax( // BN1
    input logic clk, rst,
    input logic [0:7] A, B,
    output logic [0:7] max, min
);
    always_ff @(posedge clk) begin
        if (rst == 0) begin
            min <= 8'b0;
            max <= 8'b0;
        end
        else begin
            if (A < B) begin
                min <= B;  // Odwr?cone
                max <= A;
            end else begin
                min <= A;
                max <= B;
            end
        end
    end
endmodule

module bitconicSort(
    input  logic clk, rst,
    input  logic [0:63] in,   // input
    input  logic valid_in, 
    output logic [0:63] out,  // output
    output logic valid_out
);

reg[0:7] A1, A2, A3 ,A4, A5, A6, A7, A8, A9 ,A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20;
reg[0:7] B1, B2, B3, B4, B5, B6, B7, B8, B9, B10, B11, B12, B13, B14, B15, B16, B17, B18, B19, B20;
logic [0:5] valid_ctr;
logic sort_started;
logic [0:63] in_reg;
  
    // Stage 1
    comp_minMax minMax_1_1(clk, rst, in_reg [0:7], in_reg[ 8:15], A1, B1); //BN1
    comp_maxMin maxMin_1_2(clk, rst, in_reg[16:23], in_reg[24:31], A2, B2); //BN
    comp_minMax minMax_1_3(clk, rst, in_reg[32:39], in_reg[40:47], A3, B3); //BN1
    comp_maxMin minMin_1_4(clk, rst, in_reg[48:55], in_reg[56:63], A4, B4); //BN     
    
    // Stage 2            
    comp_minMax minMax_2_1(clk, rst, A1, A2,  A5, B5); //BN1
    comp_minMax minMax_2_2(clk, rst, B1, B2,  A6, B6); //BN1
    comp_maxMin maxMin_2_3(clk, rst, A3, A4,  A7, B7); //BN
    comp_maxMin maxMin_2_4(clk, rst, B3, B4,  A8, B8); //BN 
    
    // stage 3 
    comp_minMax minMax_3_1(clk, rst, A5, A6,  A9, B9); //BN1
    comp_minMax minMax_3_2(clk, rst, B5, B6,  A10, B10); //BN1
    comp_maxMin maxMin_3_3(clk, rst, A7, A8,  A11, B11); //BN
    comp_maxMin maxMin_3_4(clk, rst, B7, B8,  A12, B12); //BN 
    
    // stage 4
    comp_minMax minMax_4_1(clk, rst, A9, A11,  A13, B13); //BN1
    comp_minMax minMax_4_2(clk, rst, B9, B11,  A14, B14); //BN1
    comp_minMax minMax_4_3(clk, rst, A10, A12,  A15, B15); //BN1
    comp_minMax minMax_4_4(clk, rst, B10, B12,  A16, B16); //BN1
    
    // stage 5
    comp_minMax minMax_5_1(clk, rst, A13, A15,  A17, B17); //BN1
    comp_minMax minMax_5_2(clk, rst, A14, A16,  A18, B18); //BN1
    comp_minMax minMax_5_3(clk, rst, B13, B15,  A19, B19); //BN1
    comp_minMax minMax_5_4(clk, rst, B14, B16,  A20, B20); //BN1
    
    // stage 6
    comp_minMax minMax_6_1(clk, rst, A17, A18, out[ 0: 7], out[8:15]); //BN1
    comp_minMax minMax_6_2(clk, rst, B17, B18, out[16:23], out[24:31]); //BN1
    comp_minMax minMax_6_3(clk, rst, A19, A20, out[32:39], out[40:47]); //BN1
    comp_minMax minMax_6_4(clk, rst, B19, B20, out[48:55], out[56:63]); //BN1

    
    always_ff @(posedge clk) begin
    if (rst == 0) begin
//        out <= '{default:'0};
        valid_ctr <= 0;
        valid_out <= 0;
        sort_started <= 0;
    end else begin 
        if (valid_in == 1 && sort_started == 0) begin
            in_reg <= in;  
            sort_started <= 1;
            valid_out <= 0;  
        end        

        if (sort_started == 1) begin
            valid_ctr <= valid_ctr + 1;              
        end

        if (sort_started == 1 && valid_ctr >= 6) begin
            valid_out <= 1;
            valid_ctr <= 0;
            sort_started <= 0;  
        end
    end
end
    
endmodule
