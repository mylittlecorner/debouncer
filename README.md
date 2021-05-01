moduł topowy(dostarczamy modułom wejścia oraz odbiera z nich wyjścia) - s_top

wejście - BTN_NORTH, BTN_EAST, BTN_SOUTH, BTN_WEST, CLK,r_A, r_B

wyjście - LED, CLK_SMA, clk_o

wire(połączenie) - up_but, down_but, rotation(2 bity), cnt_out(3 bity)

////////////////////////////////////////////////////////////////////////////////

debouncer() - debouncer

wejście - clk, in_state (1 bit)

wyjście - out_state (1 bit)

parametr NBITS - 16

rejestr "COUNT" 16 bitów

rejestr PB_sync_0, PB_sync_1, PB_state - każdy z nich może przyjąć stan 1 lub 0(1 bit)

always @(posedge clk) PB_sync_0 <= ~in_state; (za każdym razem kiedy clk ma wysoki stan, przypisujemy do rejestru odwrotną wartość(kiedy jest 1 to przytpisujemy 0)

always @(posedge clk) PB_sync_1 <=  PB_sync_0; (za każdym razem kiedy clk ma wysoki stan, kopiujemy wartość z rejestru PB_sync_0 do PB_sync_1 )

wire PB_idle = (PB_state==PB_sync_1); (sygnał jest przekazywany kiedy stan rejestrów jest taki sam)

wire max_COUNT = &COUNT; ("&" powoduje, że jeśli wszystkie bity są ustawione na 1 czyli 1111111111111111, to max_COUNT przyjmuje wartość 1)


always @(posedge clk)
        begin
            if(PB_idle) COUNT <=0;
            else begin
                COUNT <= COUNT + 1;
                if(max_COUNT) PB_state <= ~PB_state;
            end
        end

(za każdym razem kiedy clk ma wysoki stan, jeśli rejestr PB_idle wynosi 1,zerujemy licznik, w innym wypadku inkrementujemy licznik. Jeśli max_COUNT wyniesie 1, odwracamy wartość, którą posiada PB_state i wypuszczamy ją na wyjście. Co robi debouncer? Pozwala upewnić się, że wciśnięty przycisk działa prawidłowo, czyli zlicza tyle przyciśnięć ile trzeba.

https://www.youtube.com/watch?v=jYOYgU2vlSE

przykład deboucera
////////////////////////////////////////////////////////////////////////////////

enkoder obrotowy - r_enc

wejścia - r_A, r_B, clk (1 bit)

wyjście - rlr (2 bity)

rejestry - reg r_A_in, r_B_in, reg [1:0] r_in (2 bity), r_q1, delay_r_q1, r_q2, r_event, r_left

always @(posedge clk)
    begin
        r_A_in <= r_A;
        r_B_in <= r_B;
        r_in <= {r_B_in, r_A_in};
        case(r_in)
            2'b00: begin r_q1 <= 0; r_q2 <= r_q2; end
            2'b01: begin r_q1 <= r_q1; r_q2 <= 0; end
            2'b10: begin r_q1 <= r_q1; r_q2 <= 1; end
            2'b11: begin r_q1 <= 1; r_q2 <= r_q2; end
            default: begin r_q1 <= r_q1; r_q2 <= r_q2; end
        endcase
    end
  
(za każdym razem kiedy clk ma wysoki stan, zapisujemy w rejestrze r_A_in sygnał z wejścia r_A(Tak samo dla r_B_in). r_in kopiuje te dwa rejestry do swojego pierwszego i drugiego bitu. Case na podstawie zestawionych 2 bitów wybiera jaką rejestry r_q1 i r_q2 mają przybrać wartość. )


always @(posedge clk)
    begin
        delay_r_q1 <= r_q1;
        if((r_q1 == 1) && (delay_r_q1 ==0))
        begin
            r_event <= 1; r_left <= r_q2;
        end
        else begin
            r_event <= 0; r_left <= r_left;
        end
        
    end
    assign rlr = {r_event, r_left};

(za każdym razem kiedy clk ma wysoki stan, kopiujemy do rejestru delay_r_q1 wartość z rejestru r_q1. Jeśli r_q1 przybiera wartość 1 i delay_r_q1 przyniera w tym samym czasie 0, przypisujemy wartość z rejestru r_q2 do rejestru r_left oraz przypisujemy rejestrowi r_event wartość 1. Jeśli instrukcja warunkowa się nie spełniła, r_event otrzymuje wartość 0 a rejestr r_left się nie zmienia. na sam koniec bierzemy flagi r_event oraz r_left i umieszczamy je w 2 bitowym rejestrze rlr.

https://www.youtube.com/watch?v=zYE5JhUMjys&t=152s

przykład enkodera obrotowego

////////////////////////////////////////////////////////////////////////////////

