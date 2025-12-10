module counter (            // 4-bit counter with load, increment, shift left, and shift right
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



/*Счетчик 4-бит с возможностью загрузки, инкремента, декремента, сдвига влево и сдвига вправо. 
  Этот модуль расширяет предыдущий, добавляя функциональность декремента. INC и DEC не должны быть активны одновременно. Желательно рассмотреть временные диаграммы для понимания работы счетчика.*/
module counter (           
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

//Еще один вариант счетчика с дополнительным сигналом W, который ограничивает максимальное значение счетчика.
module counter (
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




//Теперь создадим 4-битный счетчик с возможностью загрузки, инкремента, декремента, сдвига влево и сдвига вправо, а также с асинхронным сбросом.
module counter (
    input [3:0]D,
    input L,
    input R,                // R - Reset. Этот сигнал асинхронно сбрасывает счетчик в 0
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
end
endmodule




//Теперь создадим параметризируемый счетчик
module counter #(
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




//Информация о начальной инициализации 
//Обычно после конфигурации ПЛИС все регистры стоят в 0, но мы можем использовать блок "initial" для того, чтобы задать начальные значения
//Это по сути регистровое регулярное устройство. Можно вспомнить элементарные блоки из теории. Здесь по сути все состоить из "ЭБ"
module counter #(
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




