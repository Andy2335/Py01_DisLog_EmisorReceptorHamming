`timescale 1ns/1ps

module top_tb;

    // Entradas
    logic [3:0] sw;
    logic [2:0] BitError;

    // Salidas
    logic [6:0] Transf;
    logic [6:0] segments;

    // DUT
    top dut (
        .sw       (sw),
        .BitError (BitError),
        .Transf   (Transf),
        .segments (segments)
    );

    // Función Hamming esperada
    function automatic [6:0] expected_hamming(input [3:0] d);
        logic p1, p2, p4;
        begin
            p1 = d[3] ^ d[2] ^ d[0];
            p2 = d[3] ^ d[1] ^ d[0];
            p4 = d[2] ^ d[1] ^ d[0];

            // {p1,p2,d3,p4,d2,d1,d0}
            expected_hamming[6] = p1;
            expected_hamming[5] = p2;
            expected_hamming[4] = d[3];
            expected_hamming[3] = p4;
            expected_hamming[2] = d[2];
            expected_hamming[1] = d[1];
            expected_hamming[0] = d[0];
        end
    endfunction

    logic [6:0] esperado_code;
    logic [6:0] esperado_tx;

    initial begin
        $display("=== INICIO DE TESTBENCH ===");

        for (int i = 0; i < 16; i++) begin
            sw = i[3:0];

            for (int j = 0; j < 8; j++) begin
                BitError = j[2:0];
                #1;

                esperado_code = expected_hamming(sw);
                esperado_tx   = esperado_code;

                // 000 = sin error
                // 001..111 = invierte bit 0..6
                if (BitError >= 1 && BitError <= 7)
                    esperado_tx[BitError-1] = ~esperado_tx[BitError-1];

                if (Transf !== esperado_tx)
                    $display("ERROR | sw=%b BitError=%b esperado=%b got=%b",
                             sw, BitError, esperado_tx, Transf);
                else
                    $display("OK    | sw=%b BitError=%b Transf=%b",
                             sw, BitError, Transf);
            end
        end

        $display("=== FIN DEL TESTBENCH ===");
        $finish;
    end

    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);
    end

endmodule