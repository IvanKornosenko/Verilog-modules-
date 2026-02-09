//Поведенческое описание происходит с испольованием операторов высокого уровня. Здесь всегда используются always блоки
module test (           //Это все пример комбинационной схемы 
    input A, X0, X1,
    output reg Z);                

    always @(*)                  /* always это по сути бесконечный цикл выполнения условия. А (*) это условие для начала выполнения. Запись можно прочитать так
                                    Всегда(always) когда?(@) всегда(*) */          
        begin 
        if (A == 1'd1)
            begin
            Z = X1;
            end
        else
            begin
            Z = X0;
            end

        end
endmodule



//Теперь рассмотрим регистровую схему
module test (           
    input A, X0, X1,
    input C,
    output reg Z);                

    always @(posedge C)     //Posedge C значит по нарастающему фронту. Запись читается как "Всегда(always) когда?(@) когда есть нарастающий фронт C (posedge C)"     
        begin 
        if (A)
            begin
            Z = X1;         //Для регистровых переменных присвоение выполняется не с обычным знаком "=", а с "<="
            end
        else
            begin
            Z = X0;
            end

        end
endmodule



//Попробуем сделать RS-триггер
module test (           
    input A, R, S,
    input C,
    output reg Q);                

    always @(posedge C)         
        begin 
        if (R)                 //Кстати не обзательно писать R = 1, если написать R, то это значит больше 0
            begin
            Q <= 0;         
            end
            else
                begin
                if(S)
                    begin
                    Q <= 1'd1;
                    end
                else
                    begin
                    Q <= Q;
                    end
            end

        end
endmodule



//JK-триггер
module test (           
    input J, K,
    input C,
    output reg Q);                

    always @(posedge C)         
        begin 
            if (J & K)
              begin
               Q <= !Q;
              end
                else
                    begin
                    if (K)                 
                        begin
                        Q <= 0;         
                        end
                        else
                            begin
                            if(J)
                                begin
                                Q <= 1'd1;
                                end
                            end
                    end 
            
        end
endmodule


//Рассмотрим "case" он удобнее, чем if, так как здесь нет такой мешанины в виде if. И еще здесь неважен порядок переменных. в if он был важен
//JK-триггер
module test (           
    input J, K,
    input C,
    output reg Q);       
    
    always @(posedge C)
    begin
        case ({J,K})
            2'b00:
            begin
            Q <= Q;
            end

            2'b01:
            begin
            Q <= 0;
            end

            2'b10:
            begin
            Q <= 1'd1;
            end

            /*2'b11:
            begin
            Q <= !Q;                             //Закомментим это, чтобы это условие выполнялось в ветви default
            end  */
            
            default:                             /*Эта ветвь позволяет выполнить переменную или переменные, которые мы не указали выше. 
                                                То есть, если в случае перебора переменых сверху ничего не выполняется, то выполнится default */
            begin
            Q <= !Q;
            end

        endcase   
    end
endmodule



//Триггер с асинхронным сбросом 
module test (           
    input J, K,
    input C, aR,
    output reg Q);      
   always @(posedge C or posedge aR)  //aR - это просто асинхронный сброс.  posedge aR (в данном случае posedge это не верхний фронт, а просто положительный уровень)
   begin
        if(aR)
        begin 
            Q <= 0;
        end
        else
        begin
                case ({J,K})
                2'b00:
                begin
                    Q <= Q;
                end

                2'b01:
                begin
                    Q <= 0;
                end

                2'b10:
                begin
                    Q <= 1'd1;
                end

                /*2'b11:
                begin
                Q <= !Q;                             //Закомментим это, чтобы это условие выполнялось в ветви default
                end  */
            
                default:                                                                          
                begin
                    Q <= !Q;
                end

                endcase   
        end
   end
endmodule



//Сделаем такой же триггер, но добавим установку (aS)
module test (           
    input J, K,
    input C, aR, aS,
    output reg Q);      
   always @(posedge C or posedge aR or posedge aS) 
    begin
        if(aR)                                                           //У сбрса приоритет выше
        begin 
        Q <= 0;
        end
            else
            begin
                if(aS)
                begin
                Q <= 1'd1;
                end
                else
                    begin
                        case ({J,K})
                        2'b00:
                        begin
                        Q <= Q;
                        end

                        2'b01:
                        begin
                        Q <= 0;
                        end

                        2'b10:
                        begin
                        Q <= 1'd1;
                        end

                        /*2'b11:
                        begin
                        Q <= !Q;                             //Закомментим это, чтобы это условие выполнялось в ветви default
                        end  */
                            
                        default:                                                                          
                        begin
                        Q <= !Q;
                        end

                        endcase   
                    end
            end        
    end
endmodule



//Блокирующее и неблокирующее присваивание (= и <=)
module test (output reg Q, X1, X2, X3,
             input X0,
             input C);

    always @(posedge C)
    begin 
        X1 = X0;           //Это блокирующее присваивание. При его применении, у нас происходит мгновенное выполнение. В этом примере у нас все строки выполняются ЗА ОДИН ТАКТ
        X2 = X1;
        X3 = X2;
        Q  = X3;

//      X1 <= X0;           //Это неблокирующее присваивание. В этом случае происходит ступенчатое выполнение (за первый такт - первая строка, за второй - вторая) 
//      X2 <= X1;
//      X3 <= X2;
//      Q  <= X3;
    end
//Рекомендация: Неблокирующее присваивание использовать в регистровых схемах, а блокирующее в комбинационных. И не стоит смешивать в одном коде оба этих присваивания
endmodule
  
//Рассмотрим пример, когда это важно. Сделаем на примере RS-триггера

module test (output reg Q,
             input R, S, X,
             input C);
    reg A, B;
    always @(posedge C)
    begin
        A <= X; //Если здесь вместо <= поставить =, то можно будет наглядно посмотреть в RTL Viewer, что со схемой сделает компилятор. 
        B <= A; //

        if(A & !B)
        begin
            Q <= 0;
        end
            else
            begin
                if (S)
                begin
                    Q <= 1'd1;
                end
            end
    end
endmodule




//Это обычный DV триггер c асинхронным сбросом
module test (output reg Q,
             input V, D,
             input C, aR);

    always @(negedge C or negedge aR)  //negedge C - "по нисходящему фронту"
                                       //negedge aR в данном случае - "это по уровню 0" posedge aR означало бы "по уровню 1"
    begin
        if(!aR)                        //Так как указали negedge aR, то здесь должна быть инверсия
        begin 
            Q <= 0;
        end
            else
            begin
                if(V)
                begin
                    Q <= D;
                end
            end
    end
endmodule

            



