`timescale 1ns/1ps

module top_tb;

    // Entradas
    logic [3:0] data_in;
    logic [2:0] BitError;

    // Salidas
    logic [6:0] code_out;
    logic [6:0] transmision;
    logic [6:0] seg;

    // DUT
    top dut (
        .data_in(data_in),
        .BitError(BitError),
        .code_out(code_out),
        .transmision(transmision),
        .seg(seg)
    );

    // Función Hamming esperada
    function automatic [6:0] expected_hamming (input [3:0] d);
        logic p1, p2, p4;
        begin
            p1 = d[3] ^ d[2] ^ d[0];
            p2 = d[3] ^ d[1] ^ d[0];
            p4 = d[2] ^ d[1] ^ d[0];

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
            data_in = i;

            for (int j = 0; j < 8; j++) begin
                BitError = j;
                #1;

                esperado_code = expected_hamming(data_in);
                esperado_tx   = esperado_code;

                // aplicar error esperado
                if (BitError >= 1 && BitError <= 7)
                    esperado_tx[BitError-1] = ~esperado_tx[BitError-1];

                // Verificación
                if (code_out !== esperado_code)
                    $display("ERROR CODE | data=%b esperado=%b got=%b",
                             data_in, esperado_code, code_out);

                if (transmision !== esperado_tx)
                    $display("ERROR TX | data=%b BitError=%b esperado=%b got=%b",
                             data_in, BitError, esperado_tx, transmision);
                else
                    $display("OK | data=%b BitError=%b",
                             data_in, BitError);
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