//Информация о начальной инициализации 
//Обычно после конфигурации ПЛИС все регистры стоят в 0, но мы можем использовать блок "initial" для того, чтобы задать начальные значения
//Это по сути регистровое регулярное устройство. Можно вспомнить элементарные блоки из теории. Здесь по сути все состоить из "ЭБ"
module counter_block_initial #(
    parameter N = 4) (
    input [N - 1:0]D,
    input L,
    input R,                // R - Reset. Этот сигнал асинхронно сбрасывает счетчик в 0
    input INC,              // INC - Increment. Этот сигнал заставляет счетчик увеличивать свое значение на 1
    input W,                // W - Wrap. Этот сигнал ограничивает максимальное значение счетчика 
    input DEC,              // DEC - Decrement. Этот сигнал заставляет счетчик уменьшать свое значение на 1                                      
    input SHL,
    input SHR,
    input C,
    output reg [N - 1:0]Q);

initial
begin
    Q <= 10;                // Начальное значение счетчика
end
always @(posedge C)
begin
    if(R)               
    begin
        Q <=0;             // Cброс счетчика в 0
    end 
        else
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
                                    Q <= {N{1'd1}};  // Максимальное значение для N-битного счетчика
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
                                                Q <= {Q[N-2:0], D[0]};
                                            end
                                                else
                                                begin
                                                    if(SHR)
                                                    begin
                                                        Q <= {D[N-1], Q[N-1:1]};
                                                    end
                                                end
                                        end        
                            end
                end
        end
end
endmodule