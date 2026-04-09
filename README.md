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
[1] FZumb4do. open_source_fpga_environment. https://github.com/FZumb4do/open_source_fpga_environment.git
[2] LUSHAYLABS. Tang Nano 9K: Getting Setup. https://learn.lushaylabs.com/getting-setup-with-the-tang-nano-9k/
[3] Sipeed Wiki — Tang Nano 9K: https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html

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

- Transmisor
  - Módulo 5.1 - Paridad Par Hamming (7,4)

  - Módulo 5.2 - Visualización hexadecimal en 7 segmentos - Decodificador

  - Módulo 5.3 - Simulación de errores en la transmisión

  - Periféricos - Selectores y 7 segmentos



## Integración del transmisor
> Pines
> Diagrama de bloques del transmisor
> Circuito lógico del transmisor
> Código HDL del transmisor
> Testbench del transmisor




# 9. Verificación gráfica en GTKWave

#### 4. Criterios de diseño
Diagramas, texto explicativo...

#### 5. Testbench
Descripción y resultados de las pruebas hechas

### Otros modulos
- agregar informacion siguiendo el ejemplo anterior.


## 4. Consumo de recursos

## 5. Problemas encontrados durante el proyecto

## Apendices:
### Apendice 1:
texto, imágen, etc

# 15. Conclusiones 


---
