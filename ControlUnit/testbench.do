# Start the simulation
vsim -voptargs=+acc work.tb_controlUnit

onerror {resume}
quietly WaveActivateNextPane {} 0

# Add clock
add wave -noupdate -divider {Inputs}
add wave -noupdate /tb_controlUnit/s_CLK

# Add input signals
add wave -noupdate -radix binary /tb_controlUnit/s_opcode
add wave -noupdate -radix binary /tb_controlUnit/s_funct3
add wave -noupdate -radix binary /tb_controlUnit/s_funct7

# Add output signals from testbench (connected to DUT outputs)
add wave -noupdate -divider {Outputs}
add wave -noupdate /tb_controlUnit/s_ALUsrc
add wave -noupdate -radix binary /tb_controlUnit/s_ALUctrl
add wave -noupdate -radix binary /tb_controlUnit/s_ImmType
add wave -noupdate -radix binary /tb_controlUnit/s_AndLink
add wave -noupdate /tb_controlUnit/s_MemWrite
add wave -noupdate /tb_controlUnit/s_RegWrite
add wave -noupdate /tb_controlUnit/s_MemToReg
add wave -noupdate /tb_controlUnit/s_Branch
add wave -noupdate /tb_controlUnit/s_Jump
add wave -noupdate /tb_controlUnit/s_ALUorImmJump
add wave -noupdate -radix binary /tb_controlUnit/s_FlagMux
add wave -noupdate /tb_controlUnit/s_FlagOrNFlag
add wave -noupdate /tb_controlUnit/s_JumpWReg

# Optional: Try to add DUT internal constants (may not be visible)
#add wave -noupdate -divider {DUT Internals}
#add wave -noupdate /tb_controlUnit/DUT/*

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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

# Run the simulation
run 3425 ns

# Zoom to fit the waveform
WaveRestoreZoom {0 ns} {3500 ns}