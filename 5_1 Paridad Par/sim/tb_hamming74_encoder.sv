`timescale 1ns/1ps

module tb_hamming74_encoder;

    logic [3:0] data_in;
    logic [6:0] code_out;

    // Módulo bajo prueba
    hamming74_encoder dut (
        .data_in(data_in),
        .code_out(code_out)
    );

    initial begin
        $dumpfile("hamming74_encoder.vcd");
        $dumpvars(0, tb_hamming74_encoder);

        // Ejemplo de la wiki
        data_in = 4'b1011;
        #10;

        $display("Ejemplo:");
        $display("data_in  = %b", data_in);
        $display("code_out = %b", code_out);

        // Verificación esperada: 0110011
        if (code_out == 7'b0110011)
            $display("PASA: la salida es correcta");
        else
            $display("FALLO: se esperaba 0110011 y se obtuvo %b", code_out);

        #10;
        $finish;
    end

endmodule























/*`timescale 1ns/1ps

module tb_hamming74_encoder;

    logic [3:0] data_in;
    logic [6:0] code_out;

    hamming74_encoder dut (
        .data_in(data_in),
        .code_out(code_out)
    );

    initial begin
        $display("=== Test hamming74_encoder ===");

        data_in = 4'b1011; #10;
        $display("data=%b -> code=%b", data_in, code_out);


        data_in = 4'b0001; #10;
        $display("data=%b -> code=%b", data_in, code_out);

        data_in = 4'b0010; #10;
        $display("data=%b -> code=%b", data_in, code_out);

        data_in = 4'b0100; #10;
        $display("data=%b -> code=%b", data_in, code_out);

        data_in = 4'b1000; #10;
        $display("data=%b -> code=%b", data_in, code_out);

        data_in = 4'b1010; #10;
        $display("data=%b -> code=%b", data_in, code_out);

        data_in = 4'b1111; #10;
        $display("data=%b -> code=%b", data_in, code_out);



        $finish;
    end

endmodule
*/