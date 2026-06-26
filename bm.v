module bm(
input CLOCK_50,
input [8:0] SW,
input [1:0] KEY,
output [7:0] LEDR,
output reg [6:0] HEX0,
output reg [6:0] HEX1,
output reg [6:0] HEX2
);

wire start = ~KEY[0];
wire reset = ~KEY[1];

reg signed [3:0] M;
reg signed [3:0] Q;
reg signed [4:0] A;
reg Q_1;

reg [2:0] count;
reg signed [7:0] result;


reg signed [4:0] A_tmp;
reg signed [3:0] Q_tmp;
reg Q1_tmp;



always @(posedge CLOCK_50 or posedge reset)
begin
    if(reset)
    begin
        A <= 0;
        Q <= 0;
        M <= 0;
        Q_1 <= 0;
        count <= 0;
        result <= 0;
    end

    else if(start && count==0)
    begin
        M <= $signed(SW[3:0]);   
        Q <= $signed(SW[7:4]);  
        A <= 0;
        Q_1 <= 0;
        count <= 4;
    end

    else if(count>0)
    begin
       
        A_tmp = A;

        case({Q[0],Q_1})
            2'b01: A_tmp = A + M;
            2'b10: A_tmp = A - M;
        endcase

       
        Q1_tmp = Q[0];
        Q_tmp  = {A_tmp[0], Q[3:1]};
        A_tmp  = {A_tmp[4], A_tmp[4:1]};

       
        A <= A_tmp;
        Q <= Q_tmp;
        Q_1 <= Q1_tmp;

        count <= count - 1;

        if(count == 1)
            result <= {A_tmp[3:0], Q_tmp};
    end
end

assign LEDR = result;

reg signed [7:0] abs_result;
reg [3:0] tens;
reg [3:0] ones;

always @(*)
begin
    if(result < 0)
        abs_result = -result;
    else
        abs_result = result;

    tens = abs_result / 10;
    ones = abs_result % 10;
end



always @(*)
begin
case(ones)
0: HEX0=7'b1000000;
1: HEX0=7'b1111001;
2: HEX0=7'b0100100;
3: HEX0=7'b0110000;
4: HEX0=7'b0011001;
5: HEX0=7'b0010010;
6: HEX0=7'b0000010;
7: HEX0=7'b1111000;
8: HEX0=7'b0000000;
9: HEX0=7'b0010000;
default: HEX0=7'b1111111;
endcase
end



always @(*)
begin
case(tens)
0: HEX1=7'b1000000;
1: HEX1=7'b1111001;
2: HEX1=7'b0100100;
3: HEX1=7'b0110000;
4: HEX1=7'b0011001;
5: HEX1=7'b0010010;
6: HEX1=7'b0000010;
7: HEX1=7'b1111000;
8: HEX1=7'b0000000;
9: HEX1=7'b0010000;
default: HEX1=7'b1111111;
endcase
end



always @(*)
begin
if(result < 0)
HEX2 = 7'b0111111;   
else
HEX2 = 7'b1111111;   
end

endmodule
