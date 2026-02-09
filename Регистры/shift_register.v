//Сдвиговый регистр c параллельной загрузкой и сдвигом влево и вправо
module shift_register (output reg [3:0]Q,
             input [3:0]D, 
             input L, input SHL, input SHR, input C);
    always @(posedge C)
    begin
        if(L)
        begin
            Q <= D;
        end
            else
            begin
                if(SHL)                              //SH - это shift
                begin
                    Q <=  {Q[2:0], D[0]};
                end
                else if(SHR)
                begin 
                    Q <= {D[3], Q[3:1]};
                end
                                  //SR - это shift right
            end
    end
endmodule