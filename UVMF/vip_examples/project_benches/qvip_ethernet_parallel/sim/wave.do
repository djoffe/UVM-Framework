onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand {/hdl_top/ethernet_if/data_frame[0].d0}
add wave -noupdate -expand {/hdl_top/ethernet_if/control_frame[0].c0}
add wave -noupdate -subitemconfig {{/hdl_top/ethernet_if/data_frame[0]} {-height 32 -expand} {/hdl_top/ethernet_if/data_frame[0].d0} -expand} /hdl_top/ethernet_if/data_frame
add wave -noupdate -subitemconfig {{/hdl_top/ethernet_if/control_frame[0]} {-height 32 -expand} {/hdl_top/ethernet_if/control_frame[0].c0} -expand} /hdl_top/ethernet_if/control_frame
add wave -noupdate -expand -group DUT /hdl_top/DUT/clk_0
add wave -noupdate -expand -group DUT /hdl_top/DUT/clk_1
add wave -noupdate -expand -group DUT /hdl_top/DUT/reset
add wave -noupdate -expand -group DUT /hdl_top/DUT/rx_lane_0
add wave -noupdate -expand -group DUT /hdl_top/DUT/rx_lane_1
add wave -noupdate -expand -group DUT /hdl_top/DUT/rx_lane_2
add wave -noupdate -expand -group DUT /hdl_top/DUT/rx_lane_3
add wave -noupdate -expand -group DUT /hdl_top/DUT/tx_lane_0
add wave -noupdate -expand -group DUT /hdl_top/DUT/tx_lane_1
add wave -noupdate -expand -group DUT /hdl_top/DUT/tx_lane_2
add wave -noupdate -expand -group DUT /hdl_top/DUT/tx_lane_3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {62100 ns} 1} {{Cursor 2} {34607340 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 412
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
WaveRestoreZoom {34605042 ns} {34622758 ns}
