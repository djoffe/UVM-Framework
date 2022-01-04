onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /hdl_top/rc/pcie_rc/current_state
add wave -noupdate /hdl_top/rc/pcie_rc/current_substate
add wave -noupdate /hdl_top/rc/pcie_rc/ts_os
add wave -noupdate /hdl_top/rc/pcie_rc/transport
add wave -noupdate -subitemconfig {{/hdl_top/rc/pcie_rc/request[0]} {-height 32}} /hdl_top/rc/pcie_rc/request
add wave -noupdate /hdl_top/rc/pcie_rc/completion
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13487375879 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 211
configure wave -valuecolwidth 170
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
WaveRestoreZoom {0 fs} {14189700211 fs}
