onerror {resume}

radix define ahb_transfer_type {
    "0" "AHB_IDLE",
    "1" "AHB_BUSY",
    "2" "AHB_NONSEQ",
    "3" "AHB_SEQ",
    -default default
}
radix define ahb_burst_type {
    "0" "AHB_SINGLE",
    "1" "AHB_INCR",
    "2" "AHB_WRAP4",
    "3" "AHB_INCR4",
    "4" "AHB_WRAP8",
    "5" "AHB_INCR8",
    "6" "AHB_WRAP16",
    "7" "AHB_INCR16",
    -default default
}
radix define ahb_transfer_size {
    "0" "AHB_BITS_8",
    "1" "AHB_BITS_16",
    "2" "AHB_BITS_32",
    "3" "AHB_BITS_64",
    "4" "AHB_BITS_128",
    "5" "AHB_BITS_256",
    "6" "AHB_BITS_512",
    "7" "AHB_BITS_2014",
    -default default
}

radix define ahb_slave_response {
    "0" "AHB_OKAY",
    "1" "AHB_ERROR",
    "2" "AHB_RETRY",
    "3" "AHB_SPLIT",
    -default default
}


quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -subitemconfig {{/hdl_top/qvip_ahb_monitor_if/burst_transfer[0]} {-height 32}} /hdl_top/qvip_ahb_monitor_if/burst_transfer
add wave -noupdate -expand -subitemconfig {{/hdl_top/qvip_ahb_monitor_if/single_transfer[0]} {-height 32}} /hdl_top/qvip_ahb_monitor_if/single_transfer
add wave -noupdate -expand -subitemconfig {{/hdl_top/qvip_ahb_monitor_if/slave_single_transfer[0]} {-height 32} {/hdl_top/qvip_ahb_monitor_if/slave_single_transfer[1]} {-height 32}} /hdl_top/qvip_ahb_monitor_if/slave_single_transfer
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/HCLK
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/HRESETn
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/HGRANT
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/master_HBUSREQ
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/master_HADDR
add wave -noupdate -radix ahb_transfer_type /hdl_top/qvip_ahb_monitor_if/master_HTRANS
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/master_HWRITE
add wave -noupdate -radix ahb_transfer_size /hdl_top/qvip_ahb_monitor_if/master_HSIZE
add wave -noupdate -radix ahb_burst_type /hdl_top/qvip_ahb_monitor_if/master_HBURST
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/master_HPROT
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/master_HWDATA
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/master_HRDATA
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/slave_HREADY
add wave -noupdate -radix ahb_transfer_type /hdl_top/qvip_ahb_monitor_if/slave_HTRANS
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/slave_HWRITE
add wave -noupdate -radix ahb_transfer_size /hdl_top/qvip_ahb_monitor_if/slave_HSIZE
add wave -noupdate -radix ahb_burst_type /hdl_top/qvip_ahb_monitor_if/slave_HBURST
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/slave_HPROT
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/slave_HMASTER
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/slave_HWDATA
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/slave_HRDATA
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/slave_HSEL
add wave -noupdate -radix ahb_slave_response /hdl_top/qvip_ahb_monitor_if/slave_HRESP
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/HREADY
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/decoder_HADDR
add wave -noupdate -radix ahb_burst_type /hdl_top/qvip_ahb_monitor_if/arbiter_HBURST
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/arbiter_HBUSREQ
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/master_HLOCK
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/HMASTER
add wave -noupdate /hdl_top/qvip_ahb_monitor_if/arbiter_HMASTLOCK

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 472
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {27 ns} {168 ns}

