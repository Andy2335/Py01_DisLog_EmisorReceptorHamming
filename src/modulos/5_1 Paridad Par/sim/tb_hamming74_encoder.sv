`timescale 1ns/1ps

module tb_hamming74_encoder;

    logic [3:0] data_in;
    logic [6:0] code_out;

    hamming74_encoder dut (
        .data_in(data_in),
        .code_out(code_out)
    );

    initial begin
        $display("=== Test hamming74_encoder ===");

        data_in = 4'b0000; #10;
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