# Proyecto corto I – Diseño digital combinacional en dispositivos programables

## Escuela de Ingeniería Electrónica
**Curso:** EL-3307 Diseño Lógico

**Profesor:** Oscar Caravaca

**Semestre:** I Semestre 2026  

--- 
## Integrantes
- Andrés Obregón López
- Mariana Solano Gutiérrez
---

## Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays
- **HDL**: Hardware Description Language
- **SRC**: Source

## Herramientas Utilizadas
- **Lenguaje de descripción de hardware**: Verilog
- **Plataforma de desarrollo**: FPGA Nano Tang 9k
- **Multisim**: Para simulación de circuitos digitales
- **Digital works**: Para simulación de circuitos digitales
- **GTKWave**: Para verificación gráfica de señales en simulaciones

## Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

[1] [FZumb4do. open_source_fpga_environment](https://github.com/FZumb4do/open_source_fpga_environment.git) 

[2] [LUSHAYLABS. Tang Nano 9K: Getting Setup](https://learn.lushaylabs.com/getting-setup-with-the-tang-nano-9k/)

[3] [Sipeed Wiki — Tang Nano 9K](https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html)


## Objetivo
Implementar un sistema digital que permita la visualización, simulación de errores en envió de datos, así como su emisión utilizando el código Hamming (7,4), apartir del cual se pueda detectar y corregir errores en la cadena de datos transmitida recibida por el receptor. 

# Descripción general del sistema

En este proyecto se abordará el diseño e implementación de un sistema digital de emisión y transmisión de datos con la implementación de el algoritmo Hamming (7,4) para la recuperación de datos y identificación de errores. Utilizando como plataforma de desarrollo la tarjeta FPGA Nano Tanq 9k. Este sistema se compone de dos dispositivos un *Transmisor* y un *Receptor*. En este repositorio se desarrollará el dispositivo transmisor, en donde el usuario podrá ingresar una palabra de 4 bits a través de un selector, la cual será codificada utilizando el código Hamming (7,4), para luego simular mediante otro selector el caso de un error en uno de los bits para luego transmitir esta cadena a través de un bus de 7 bits al receptor. 

[** Wiki ** ](https://github.com/Andy2335/Py01_DisLog_EmisorReceptorHamming/wiki/Home-%E2%80%90-Transmisor-con-algoritmo-Hamming)

## Estructura de la documentación
- `README.md`, Descripción general del proyecto
- `docs`, Especificaciones, esquemas, hojas de datos, imagenes, simulaciones, etc.
- `wiki`, Explicación detallada "Tutorial"
- `src`, Código fuente del proyecto, organizado en dispositivo y módulos
- `build`, Makerfile, scripts de compilación, archivos de configuración, etc.
- `constr`, Constraints - Definición de pines.
- `design`, Implementación lógica programada y funciones.
- `sim`, Testbenches y archivos de simulación.

## Jerarquía del dispositivo transmisor

- Transmisor - Diagrama de bloques y circuito lógico

    ### Diagrama de bloques:
    <img src="https://github.com/Andy2335/Py01_DisLog_EmisorReceptorHamming/blob/ebff8504741258c4819ed9ba633571e7adfb919f/doc/imagenes/Diagrama%20Bloques%20Emisor.jpg" width="700">

    ### Circuito lógico:
    <img src="https://github.com/Andy2335/Py01_DisLog_EmisorReceptorHamming/blob/98ff8b0a628059ddae0100d8e880b7c485756383/doc/imagenes/DiagramaConexi%C3%B3nEmisor.jpg" width="700">

    ### Visualización de Señales:
    <img src="" width="700">

  - Módulo 5.1 - Paridad Par Hamming (7,4) 
  [wiki](https://github.com/Andy2335/Py01_DisLog_EmisorReceptorHamming/wiki/Modulo-5.1-%E2%80%90-M%C3%B3dulo-de-Codificaci%C3%B3n-Paridad-Par)

    Se implementa el módulo de codificación utilizando el código Hamming (7,4) para generar la cadena de 7 bits a partir de una palabra de 4 bits ingresada por el usuario. Este módulo se encarga de calcular los bits de paridad necesarios para la detección y corrección de errores, siguiendo las reglas del código Hamming. La salida de este módulo es una cadena de 7 bits que representa la palabra original junto con los bits de paridad, lista para ser transmitida al receptor.




  - Módulo 5.2 - Visualización hexadecimal en 7 segmentos - Decodificador 
  [wiki](https://github.com/Andy2335/Py01_DisLog_EmisorReceptorHamming/wiki/M%C3%B3dulo-5.2-%E2%80%90--M%C3%B3dulo-de-decodificaci%C3%B3n-binario-a-7-segmentos-representaci%C3%B3n-hexadecimal)

    Este módulo se encarga de la visualización de la palabra de 4 bits ingresada por el usuario en un display de 7 segmentos. Para ello, se implementa un decodificador que convierte la representación binaria de la palabra en su equivalente hexadecimal, permitiendo así una visualización clara y comprensible para el usuario. Este módulo facilita la interacción con el sistema, ya que permite verificar visualmente la entrada antes de la codificación y transmisión de los datos.



  - Módulo 5.3 - Simulación de errores en la transmisión 
  [wiki](https://github.com/Andy2335/Py01_DisLog_EmisorReceptorHamming/wiki/M%C3%B3dulo-5.3-%E2%80%90-M%C3%B3dulo-generador-de-error-en-la-codificaci%C3%B3n-Hamming-(7,4))

    En este módulo se implementa la funcionalidad de simular errores en la cadena de datos codificada utilizando el código Hamming (7,4). A través de un selector, el usuario puede elegir simular un error en uno de los bits de la cadena de 7 bits generada por el módulo de codificación. Esto permite probar la capacidad del sistema para detectar y corregir errores, ya que el receptor deberá ser capaz de identificar y corregir el error simulado durante la transmisión. Este módulo es fundamental para validar la efectividad del código Hamming en la corrección de errores en sistemas digitales.



  - Periféricos - Selectores y 7 segmentos 
  [wiki](https://github.com/Andy2335/Py01_DisLog_EmisorReceptorHamming/wiki/Home-%E2%80%90-Transmisor-con-algoritmo-Hamming)



- Testbench y Simulación de Ondas
  [wiki](https://github.com/Andy2335/Py01_DisLog_EmisorReceptorHamming/wiki/Testbench-y-Simulaci%C3%B3n-de-Ondas-(Transmisor))

    El testbench se utilizó para verificar automáticamente el funcionamiento del código Hamming (7,4), evaluando diferentes combinaciones de entrada y posibles errores. A través de la simulación, se comprobó que las salidas coinciden con los valores esperados. Las formas de onda permitieron visualizar el comportamiento del sistema en el tiempo, confirmando que el código se genera correctamente y que la inserción de errores afecta únicamente un bit.
  
## Resultados
- Se generó un diseño digital funcional en la plataforma FPGA Nano Tang 9k.
- Se logró construir un testbench para verificar el correcto funcionamiento del sistema.
- Se implementó el algoritmo Hamming (7,4) para la corrección de errores en la transmisión de datos.
- Se visualizó los retrasos en la señal y forma de onda utilizando GTKWave y en las compuertas lógicas.
- Se coordinó el diseño del proyecto con el equipo de trabajo, asignando tareas y responsabilidades y utilizando una herramienta de control de versiones (Git) para mantener un seguimiento del progreso y cambios realizados en el proyecto. Además de documentar el proceso de desarrollo y los resultados obtenidos en un repositorio de GitHub, facilitando la colaboración y el acceso a la información del proyecto para todos los miembros del equipo.


## Conclusion
En este proyecto se logró implementar un sistema digital de transmisión de datos utilizando el código Hamming (7,4) para la detección y corrección de errores. El diseño se llevó a cabo en la plataforma FPGA Nano Tang 9k, permitiendo una implementación eficiente y funcional del transmisor. A través de la simulación y pruebas realizadas, se pudo verificar que el sistema es capaz de detectar y corregir errores en la cadena de datos transmitida, cumpliendo con los objetivos planteados al inicio del proyecto. Además, se desarrolló una interfaz de usuario que permite ingresar datos y simular errores, lo que facilita la comprensión del funcionamiento del código Hamming y su aplicación en sistemas digitales. Este proyecto no solo demuestra la importancia de la corrección de errores en la transmisión de datos, sino también la capacidad de las FPGAs para implementar soluciones digitales complejas de manera efectiva.
