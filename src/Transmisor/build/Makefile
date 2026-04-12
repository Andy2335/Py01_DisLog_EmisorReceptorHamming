#Makefile Emisor con codificador SECDED (8,4)


BOARD  = tangnano9k
FAMILY = GW1N-9C
DEVICE = GW1NR-LV9QN88PC6/I5

PROYECT = EmisorSECDED

# Fuentes de diseño
SOURCES = ../design/top_secdec.sv

# Fuente de simulación
TESTBENCH = ../sim/top_secdec_tb.sv

# Constraints del proyecto
CONSTRAINTS = ../constr/Constraints.cst

# Top de diseño y top del testbench
TOP_DESIGN = top_secdec
TOP_TB     = top_secdec_tb

# nombre del vcd
VCD_FILE = top_secdec_tb.vcd

all: synth pnr bitstream load

# Synthesis
synth: ${SOURCES}
	@echo "Ejecutando la sintesis..."
	@yosys -p "read_verilog -sv ${SOURCES}; synth_gowin -top ${TOP_DESIGN} -json ${PROYECT}.json" > synthesis_${BOARD}.log 2>&1
	@echo "COMPLETADO"

# Place and Route
pnr: ${PROYECT}.json
	@echo "Ejecutando el pnr..."
	@nextpnr-gowin --json ${PROYECT}.json --write ${PROYECT}_pnr.json --freq 27 --device ${DEVICE} --family ${FAMILY} --cst ${CONSTRAINTS} > pnr_${BOARD}.log 2>&1
	@echo "COMPLETADO"

# Generar el Bitstream
bitstream: ${PROYECT}_pnr.json
	@echo "Generando ${PROYECT}_${BOARD}.fs"
	@gowin_pack -d ${FAMILY} -o ${PROYECT}_${BOARD}.fs ${PROYECT}_pnr.json
	@echo "COMPLETADO"

# Generar vcd con icarus verilog
test: ${SOURCES} ${TESTBENCH}
	@iverilog -o ${PROYECT}_test.o -s ${TOP_TB} -g2005-sv ${TESTBENCH} ${SOURCES}
	@vvp ${PROYECT}_test.o

# Visualizar diagramas de tiempo
wv: ${VCD_FILE}
	gtkwave ${VCD_FILE}

# Cargar bitstream
load: ${PROYECT}_${BOARD}.fs
	openFPGALoader -b ${BOARD} ${PROYECT}_${BOARD}.fs

clean:
	@echo "Limpiando archivos temporales..."
	-del /Q *.json *.log *.o *.out *.fs *.vcd 2>nul
	-del /Q *_pnr.json *_test.o 2>nul
	@echo "Limpieza completada"

.PHONY: load wv test
.INTERMEDIATE: ${PROYECT}_pnr.json ${PROYECT}.json