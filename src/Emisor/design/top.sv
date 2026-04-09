// ============================================================
// MODULO PRINCIPAL: Emisor con codificador Hamming(7,4)
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

    bin_to_7seg U3 (
    .sw(data_in),
    .segments(seg)
    );

    /*
    bin_to_7seg #(
        .COMMON_ANODE(1'b0)
    ) U3 (
        .bin_in (data_in),
        .seg    (seg)
    );
*/








    // --------------------------------------------------------
    // Instancia del codificador Hamming(7,4)
    // --------------------------------------------------------
    hamming74_encoder U1 (
        .data_in  (data_in),
        .code_out (code_out)
    );

    

    // Inserción de error
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
    input  logic [3:0] data_in,
    output logic [6:0] code_out
);

    logic p1, p2, p4;

    always_comb begin
        p1 = data_in[3] ^ data_in[2] ^ data_in[0];
        p2 = data_in[3] ^ data_in[1] ^ data_in[0];
        p4 = data_in[2] ^ data_in[1] ^ data_in[0];

        code_out[6] = p1;
        code_out[5] = p2;
        code_out[4] = data_in[3];
        code_out[3] = p4;
        code_out[2] = data_in[2];
        code_out[1] = data_in[1];
        code_out[0] = data_in[0];
    end

endmodule


// ============================================================
// MODULO 5.2: Display de 7 segmentos
// ============================================================
module bin_to_7seg (
    input  logic [3:0] sw,
    output logic [6:0] segments
);

    logic AIN, BIN, CIN, DIN;
    logic AIN_N, BIN_N, CIN_N, DIN_N;
    logic SA, SB, SC, SD, SE, SF, SG;

    assign AIN = sw[3];
    assign BIN = sw[2];
    assign CIN = sw[1];
    assign DIN = sw[0];

    assign AIN_N = ~AIN;
    assign BIN_N = ~BIN;
    assign CIN_N = ~CIN;
    assign DIN_N = ~DIN;

    assign SA = (DIN_N & (AIN | BIN_N)) | 
                (AIN_N & (CIN | (BIN & DIN))) | 
                (BIN & CIN) | 
                (AIN & BIN_N & CIN_N);

    assign SB = (BIN_N & (AIN_N | DIN_N)) | 
                (AIN_N & (~(CIN ^ DIN))) | 
                (AIN & DIN & CIN_N);

    assign SC = (AIN & BIN_N) | 
                (AIN_N & (BIN | DIN | CIN_N)) | 
                (DIN & CIN_N);

    assign SD = (DIN_N & ((AIN_N & BIN_N) | (BIN & CIN) | (AIN & CIN_N))) | 
                (DIN & ((BIN & CIN_N) | (BIN_N & CIN)));

    assign SE = (DIN_N & (BIN_N | CIN)) | 
                (AIN & (CIN | BIN));

    assign SF = (AIN & (CIN | BIN_N)) | 
                (DIN_N & (BIN | CIN_N)) | 
                (AIN_N & BIN & CIN_N);

    assign SG = (AIN & (DIN | BIN_N)) | 
                (CIN & (BIN_N | DIN_N)) | 
                (AIN_N & BIN & CIN_N);

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
// ============================================================
module error_inserter (
    input  logic [2:0] BitError,
    input  logic [6:0] WordHamming,
    output logic [6:0] transmision
);

    always @(*) begin
        transmision = WordHamming; // Copiar la palabra Hamming a la transmision inicialmente correcta

        if (BitError >= 1 && BitError <= 7)
            transmision[BitError-1] = ~WordHamming[BitError-1];

/*
        if (BitError < 7)
            // Inversión de un bit especifico en transmision según el valor de BitError
            transmision[BitError-1] = ~WordHamming[BitError-1];
        else
            // Si BitError es 7 o mayor, no se introduce ningún error (transmision ya es igual a WordHamming)
            transmision = WordHamming;
*/
    end

endmodule