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