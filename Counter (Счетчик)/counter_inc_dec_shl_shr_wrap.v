//Еще один вариант счетчика с дополнительным сигналом W, который ограничивает максимальное значение счетчика.
module counter_inc_dec_shl_shr_wrap (
    input [3:0]D,
    input L,
    input INC,              // INC - Increment. Этот сигнал заставляет счетчик увеличивать свое значение на 1
    input W,                // W - Wrap. Этот сигнал ограничивает максимальное значение счетчика 
                            // Если счетчик достигает значения W и получает сигнал INC, он сбрасывается в 0
    input SHL,
    input SHR,
    input DEC,              // DEC - Decrement. Этот сигнал заставляет счетчик уменьшать свое значение на 1
    input C,
    output reg [3:0]Q);
always @(posedge C)
begin
    if(L)
    begin
        Q <=D;
    end
        else
        begin
            if(INC)
            begin
                if(Q >= W)      // Если счетчик достигает значения W и получает сигнал INC, он сбрасывается в 0
                begin
                    Q <= 0;
                end
                    else
                    begin
                        Q <= Q + 1'd1;
                    end
            end
                else
                begin
                    if(DEC)
                    begin
                        if(Q <= W)     // Если счетчик достигает значения W и получает сигнал DEC, он устанавливается в максимальное значение 15
                        begin
                            Q <= 4'd15;   // Максимальное значение для 4-битного счетчика
                        end
                            else
                            begin
                                Q <= Q - 1'd1;
                            end
                    end
                
                                else
                                begin
                                    if(SHL)
                                    begin
                                        Q <= {Q[2:0], D[0]};
                                    end
                                        else
                                        begin
                                            if(SHR)
                                            begin
                                                Q <= {D[3], Q[3:1]};
                                            end
                                        end
                                end        
                    end
        end
end
endmodule