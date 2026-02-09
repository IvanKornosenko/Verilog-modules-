//Регистр
module test (output reg [3:0]Q,                
             input [3:0]D, 
             input L, input C);
    always @(posedge C)
    begin
        if(L)                           //L - это load
        begin
            Q <= D;
        end
    end
endmodule



//Сдвиговый регистр c параллельной загрузкой
module test (output reg [3:0]Q,
             input [3:0]D, 
             input L, input SH, input C);
    always @(posedge C)
    begin
        if(L)
        begin
            Q <= D;
        end
            else
            begin
                if(SH)                              //SH - это shift
                begin
                    Q <=  {Q[2:0], D[0]};
                end
            end
    end
//Нужно не забывать, что этот регистр делает сдвиг и для напоминания как это работает, можно заглянуть в тетрадь
/*Вот для примера:
  Q3    Q2    Q1    Q0                У нас сюда загружаются эти значения  Q <=  {Q[2:1], D[0]};    D[9] является младшим, с него и начинается.
  Q2    Q1    Q0    D0                  */
endmodule
