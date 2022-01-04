onerror resume
wave update off
wave tags  F0
wave group AHB -backgroundcolor #004466
wave add -group AHB uvm_pkg::uvm_phase::m_run_phases...uvm_test_top.environment.ahb2wb_env.ahb.ahb_monitor.txn_stream -tag F0 -radix string
wave add -group AHB hdl_top.ahb_bus.hclk -tag F0 -radix hexadecimal
wave add -group AHB hdl_top.ahb_bus.hresetn -tag F0 -radix hexadecimal
wave add -group AHB {hdl_top.ahb_bus.haddr[31:0]} -tag F0 -radix hexadecimal
wave add -group AHB {hdl_top.ahb_bus.hwdata[15:0]} -tag F0 -radix hexadecimal
wave add -group AHB {hdl_top.ahb_bus.htrans[1:0]} -tag F0 -radix hexadecimal
wave add -group AHB {hdl_top.ahb_bus.hburst[2:0]} -tag F0 -radix hexadecimal
wave add -group AHB {hdl_top.ahb_bus.hsize[2:0]} -tag F0 -radix hexadecimal
wave add -group AHB hdl_top.ahb_bus.hwrite -tag F0 -radix hexadecimal
wave add -group AHB hdl_top.ahb_bus.hsel -tag F0 -radix hexadecimal
wave add -group AHB hdl_top.ahb_bus.hready -tag F0 -radix hexadecimal
wave add -group AHB {hdl_top.ahb_bus.hrdata[15:0]} -tag F0 -radix hexadecimal
wave add -group AHB {hdl_top.ahb_bus.hresp[1:0]} -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group SPI -backgroundcolor #006666
wave add -group SPI uvm_pkg::uvm_phase::m_run_phases...uvm_test_top.environment.wb2spi_env.spi.spi_monitor.txn_stream -tag F0 -radix string
wave add -group SPI hdl_top.spi_bus.sck -tag F0 -radix hexadecimal
wave add -group SPI hdl_top.spi_bus.mosi -tag F0 -radix hexadecimal
wave add -group SPI hdl_top.spi_bus.miso -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group WB -backgroundcolor #216600
wave add -group WB uvm_pkg::uvm_phase::m_run_phases...uvm_test_top.environment.wb_mon.txn_stream -tag F0 -radix string
wave add -group WB hdl_top.wb_bus.clk -tag F0 -radix hexadecimal
wave add -group WB hdl_top.wb_bus.rst -tag F0 -radix hexadecimal
wave add -group WB hdl_top.wb_bus.inta -tag F0 -radix hexadecimal
wave add -group WB hdl_top.wb_bus.cyc -tag F0 -radix hexadecimal
wave add -group WB hdl_top.wb_bus.stb -tag F0 -radix hexadecimal
wave add -group WB {hdl_top.wb_bus.adr[31:0]} -tag F0 -radix hexadecimal
wave add -group WB hdl_top.wb_bus.we -tag F0 -radix hexadecimal
wave add -group WB {hdl_top.wb_bus.dout[15:0]} -tag F0 -radix hexadecimal
wave add -group WB {hdl_top.wb_bus.din[15:0]} -tag F0 -radix hexadecimal
wave add -group WB hdl_top.wb_bus.err -tag F0 -radix hexadecimal
wave add -group WB hdl_top.wb_bus.rty -tag F0 -radix hexadecimal
wave add -group WB {hdl_top.wb_bus.sel[1:0]} -tag F0 -radix hexadecimal
wave add -group WB {hdl_top.wb_bus.q[15:0]} -tag F0 -radix hexadecimal
wave add -group WB hdl_top.wb_bus.ack -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave update on
WaveSetStreamView