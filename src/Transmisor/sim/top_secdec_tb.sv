`timescale 1ns/1ps

module top_secdec_tb;

    // Entradas
    logic [3:0] sw;
    logic [3:0] BitError;

    // Salidas
    logic [7:0] Transf;
    logic [6:0] segments;

    // DUT
    top_secdec dut (
        .sw       (sw),
        .BitError (BitError),
        .Transf   (Transf),
        .segments (segments)
    );

    // Función Hamming SECDED esperada
    function automatic [7:0] expected_hamming_secdec(input [3:0] d);
        logic p1, p2, p4, p8;
        begin
            p1 = d[3] ^ d[2] ^ d[0];
            p2 = d[3] ^ d[1] ^ d[0];
            p4 = d[2] ^ d[1] ^ d[0];

            // {p8,p1,p2,d3,p4,d2,d1,d0}
            expected_hamming_secdec[6] = p1;
            expected_hamming_secdec[5] = p2;
            expected_hamming_secdec[4] = d[3];
            expected_hamming_secdec[3] = p4;
            expected_hamming_secdec[2] = d[2];
            expected_hamming_secdec[1] = d[1];
            expected_hamming_secdec[0] = d[0];

            p8 = ^expected_hamming_secdec[6:0];
            expected_hamming_secdec[7] = p8;
        end
    endfunction

    logic [7:0] esperado_code;
    logic [7:0] esperado_tx;

    initial begin
        $display("=== INICIO DE TESTBENCH SECDED ===");

        for (int i = 0; i < 16; i++) begin
            sw = i[3:0];

            for (int j = 0; j < 9; j++) begin
                BitError = j[3:0];
                #1;

                esperado_code = expected_hamming_secdec(sw);
                esperado_tx   = esperado_code;

                // 0000 = sin error
                // 0001..1000 = invierte bit 0..7
                if (BitError >= 1 && BitError <= 8)
                    esperado_tx[BitError-1] = ~esperado_tx[BitError-1];

                if (Transf !== esperado_tx)
                    $display("ERROR | sw=%b BitError=%b esperado=%b got=%b",
                             sw, BitError, esperado_tx, Transf);
                else
                    $display("OK    | sw=%b BitError=%b Transf=%b",
                             sw, BitError, Transf);
            end
        end

        $display("=== FIN DEL TESTBENCH SECDED ===");
        $finish;
    end

    initial begin
        $dumpfile("top_secdec_tb.vcd");
        $dumpvars(0, top_secdec_tb);
    end

endmodule