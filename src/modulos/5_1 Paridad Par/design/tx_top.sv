module tx_top #(
    parameter COMMON_ANODE = 1'b0
)(
    input  logic [3:0] data_sw,
    input  logic [2:0] err_sw,
    output logic [6:0] seg,
    output logic [6:0] tx_word
);

    logic [6:0] hamming_word;

    hamming74_encoder u_encoder (
        .data_in  (data_sw),
        .code_out (hamming_word)
    );

    error_inserter u_error (
        .code_in   (hamming_word),
        .error_pos (err_sw),
        .code_out  (tx_word)
    );

    bin_to_7seg #(
        .COMMON_ANODE(COMMON_ANODE)
    ) u_display (
        .bin_in (data_sw),
        .seg    (seg)
    );

endmodule