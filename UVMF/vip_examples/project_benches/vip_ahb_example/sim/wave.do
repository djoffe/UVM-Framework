onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hdl_top/DUT/HRESETn
add wave -noupdate /hdl_top/DUT/HCLK
add wave -noupdate -radix hexadecimal /hdl_top/DUT/HADDR
add wave -noupdate /hdl_top/DUT/HWRITE
add wave -noupdate /hdl_top/DUT/HTRANS
add wave -noupdate /hdl_top/DUT/HSIZE
add wave -noupdate /hdl_top/DUT/HBURST
add wave -noupdate /hdl_top/DUT/HREADYi
add wave -noupdate /hdl_top/DUT/HRESP
add wave -noupdate -radix hexadecimal /hdl_top/DUT/HRDATA
add wave -noupdate -radix hexadecimal /hdl_top/DUT/HWDATA
add wave -noupdate /hdl_top/DUT/HSPLIT
add wave -noupdate /hdl_top/ahb_if/burst_transfer
add wave -noupdate /hdl_top/ahb_if/single_transfer
add wave -noupdate -subitemconfig {{/hdl_top/ahb_if/slave_single_transfer[0]} {-height 30 -expand} {/hdl_top/ahb_if/slave_single_transfer[0].s0} -expand} /hdl_top/ahb_if/slave_single_transfer
add wave -noupdate -height 54 /hdl_top/ahb_if/arbitration
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {97525 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 230
configure wave -valuecolwidth 74
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
WaveRestoreZoom {51668 ns} {53332 ns}
