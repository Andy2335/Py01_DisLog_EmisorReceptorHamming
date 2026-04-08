// ============================================================
// MODULO PRINCIPAL: Emisor con codificador Hamming(7,4)
// Integra:
// 1) hamming74_encoder
// 2) bin_to_7seg
// 3) error_inserter
//
// Autor base: Andres Obregon Lopez / Mariana Solano Gutierrez
// Integracion realizada en un solo archivo
// ============================================================



// ============================================================
// TOP MODULE
// ============================================================
module top (
    input  logic [3:0] data_in,        // Dato original de 4 bits
    input  logic [2:0] BitError,       // 0 = sin error, 1..7 = bit a alterar
    output logic [6:0] code_out,       // Palabra Hamming generada
    output logic [6:0] transmision,    // Palabra transmitida con posible error
    output logic [6:0] seg             // Display 7 segmentos del dato original
);
    // --------------------------------------------------------
    // Instancia del decodificador a 7 segmentos
    // Aquí se muestra el dato original de 4 bits
    // --------------------------------------------------------
    bin_to_7seg #(
        .COMMON_ANODE(1'b0)
    ) U3 (
        .bin_in (data_in),
        .seg    (seg)
    );

    // --------------------------------------------------------
    // Instancia del codificador Hamming(7,4)
    // --------------------------------------------------------
    hamming74_encoder U1 (
        .data_in  (data_in),
        .code_out (code_out)
    );

    // --------------------------------------------------------
    // Instancia del generador/inserción de error
    // --------------------------------------------------------
    error_inserter U2 (
        .BitError    (BitError),
        .WordHamming (code_out),
        .transmision (transmision)
    );

endmodule



// ============================================================
// MODULO 5.1: Paridad Par Hamming(7,4)
// ============================================================
module hamming74_encoder (
    input  logic [3:0] data_in,   // {d3,d2,d1,d0}
    output logic [6:0] code_out   // {p1,p2,d3,p4,d2,d1,d0}
);

    logic p1, p2, p4;

    always_comb begin
        // Paridad par
        p1 = data_in[3] ^ data_in[2] ^ data_in[0];
        p2 = data_in[3] ^ data_in[1] ^ data_in[0];
        p4 = data_in[2] ^ data_in[1] ^ data_in[0];

        // Palabra Hamming (7,4)
        code_out[6] = p1;         // posición 1
        code_out[5] = p2;         // posición 2
        code_out[4] = data_in[3]; // posición 3 = d3
        code_out[3] = p4;         // posición 4
        code_out[2] = data_in[2]; // posición 5 = d2
        code_out[1] = data_in[1]; // posición 6 = d1
        code_out[0] = data_in[0]; // posición 7 = d0
    end

endmodule



// ============================================================
// MODULO 5.2: Display de 7 segmentos
// ============================================================
module bin_to_7seg (
    input logic [3:0] sw,           // Bits de entrada: AIN ,BIN ,CIN ,DIN (MSB a LSB)
    output logic [6:0] segments     // Segments: SA, SB, SC, SD, SE, SF, SG (LSB a MSB)
);
// Definicion de bits de entrada y sus negados para facilitar la expresion de las funciones logicas de cada segmento
logic AIN, BIN, CIN, DIN;
logic AIN_N, BIN_N, CIN_N, DIN_N;
logic SA, SB, SC, SD, SE, SF, SG;

/*Asignacion de los bits de entrada */
assign AIN = sw[3];
assign BIN = sw[2];
assign CIN = sw[1];
assign DIN = sw[0];

/*Asignacion de operadores logicos reutilizados - NOT*/
assign AIN_N = ~AIN;
assign BIN_N = ~BIN;
assign CIN_N = ~CIN;
assign DIN_N = ~DIN;


/*Expresiones logicas para cada segmento*/

//Segmento A: SA = Din'(Ain+Bin')+Ain'(Cin+BinDin)+BinCin+AinBin'Cin'
assign SA = (DIN_N) & (AIN | BIN_N) | 
            (AIN_N) & (CIN | (BIN & DIN)) | 
            (BIN & CIN) | 
            (AIN & BIN_N & CIN_N);  

//Segmento B: SB = Bin'(Ain' + Din') + Ain'(Cin ⊙ Din) + Ain Din Cin'
assign SB = (BIN_N) & (AIN_N | DIN_N) | 
            (AIN_N) & (~(CIN ^ DIN)) | 
            (AIN & DIN & CIN_N);

//Segmento C: SC = AinBin' + Ain'(Bin + Din + Cin') + DinCin'
assign SC = (AIN & BIN_N) | 
            (AIN_N) & (BIN | DIN | CIN_N) | 
            (DIN & CIN_N);   

//Segmento D: SD = Din'(Ain'Bin' + BinCin + AinCin') + Din(BinCin' + Bin'Cin)
assign SD = (DIN_N & (AIN_N & BIN_N | BIN & CIN | AIN & CIN_N)) | 
            (DIN & (BIN & CIN_N | BIN_N & CIN));

//Segmento E: SE = Din'(Bin'+Cin) + Ain(Cin + Bin)
assign SE = (DIN_N & (BIN_N | CIN)) | 
            (AIN & (CIN | BIN));

//Segmento F: SF = Ain(Cin + Bin') + Din'(Bin + Cin') + Ain'BinCin'
assign SF = (AIN & (CIN | BIN_N)) | 
            (DIN_N & (BIN | CIN_N)) | 
            (AIN_N & BIN & CIN_N);

//Segmento G: SG = Ain(Din + Bin') + Cin(Bin' + Din') + Ain'BinCin'
assign SG = (AIN & (DIN | BIN_N)) | 
            (CIN & (BIN_N | DIN_N)) | 
            (AIN_N & BIN & CIN_N);

/*Asignacion de los bits de salida */
assign segments[0] = SA;
assign segments[1] = SB;
assign segments[2] = SC;
assign segments[3] = SD;
assign segments[4] = SE;
assign segments[5] = SF;
assign segments[6] = SG;

endmodule



// ============================================================
// MODULO 5.3: Insercion de error
// Convencion usada:
// BitError = 3'b000 -> sin error
// BitError = 3'b001 -> invierte bit 0
// BitError = 3'b010 -> invierte bit 1
// ...
// BitError = 3'b111 -> invierte bit 6
// ============================================================
module error_inserter (
    input  logic [2:0] BitError,
    input  logic [6:0] WordHamming,
    output logic [6:0] transmision
);

    always @(*) begin
        transmision = WordHamming; // Copiar la palabra Hamming a la transmision inicialmente correcta

        if (BitError < 7)
            // Inversión de un bit especifico en transmision según el valor de BitError
            transmision[BitError-1] = ~WordHamming[BitError-1];
        else
            // Si BitError es 7 o mayor, no se introduce ningún error (transmision ya es igual a WordHamming)
            transmision = WordHamming;
    end

endmodule