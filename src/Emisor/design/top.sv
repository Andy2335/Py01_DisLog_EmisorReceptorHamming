// MODULO PRINCIPAL: Emisor con decodificador Hamming(7,4)
/* Autor: Andres Obregon Lopez
          Mariana Solano Gutierrez*/

// Programacion del modulo principal que integra los modulos de paridad, decodificador de 7 segmentos, generador de errores y transimision de datos.

// ============================================================
//Integracion Modulos 3.1 ParidadPar, 3.2 7SEGHEX , 3.3 GenError
// ============================================================


// ============================================================
// MODULO 5.1: Paridad ParHamming(7,4)
// ============================================================

module hamming74_encoder (
    input  logic [3:0] data_in,   // {d3,d2,d1,d0}
    output logic [6:0] code_out   // {p1,p2,d3,p4,d2,d1,d0}
);

    logic p1, p2, p4;

    always_comb begin
        // Bits de datos
        // data_in[3] = d3
        // data_in[2] = d2
        // data_in[1] = d1
        // data_in[0] = d0

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
module bin_to_7seg #(
    parameter COMMON_ANODE = 1'b0
)(
    input  logic [3:0] bin_in,
    output logic [6:0] seg
);

    logic AIN, BIN, CIN, DIN;
    logic AIN_N, BIN_N, CIN_N, DIN_N;
    logic SA, SB, SC, SD, SE, SF, SG;
    logic [6:0] seg_raw;

    assign AIN = bin_in[3];
    assign BIN = bin_in[2];
    assign CIN = bin_in[1];
    assign DIN = bin_in[0];

    assign AIN_N = ~AIN;
    assign BIN_N = ~BIN;
    assign CIN_N = ~CIN;
    assign DIN_N = ~DIN;

    // Segmento A
    assign SA = (DIN_N & (AIN | BIN_N)) |
                (AIN_N & (CIN | (BIN & DIN))) |
                (BIN & CIN) |
                (AIN & BIN_N & CIN_N);

    // Segmento B
    assign SB = (BIN_N & (AIN_N | DIN_N)) |
                (AIN_N & (~(CIN ^ DIN))) |
                (AIN & DIN & CIN_N);

    // Segmento C
    assign SC = (AIN & BIN_N) |
                (AIN_N & (BIN | DIN | CIN_N)) |
                (DIN & CIN_N);

    // Segmento D
    assign SD = (DIN_N & ((AIN_N & BIN_N) | (BIN & CIN) | (AIN & CIN_N))) |
                (DIN & ((BIN & CIN_N) | (BIN_N & CIN)));

    // Segmento E
    assign SE = (DIN_N & (BIN_N | CIN)) |
                (AIN & (CIN | BIN));

    // Segmento F
    assign SF = (AIN & (CIN | BIN_N)) |
                (DIN_N & (BIN | CIN_N)) |
                (AIN_N & BIN & CIN_N);

    // Segmento G
    assign SG = (AIN & (DIN | BIN_N)) |
                (CIN & (BIN_N | DIN_N)) |
                (AIN_N & BIN & CIN_N);

    assign seg_raw = {SG, SF, SE, SD, SC, SB, SA};

    always_comb begin
        if (COMMON_ANODE)
            seg = ~seg_raw;
        else
            seg = seg_raw;
    end

endmodule
// ============================================================
// MODULO 5.3: Insercion de error
// ============================================================

module error_inserter (
    input logic [2:0] BitError,           // Bits de entrada de error: E3 ,E2 ,E1 (MSB a LSB)
    input logic [6:0] WordHamming,  // Bits palabra Hamming (7,4): H7, H6, H5, H4, H3, H2, H1 (MSB a LSB) Corregir pines internos!!!!
    output logic [6:0] transmision     // Bits de transmision: B7, B6, B5, B4, B3, B2, B1 (MSB a LSB)
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