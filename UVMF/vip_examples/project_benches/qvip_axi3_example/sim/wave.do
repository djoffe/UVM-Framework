onerror {resume}
radix define axi_size {
    "0" "AXI_BYTES_1",
    "1" "AXI_BYTES_2",
    "2" "AXI_BYTES_4",
    "3" "AXI_BYTES_8",
    "4" "AXI_BYTES_16",
    "5" "AXI_BYTES_32",
    "6" "AXI_BYTES_64",
    "7" "AXI_BYTES_128",
    -default default
}
radix define axi_burst {
    "0" "AXI_FIXED",
    "1" "AXI_INCR",
    "2" "AXI_WRAP",
    "3" "AXI_RESERVED",
    -default default
}
radix define axi_lock {
    "0" "AXI_NORMAL",
    "1" "AXI_EXCLUSIVE",
    "2" "AXI_LOCKED",
    "3" "AXI_LOCK_RSVD",
    -default default
}
radix define axi_response {
    "0" "AXI_OKAY",
    "1" "AXI_EXOKAY",
    "2" "AXI_SLVERR",
    "3" "AXI_DECERR",
    -default default
}
radix define axi_prot {
    "0" "AXI_NORM_SEC_DATA",
    "1" "AXI_PRIV_SEC_DATA",
    "2" "AXI_NORM_NONSEC_DATA",
    "3" "AXI_PRIV_NONSEC_DATA",
    "4" "AXI_NORM_SEC_INST",
    "5" "AXI_PRIV_SEC_INST",
    "6" "AXI_NORM_NONSEC_INST",
    "7" "AXI_PRIV_NONSEC_INST",
    -default default
}
radix define axi_len {
    "0" "AXI_LENGTH_1",
    "1" "AXI_LENGTH_2",
    "2" "AXI_LENGTH_3",
    "3" "AXI_LENGTH_4",
    "4" "AXI_LENGTH_5",
    "5" "AXI_LENGTH_6",
    "6" "AXI_LENGTH_7",
    "7" "AXI_LENGTH_8",
    "8" "AXI_LENGTH_9",
    "9" "AXI_LENGTH_10",
    "10" "AXI_LENGTH_11",
    "11" "AXI_LENGTH_12",
    "12" "AXI_LENGTH_13",
    "13" "AXI_LENGTH_14",
    "14" "AXI_LENGTH_15",
    "15" "AXI_LENGTH_16",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hdl_top/axi3_if/rw_transaction
add wave -noupdate /hdl_top/axi3_if/AXI_write
add wave -noupdate /hdl_top/axi3_if/AXI_read
add wave -noupdate /hdl_top/axi3_if/write_channel_phase
add wave -noupdate /hdl_top/axi3_if/write_channel_cycle
add wave -noupdate /hdl_top/axi3_if/write_addr_channel_phase
add wave -noupdate /hdl_top/axi3_if/write_addr_channel_cycle
add wave -noupdate /hdl_top/axi3_if/write_data_burst
add wave -noupdate /hdl_top/axi3_if/write_resp_channel_cycle
add wave -noupdate /hdl_top/axi3_if/write_resp_channel_phase
add wave -noupdate /hdl_top/axi3_if/read_addr_channel_phase
add wave -noupdate /hdl_top/axi3_if/read_addr_channel_cycle
add wave -noupdate /hdl_top/axi3_if/read_channel_phase
add wave -noupdate /hdl_top/axi3_if/read_channel_cycle
add wave -noupdate /hdl_top/axi3_if/read_data_burst
add wave -noupdate /hdl_top/axi3_if/ACLK
add wave -noupdate /hdl_top/axi3_if/ARESETn
add wave -noupdate /hdl_top/axi3_if/AWVALID
add wave -noupdate /hdl_top/axi3_if/AWADDR
add wave -noupdate /hdl_top/axi3_if/AWLEN
add wave -noupdate -radix axi_size /hdl_top/axi3_if/AWSIZE
add wave -noupdate -radix axi_burst /hdl_top/axi3_if/AWBURST
add wave -noupdate -radix axi_lock /hdl_top/axi3_if/AWLOCK
add wave -noupdate /hdl_top/axi3_if/AWCACHE
add wave -noupdate -radix axi_prot /hdl_top/axi3_if/AWPROT
add wave -noupdate /hdl_top/axi3_if/AWID
add wave -noupdate /hdl_top/axi3_if/AWREADY
add wave -noupdate /hdl_top/axi3_if/WVALID
add wave -noupdate /hdl_top/axi3_if/WLAST
add wave -noupdate /hdl_top/axi3_if/WDATA
add wave -noupdate /hdl_top/axi3_if/WSTRB
add wave -noupdate /hdl_top/axi3_if/WID
add wave -noupdate /hdl_top/axi3_if/WREADY
add wave -noupdate /hdl_top/axi3_if/BVALID
add wave -noupdate -radix axi_response /hdl_top/axi3_if/BRESP
add wave -noupdate /hdl_top/axi3_if/BID
add wave -noupdate /hdl_top/axi3_if/BREADY
add wave -noupdate /hdl_top/axi3_if/ARVALID
add wave -noupdate /hdl_top/axi3_if/ARADDR
add wave -noupdate /hdl_top/axi3_if/ARLEN
add wave -noupdate -radix axi_size /hdl_top/axi3_if/ARSIZE
add wave -noupdate -radix axi_burst /hdl_top/axi3_if/ARBURST
add wave -noupdate -radix axi_lock /hdl_top/axi3_if/ARLOCK
add wave -noupdate /hdl_top/axi3_if/ARCACHE
add wave -noupdate -radix axi_prot /hdl_top/axi3_if/ARPROT
add wave -noupdate /hdl_top/axi3_if/ARID
add wave -noupdate /hdl_top/axi3_if/ARREADY
add wave -noupdate /hdl_top/axi3_if/RVALID
add wave -noupdate /hdl_top/axi3_if/RLAST
add wave -noupdate /hdl_top/axi3_if/RDATA
add wave -noupdate -radix axi_response /hdl_top/axi3_if/RRESP
add wave -noupdate /hdl_top/axi3_if/RID
add wave -noupdate /hdl_top/axi3_if/RREADY
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {96765 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 235
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
WaveRestoreZoom {0 ns} {105 us}
