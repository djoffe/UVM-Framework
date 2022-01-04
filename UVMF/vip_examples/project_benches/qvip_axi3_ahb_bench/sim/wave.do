onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hdl_top/slave/HRESETn
add wave -noupdate /hdl_top/slave/HCLK
add wave -noupdate -radix hexadecimal /hdl_top/slave/HADDR
add wave -noupdate /hdl_top/slave/HWRITE
add wave -noupdate /hdl_top/slave/HTRANS
add wave -noupdate /hdl_top/slave/HSIZE
add wave -noupdate /hdl_top/slave/HBURST
add wave -noupdate /hdl_top/slave/HREADYi
add wave -noupdate /hdl_top/slave/HRESP
add wave -noupdate -radix hexadecimal /hdl_top/slave/HRDATA
add wave -noupdate -radix hexadecimal /hdl_top/slave/HWDATA
add wave -noupdate /hdl_top/slave/HSPLIT
add wave -noupdate /hdl_top/ahb_if/burst_transfer
add wave -noupdate /hdl_top/ahb_if/single_transfer
add wave -noupdate -subitemconfig {{/hdl_top/ahb_if/slave_single_transfer[0]} {-height 30 -expand} {/hdl_top/ahb_if/slave_single_transfer[0].s0} -expand} /hdl_top/ahb_if/slave_single_transfer
add wave -noupdate -height 54 /hdl_top/ahb_if/arbitration
add wave -noupdate -format Literal /hdl_top/axi3_if/write_resp_channel_ready
add wave -noupdate -format Literal /hdl_top/axi3_if/write_resp_channel_cycle
add wave -noupdate -format Literal /hdl_top/axi3_if/write_channel_ready
add wave -noupdate -format Literal /hdl_top/axi3_if/write_channel_cycle
add wave -noupdate -format Literal /hdl_top/axi3_if/write_addr_channel_ready
add wave -noupdate -format Literal /hdl_top/axi3_if/write_addr_channel_cycle
add wave -noupdate -format Literal /hdl_top/axi3_if/read_channel_ready
add wave -noupdate -format Literal /hdl_top/axi3_if/read_channel_cycle
add wave -noupdate -format Literal /hdl_top/axi3_if/read_addr_channel_ready
add wave -noupdate -format Literal /hdl_top/axi3_if/read_addr_channel_cycle
add wave -noupdate -format Literal /hdl_top/axi3_if/write_resp_channel_phase
add wave -noupdate -format Literal /hdl_top/axi3_if/write_channel_phase
add wave -noupdate -format Literal /hdl_top/axi3_if/write_addr_channel_phase
add wave -noupdate -format Literal /hdl_top/axi3_if/read_channel_phase
add wave -noupdate -format Literal /hdl_top/axi3_if/read_addr_channel_phase
add wave -noupdate -format Literal /hdl_top/axi3_if/write_data_burst
add wave -noupdate -format Literal /hdl_top/axi3_if/read_data_burst
add wave -noupdate -format Literal /hdl_top/axi3_if/AXI_write
add wave -noupdate -format Literal /hdl_top/axi3_if/AXI_read
add wave -noupdate -format Literal /hdl_top/axi3_if/rw_transaction
add wave -noupdate -format Literal /hdl_top/axi3_if/AXI_ADDRESS_WIDTH
add wave -noupdate -format Literal /hdl_top/axi3_if/AXI_RDATA_WIDTH
add wave -noupdate -format Literal /hdl_top/axi3_if/AXI_WDATA_WIDTH
add wave -noupdate -format Literal /hdl_top/axi3_if/AXI_ID_WIDTH
add wave -noupdate -format Logic /hdl_top/axi3_if/iACLK
add wave -noupdate -format Logic /hdl_top/axi3_if/iARESETn
add wave -noupdate -format Logic /hdl_top/axi3_if/ACLK
add wave -noupdate -format Logic /hdl_top/axi3_if/ARESETn
add wave -noupdate -format Logic /hdl_top/axi3_if/AWVALID
add wave -noupdate -format Literal /hdl_top/axi3_if/AWADDR
add wave -noupdate -format Literal /hdl_top/axi3_if/AWLEN
add wave -noupdate -format Literal /hdl_top/axi3_if/AWSIZE
add wave -noupdate -format Literal /hdl_top/axi3_if/AWBURST
add wave -noupdate -format Literal /hdl_top/axi3_if/AWLOCK
add wave -noupdate -format Literal /hdl_top/axi3_if/AWCACHE
add wave -noupdate -format Literal /hdl_top/axi3_if/AWPROT
add wave -noupdate -format Literal /hdl_top/axi3_if/AWID
add wave -noupdate -format Logic /hdl_top/axi3_if/AWREADY
add wave -noupdate -format Literal /hdl_top/axi3_if/AWUSER
add wave -noupdate -format Logic /hdl_top/axi3_if/ARVALID
add wave -noupdate -format Literal /hdl_top/axi3_if/ARADDR
add wave -noupdate -format Literal /hdl_top/axi3_if/ARLEN
add wave -noupdate -format Literal /hdl_top/axi3_if/ARSIZE
add wave -noupdate -format Literal /hdl_top/axi3_if/ARBURST
add wave -noupdate -format Literal /hdl_top/axi3_if/ARLOCK
add wave -noupdate -format Literal /hdl_top/axi3_if/ARCACHE
add wave -noupdate -format Literal /hdl_top/axi3_if/ARPROT
add wave -noupdate -format Literal /hdl_top/axi3_if/ARID
add wave -noupdate -format Logic /hdl_top/axi3_if/ARREADY
add wave -noupdate -format Literal /hdl_top/axi3_if/ARUSER
add wave -noupdate -format Logic /hdl_top/axi3_if/RVALID
add wave -noupdate -format Logic /hdl_top/axi3_if/RLAST
add wave -noupdate -format Literal /hdl_top/axi3_if/RDATA
add wave -noupdate -format Literal /hdl_top/axi3_if/RRESP
add wave -noupdate -format Literal /hdl_top/axi3_if/RID
add wave -noupdate -format Logic /hdl_top/axi3_if/RREADY
add wave -noupdate -format Literal /hdl_top/axi3_if/RUSER
add wave -noupdate -format Logic /hdl_top/axi3_if/WVALID
add wave -noupdate -format Logic /hdl_top/axi3_if/WLAST
add wave -noupdate -format Literal /hdl_top/axi3_if/WDATA
add wave -noupdate -format Literal /hdl_top/axi3_if/WSTRB
add wave -noupdate -format Literal /hdl_top/axi3_if/WID
add wave -noupdate -format Logic /hdl_top/axi3_if/WREADY
add wave -noupdate -format Literal /hdl_top/axi3_if/WUSER
add wave -noupdate -format Logic /hdl_top/axi3_if/BVALID
add wave -noupdate -format Literal /hdl_top/axi3_if/BRESP
add wave -noupdate -format Literal /hdl_top/axi3_if/BID
add wave -noupdate -format Logic /hdl_top/axi3_if/BREADY
add wave -noupdate -format Literal /hdl_top/axi3_if/BUSER
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {2604 ns}
