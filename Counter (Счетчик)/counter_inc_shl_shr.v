module counter_inc_shl_shr (            // 4-bit counter with load, increment, shift left, and shift right
    input [3:0]D,
    input L,
    input INC,              // INC - Increment. Этот сигнал заставляет счетчик увеличивать свое значение на 1
    input SHL,
    input SHR,
    input C,
    output reg [3:0]Q);
always @(posedge C)
begin
    if(L)
    begin
        Q <= D;
    end
        else
        begin
            if(INC)
            begin
                Q <= Q + 1'd1;
            end
                else
                begin
                    if(SHL)                                 // Q3  Q2  Q1  Q0 Это принцип сдвига влево (SHL) В данном случае D0 загружается в младший разряд
                                                            // Q0  Q1  Q2  D0   
                    begin
                        Q <= {Q[2:0], D[0]};
                    end
                        else
                        begin
                            if(SHR)                         // Q3  Q2  Q1  Q0 Это принцип сдвига вправо (SHR)   В данном случае D3 загружается в старший разряд
                                                            // D3  Q3  Q2  Q1
                            begin
                                Q <= {D[3], Q[3:1]};
                            end
                        end
                end                
            end
end
endmodule





