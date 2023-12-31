`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2023 08:49:37 PM
// Design Name: 
// Module Name: policeSiren
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module clock(clk, enb, btn, mode, hour, min, sec, h1, h2, m1, m2, s1, s2);
    input clk;
    input enb;
//    input sw0, sw1;
    input [3:0] btn;
    input [3:0] mode;
    output reg [5:0] hour, min, sec;
    output [3:0] h1, h2, m1, m2, s1, s2;
    
    wire p0, p1, p2, p3;
    wire [3:0] p;
    edgeDetector e0(btn[0], clk, p0);
    edgeDetector e1(btn[1], clk, p1);
    edgeDetector e2(btn[2], clk, p2);
    edgeDetector e3(btn[3], clk, p3);

    assign p = {p3, p2, p1, p0};

    always @ (posedge clk) begin
        if(|p) begin
            if (mode == 0) begin
                case (p)
                    4'b1000:begin
                        if (hour >= 6'd23) hour <= 6'd0;
                        else hour <= hour + 6'd1;
                    end
                    4'b0100:begin
                        if (hour <= 6'd0) hour <= 6'd23;
                        else hour <= hour - 6'd1;
                    end                    
                    4'b0010: begin
                        if (min >= 6'd59) begin
                            min <= 0;
                            if (hour >= 6'd23) hour <= 6'd0;
                            else hour <= hour + 6'd1;
                        end
                        else min <= min + 6'd1;
                    end
                    4'b0001: begin
                        if (min <= 6'd0) begin
                            min <= 59;
                            if (hour <= 6'd0) hour <= 6'd23;
                            else hour <= hour - 6'd1;
                        end
                        else min <= min - 6'd1;
                    end
                endcase
            end
        end 
        else if(enb) begin
            if(sec >= 6'd59) begin   
                sec <= 0;
                if( min >= 6'd59) begin   
                    min <= 0;
                    if( hour >= 6'd23) hour <= 0;
                    else hour <= hour + 6'd1;
                end
                else min <= min + 6'd1;
            end
            else sec <= sec + 6'd1;
        end
    end
            
    assign h1 = hour / 6'd10;
    assign h2 = hour % 6'd10;
    assign m1 = min / 6'd10;
    assign m2 = min % 6'd10;
    assign s1 = sec / 6'd10;
    assign s2 = sec % 6'd10;
endmodule