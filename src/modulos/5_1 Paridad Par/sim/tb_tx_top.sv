`timescale 1ns/1ps

module tb_tx_top;

    logic [3:0] data_sw;
    logic [2:0] err_sw;
    logic [6:0] seg;
    logic [6:0] tx_word;

    tx_top #(
        .COMMON_ANODE(1'b0)
    ) dut (
        .data_sw(data_sw),
        .err_sw(err_sw),
        .seg(seg),
        .tx_word(tx_word)
    );

        initial begin
        $dumpfile("top.vcd");
        $dumpvars(0, tb_tx_top);
    end

    initial begin
        $display("=== Test tx_top ===");

        // Caso 1: dato 0000 sin error
        data_sw = 4'b0000;
        err_sw  = 3'b000;
        #10;
        $display("data=%b err=%b -> tx=%b seg=%b", data_sw, err_sw, tx_word, seg);

        // Caso 2: dato 1010 sin error
        data_sw = 4'b1010;
        err_sw  = 3'b000;
        #10;
        $display("data=%b err=%b -> tx=%b seg=%b", data_sw, err_sw, tx_word, seg);

        // Caso 3: dato 1010 con error en posición 1
        data_sw = 4'b1010;
        err_sw  = 3'b001;
        #10;
        $display("data=%b err=%b -> tx=%b seg=%b", data_sw, err_sw, tx_word, seg);

        // Caso 4: dato 1010 con error en posición 4
        data_sw = 4'b1010;
        err_sw  = 3'b100;
        #10;
        $display("data=%b err=%b -> tx=%b seg=%b", data_sw, err_sw, tx_word, seg);

        // Caso 5: dato 1111 con error en posición 7
        data_sw = 4'b1111;
        err_sw  = 3'b111;
        #10;
        $display("data=%b err=%b -> tx=%b seg=%b", data_sw, err_sw, tx_word, seg);

        // Barrido rápido
        data_sw = 4'b0001; err_sw = 3'b000; #10;
        data_sw = 4'b0011; err_sw = 3'b010; #10;
        data_sw = 4'b0101; err_sw = 3'b011; #10;
        data_sw = 4'b1001; err_sw = 3'b101; #10;
        data_sw = 4'b1110; err_sw = 3'b110; #10;

        $finish;
    end

endmodule