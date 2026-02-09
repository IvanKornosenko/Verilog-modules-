// Case
module test (output reg [3:0]Y,
             input [1:0]X);

    always @(*)
    begin
        case(X)
        2'b00:
        begin
            Y = 0;
        end
        2'b01:
        begin
            Y = 2'd1;
        end
        2'b10:
        begin
            Y = 2'd2;
        end
        2'b11:
        begin
            Y = 2'd3;
        end
        endcase
    end
endmodule



// Casex
module test (output reg [3:0]Y,
             input [3:0]B);

    always @(*)
    begin
        casex(B)                  // Casex.
        4'bX00X:                  // Там, где X, может быть неизвестное любое значение, таким образом оператор casex на эти разряды с X внимание не обращает
        begin
            Y = 0;
        end
        4'bx01x:
        begin
            Y = 2'd1;
        end
         4'bx10x:
        begin
            Y = 2'd2;
        end
         4'bx11x:
        begin
            Y = 2'd3;
        end
        default:
        begin
            Y = 4'd15;
        end
        endcase
    end
endmodule
 //Честно, нужно будет позже более подробно рассмотреть этот оператор, в том числе смоделировать то, что я увидел на канале ПЛИСоводство, видео №5