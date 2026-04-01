// MODULO 5.3 - Generador de errores para palabra hamming (7,4)
// Autor: Andres Obregon Lopez
// Simulador de errores en la transmision de datos.

module top (
    input logic [2:0] BitError,           // Bits de entrada de error: E3 ,E2 ,E1 (MSB a LSB)
    input logic [6:0] WordHamming,  // Bits palabra Hamming (7,4): H7, H6, H5, H4, H3, H2, H1 (MSB a LSB) Corregir pines internos!!!!
    output logic [6:0] transmision     // Bits de transmision: B7, B6, B5, B4, B3, B2, B1 (MSB a LSB)
);


always @(*) begin
    transmision = WordHamming; // Copiar la palabra Hamming a la transmision inicialmente correcta

    if (BitError < 7)
        // Inversión de un bit especifico en transmision según el valor de BitError
        transmision[BitError] = ~WordHamming[BitError];
    else
        // Si BitError es 7 o mayor, no se introduce ningún error (transmision ya es igual a WordHamming)
        transmision = WordHamming;
end



endmodule