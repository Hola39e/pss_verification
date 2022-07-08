interface icpit_if
	logic PCLK;
	logic PRESTn;
	logic IRQ;
	logic [7:0] IREQ;
	logic PIT_OUT;
	logic WDOG;
endinterface