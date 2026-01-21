//ТЕПЕРЬ РАССМОТРИМ ЦИКЛ "for" НА ПРИМЕРЕ СИНХРОННОЙ ОЗУ
module test (                          // Это если что, верхний модуль, важно помнить, что здесь мы можем задавать параметры, значения для других модулей ниже
             input A, 
             input [3:0]D, 
             input WR,
             output [3:0]MXY);        
    wire [7:0]Q;
    wire [1:0]DCY;
    DC#(2) DC(.Y(DCY), .E(WR), .X(A)); //DC#(2), потому что 2 регистра

    generate
        genvar i;                          //Это такая переменная i, а вернее константное выражение i
        for (i = 0; i < 8; i = i + 1)     //for позволяет нам многократно дублировать строчки кода, чтобы не писать их руками, не копипастить
            begin: z
                DVT DVT(.V(DCY[i[2]]), .D(D[i[1:0]]), .C(C), .Q(Q[i])); /* Q у нас [7:0] и переменная i у нас тоже [7:0], поэтому в Q подставляем i 
                                                                           V(DCY[i[2]], потому что в V у нас 0 или 1, поэтому берем 2-й разряд i 
                                                                           D у нас 4 разряда имеет, поэтому берем i с 0 до 1 разряда */
            end
    endgenerate

    /*DVT DVT0(.V(DCY[0]), .D(D[0]), .C(C), .Q(Q[0]));               //1-й разряд первого регистра 
    DVT DVT1(.V(DCY[0]), .D(D[1]), .C(C), .Q(Q[1]));               //2-й разряд первого регистра 
    DVT DVT2(.V(DCY[0]), .D(D[2]), .C(C), .Q(Q[2]));               //3-й разряд первого регистра 
    DVT DVT3(.V(DCY[0]), .D(D[3]), .C(C), .Q(Q[3]));               //4-й разряд первого регистра 

    DVT DVT4(.V(DCY[1]), .D(D[0]), .C(C), .Q(Q[4])); 
    DVT DVT5(.V(DCY[1]), .D(D[1]), .C(C), .Q(Q[5])); 
    DVT DVT6(.V(DCY[1]), .D(D[2]), .C(C), .Q(Q[6]));               
    DVT DVT7(.V(DCY[1]), .D(D[3]), .C(C), .Q(Q[7])); */     //Я это закомментил, потому что это не используем, так как использовали for выше          

    MX #(.N(2), .B(4)) MX(.Y(MXY), .A(A), .X(Q));        // N=2, потому что 2 регистра, B=4, потому что каждый регистр 4-х разрядный
endmodule

module DVT(input V, D, input C, output Q);  //Из D триггера делаем DV триггер

	    DFF DT (
				.d(V? D : Q),         // Это по сути наши данные в D триггер 
				.clk(C),       // Это clk, наш тактовый сигнал для D Триггера
				.clrn(1'd1),   // Это Асинхронный сброс, он нам не нужен, поэтому ставим 1, так как инверсия
				.prn(1'd1),    // Это асинхронный вход установки (тоже нам не нужен и тоже инверсный)
				.q(Q)          // Ну а это логично - выход
				);
endmodule

module MX # (parameter N=5, B=2) (input [N*B-1:0]X, input [G-1:0]A, output [B-1:0]Y); /*Это MUX, он нам нужен для ОЗУ,
                                                                                        function и integer я разберу позже, пока что просто оставлю это здесь */
    localparam G = Log(N);                            
    wire [N*B-1:0]Temp = X >> A*B; 
    assign Y = Temp[B-1:0];    
    function integer Log(input [31:0]N);
        integer i;
        for (i = 0; 2**i < N; i = i+1);
        Log = i + 1; 
    endfunction
endmodule

module DC# (parameter N=2) (output [N-1:0]Y, input E, input [G-1:0]X);
    localparam G = Log(N);
    assign Y = E << X;
    function integer Log(input [31:0]N);
        integer i;
        for (i = 0; 2**i < N; i = i+1)
        Log = i + 1; 
    endfunction
endmodule