// ============================================================
// MODULO PRINCIPAL: Emisor con codificador SECDED (8,4)
// ============================================================

module top (
    input  logic [3:0] sw,
    input  logic [3:0] BitError,
    output logic [7:0] Transf,
    output logic [6:0] segments
);

    logic [7:0] code_out;

    // Display de 7 segmentos
    bin_to_7seg U3 (
        .sw       (sw),
        .segments (segments)
    );

    // Codificador SECDED
    hamming84_encoder U1 (
        .data_in  (sw),
        .code_out (code_out)
    );

    // Inserción de error
    error_inserter_8bit U2 (
        .BitError    (BitError),
        .WordHamming (code_out),
        .transmision (Transf)
    );

endmodule


// ============================================================
// MODULO 5.1 EXTRA: Paridad Par Hamming(8,4) con bit global
// ============================================================
module hamming84_encoder (
    input  logic [3:0] data_in,
    output logic [7:0] code_out
);

    logic p1, p2, p4, p8;

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

        p8 = ^code_out[6:0]; // XOR de todos los bits
        code_out[7] = p8;
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
// MODULO 5.3 EXTRA: Insercion de error para 8 bits
// ============================================================
module error_inserter_8bit (
    input  logic [3:0] BitError,
    input  logic [7:0] WordHamming,
    output logic [7:0] transmision
);

    always_comb begin
        transmision = WordHamming;

        case (BitError)
            4'b0001: transmision[0] = ~WordHamming[0];
            4'b0010: transmision[1] = ~WordHamming[1];
            4'b0011: transmision[2] = ~WordHamming[2];
            4'b0100: transmision[3] = ~WordHamming[3];
            4'b0101: transmision[4] = ~WordHamming[4];
            4'b0110: transmision[5] = ~WordHamming[5];
            4'b0111: transmision[6] = ~WordHamming[6];
            4'b1000: transmision[7] = ~WordHamming[7];
            default: transmision = WordHamming;
        endcase
    end

endmodule