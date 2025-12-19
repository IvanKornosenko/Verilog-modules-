/*Счетчик 4-бит с возможностью загрузки, инкремента, декремента, сдвига влево и сдвига вправо. 
  Этот модуль расширяет предыдущий, добавляя функциональность декремента. INC и DEC не должны быть активны одновременно. Желательно рассмотреть временные диаграммы для понимания работы счетчика.*/
module counter_inc_dec_shl_shr (           
    input [3:0]D,
    input L,
    input INC,              // INC - Increment. Этот сигнал заставляет счетчик увеличивать свое значение на 1
    input DEC,              // DEC - Decrement. Этот сигнал заставляет счетчик уменьшать свое значение на 1
    input SHL,
    input SHR,
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
                Q <= Q + 1'd1;
            end
                else
                begin
                    if(DEC)
                    begin
                        Q <= Q - 1'd1;
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