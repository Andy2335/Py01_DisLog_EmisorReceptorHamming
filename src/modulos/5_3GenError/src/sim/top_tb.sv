`timescale 1ns/1ps

`timescale 1ns/1ps

module top_tb;

    /*
    Observe que en esta seccion los logic no se definen como input o output, son propios del modulo
    como si fueran un nodo, por eso se conectan en el DUT. 
    */

    // Señales de prueba
    logic [2:0] BitError;
    logic [6:0] WordHamming;
    logic [6:0] transmision;

    // DUT (Device Under Test)

    /*
    Observe que .sw se refiere al nodo sw creado en este propio modulo, (sw) se refiere al input 
    definido en el top. Se recomienda usar los mismos nombres porque esto permite seguir trabajando
    con el mismo nombre de variable y la conexion es mas facil. De igual forma para las demas.

    Observe que se prefiere usar los S# porque es mas facil y corto que escribir segments[#]...
    */

    // Instancia del módulo a probar
    top dut (
        .BitError(BitError),
        .WordHamming(WordHamming),
        .transmision(transmision)
    );

    initial begin
        
        // Palabra Hamming de prueba
        WordHamming = 7'b1011010;

        // Mostrar encabezado
        $display("Tiempo\tBitError\tWordHamming\ttransmision");
        $display("----------------------------------------------------");
        $monitor("%0t\t%b\t\t%b\t%b", $time, BitError, WordHamming, transmision);

        // Probar cada posible valor de BitError
        BitError = 3'b000; #10;   // Invierte bit 0
        BitError = 3'b001; #10;   // Invierte bit 1
        BitError = 3'b010; #10;   // Invierte bit 2
        BitError = 3'b011; #10;   // Invierte bit 3
        BitError = 3'b100; #10;   // Invierte bit 4
        BitError = 3'b101; #10;   // Invierte bit 5
        BitError = 3'b110; #10;   // Invierte bit 6
        BitError = 3'b111; #10;   // No introduce error

        $finish;
    end

endmodule