module clocktwlevehour(
    input clk,
    input reset,
    output [7:0] seg,
    output [7:0] seg2,
    output [3:0] digits1,
    output [3:0] digits2
    // input ena,
    ); 
     reg [7:0] hh;
    reg [7:0] mm;
    reg [7:0] ss;
    wire clk_1khz;
    
    Clock_Divider(clk,27'd49999999,clk_1khz);
    always @(posedge clk_1khz) begin
        if(reset) begin 
            hh[7:0] <= 8'b00010010;
            mm[7:0] <= 8'b00000000;
            ss[7:0] <= 8'b00000000;
            // pm <= 0;
            
        end
        
        else begin 
            
                if(ss[3:0] == 4'b1001) begin
                    ss[3:0] <= 4'b0000;
                    if (ss[7:4]==4'b0101) begin 
                    	ss[7:4] <= 4'b0000;
                        
                        if (mm[3:0] == 4'b1001) begin 
                            mm[3:0] <= 4'b0000;
                            
                            if (mm[7:4] == 4'b0101) begin 
                                mm[7:4] <= 4'b0000;
                                
                                if ( hh==8'b00010001) begin
                                    hh <= 8'b00010010;
                                    // pm <= ~pm;
                                end
                                else if (hh == 8'b00010010) begin
                                    hh <= 8'b00000001;
                                    
                                end
                                
                                else if (hh[3:0]== 4'b1001) begin
                                    hh[7:4] <= hh[7:4] + 1;
                                    hh[3:0] <= 4'b0000;
                                end
                                else begin
                                    hh[3:0] <= hh[3:0]+1;
                                end
                            end
                            else
                                begin
                                    mm[7:4] <= mm[7:4]+1;
                                end
                        end
                     	else begin
                            mm[3:0] <= mm[3:0]+1;
                     	end
                    end
                    else begin
                        ss[7:4] <= ss[7:4] + 1;
                    end
                end
                else begin
                    ss[3:0] <= ss[3:0] +1;
                end
                
            end
        end
    wire [15:0] bcd_input1;
    wire [7:0] bcd_input2;
    assign bcd_input1={mm,ss};
    assign bcd_input2 = hh;
    SevenSegmentController SSC1(clk,reset,bcd_input1,seg,digits1);
    SevenSegmentController SSC2(clk,reset,bcd_input2,seg2,digits2);
endmodule