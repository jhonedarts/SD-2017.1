onerror {resume}
quietly virtual signal -install /SoC_tb/CHIP/HAZARD { (context /SoC_tb/CHIP/HAZARD )&{ID_BranchOrJump , IDEX_memRead }} Stall
quietly WaveActivateNextPane {} 0
add wave -noupdate -group IOmodule -group In /SoC_tb/CHIP/IO/write_control
add wave -noupdate -group IOmodule -group In -radix decimal /SoC_tb/CHIP/IO/write_data
add wave -noupdate -group IOmodule -group In -radix decimal /SoC_tb/CHIP/IO/address
add wave -noupdate -group IOmodule -group In -radix decimal /SoC_tb/CHIP/IO/data_out
add wave -noupdate -group IOmodule -group Serial /SoC_tb/CHIP/IO/write_control0
add wave -noupdate -group IOmodule -group Serial -radix decimal /SoC_tb/CHIP/IO/write_data0
add wave -noupdate -group IOmodule -group Serial -radix decimal /SoC_tb/CHIP/IO/address0
add wave -noupdate -group IOmodule -group Serial -radix decimal /SoC_tb/CHIP/IO/data_out0
add wave -noupdate -group IOmodule -group Memory /SoC_tb/CHIP/IO/write_control1
add wave -noupdate -group IOmodule -group Memory -radix decimal /SoC_tb/CHIP/IO/write_data1
add wave -noupdate -group IOmodule -group Memory -radix decimal /SoC_tb/CHIP/IO/address1
add wave -noupdate -group IOmodule -group Memory -radix decimal /SoC_tb/CHIP/IO/data_out1
add wave -noupdate -group MEMORY /SoC_tb/CHIP/MEMORY/mem_write
add wave -noupdate -group MEMORY -radix decimal /SoC_tb/CHIP/MEMORY/write_data
add wave -noupdate -group MEMORY -radix decimal /SoC_tb/CHIP/MEMORY/address
add wave -noupdate -group MEMORY -radix decimal /SoC_tb/CHIP/MEMORY/data_out
add wave -noupdate /SoC_tb/CHIP/DEMUX_MEM/Sel
add wave -noupdate -group Address_bus -radix decimal /SoC_tb/CHIP/MUX_MEM/A
add wave -noupdate -group Address_bus -radix decimal /SoC_tb/CHIP/MUX_MEM/B
add wave -noupdate -group Address_bus -radix decimal /SoC_tb/CHIP/MUX_MEM/out
add wave -noupdate -group Data_bus -radix decimal /SoC_tb/CHIP/DEMUX_MEM/data_in
add wave -noupdate -group Data_bus -radix decimal /SoC_tb/CHIP/DEMUX_MEM/data_out1
add wave -noupdate -group Data_bus -radix decimal /SoC_tb/CHIP/DEMUX_MEM/data_out2
add wave -noupdate -divider Divider
add wave -noupdate /SoC_tb/CHIP/clk
add wave -noupdate -divider IF
add wave -noupdate -group PC /SoC_tb/CHIP/PC/enable
add wave -noupdate -group PC -radix decimal -childformat {{{/SoC_tb/CHIP/PC/address[31]} -radix decimal} {{/SoC_tb/CHIP/PC/address[30]} -radix decimal} {{/SoC_tb/CHIP/PC/address[29]} -radix decimal} {{/SoC_tb/CHIP/PC/address[28]} -radix decimal} {{/SoC_tb/CHIP/PC/address[27]} -radix decimal} {{/SoC_tb/CHIP/PC/address[26]} -radix decimal} {{/SoC_tb/CHIP/PC/address[25]} -radix decimal} {{/SoC_tb/CHIP/PC/address[24]} -radix decimal} {{/SoC_tb/CHIP/PC/address[23]} -radix decimal} {{/SoC_tb/CHIP/PC/address[22]} -radix decimal} {{/SoC_tb/CHIP/PC/address[21]} -radix decimal} {{/SoC_tb/CHIP/PC/address[20]} -radix decimal} {{/SoC_tb/CHIP/PC/address[19]} -radix decimal} {{/SoC_tb/CHIP/PC/address[18]} -radix decimal} {{/SoC_tb/CHIP/PC/address[17]} -radix decimal} {{/SoC_tb/CHIP/PC/address[16]} -radix decimal} {{/SoC_tb/CHIP/PC/address[15]} -radix decimal} {{/SoC_tb/CHIP/PC/address[14]} -radix decimal} {{/SoC_tb/CHIP/PC/address[13]} -radix decimal} {{/SoC_tb/CHIP/PC/address[12]} -radix decimal} {{/SoC_tb/CHIP/PC/address[11]} -radix decimal} {{/SoC_tb/CHIP/PC/address[10]} -radix decimal} {{/SoC_tb/CHIP/PC/address[9]} -radix decimal} {{/SoC_tb/CHIP/PC/address[8]} -radix decimal} {{/SoC_tb/CHIP/PC/address[7]} -radix decimal} {{/SoC_tb/CHIP/PC/address[6]} -radix decimal} {{/SoC_tb/CHIP/PC/address[5]} -radix decimal} {{/SoC_tb/CHIP/PC/address[4]} -radix decimal} {{/SoC_tb/CHIP/PC/address[3]} -radix decimal} {{/SoC_tb/CHIP/PC/address[2]} -radix decimal} {{/SoC_tb/CHIP/PC/address[1]} -radix decimal} {{/SoC_tb/CHIP/PC/address[0]} -radix decimal}} -subitemconfig {{/SoC_tb/CHIP/PC/address[31]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[30]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[29]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[28]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[27]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[26]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[25]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[24]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[23]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[22]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[21]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[20]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[19]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[18]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[17]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[16]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[15]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[14]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[13]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[12]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[11]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[10]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[9]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[8]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[7]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[6]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[5]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[4]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[3]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[2]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[1]} {-height 15 -radix decimal} {/SoC_tb/CHIP/PC/address[0]} {-height 15 -radix decimal}} /SoC_tb/CHIP/PC/address
add wave -noupdate -group Jump -radix decimal /SoC_tb/CHIP/MUX_JUMP/A
add wave -noupdate -group Jump -radix decimal /SoC_tb/CHIP/MUX_JUMP/B
add wave -noupdate -group Jump /SoC_tb/CHIP/MUX_JUMP/Sel
add wave -noupdate -group Jump -radix decimal /SoC_tb/CHIP/MUX_JUMP/out
add wave -noupdate -group PossiblePcs -radix decimal /SoC_tb/CHIP/MUX_PC/A
add wave -noupdate -group PossiblePcs -radix decimal /SoC_tb/CHIP/MUX_PC/B
add wave -noupdate -group PossiblePcs -radix decimal /SoC_tb/CHIP/MUX_PC/C
add wave -noupdate -group PossiblePcs -radix decimal /SoC_tb/CHIP/MUX_PC/D
add wave -noupdate -group PossiblePcs /SoC_tb/CHIP/MUX_PC/Sel
add wave -noupdate -group PossiblePcs -radix decimal /SoC_tb/CHIP/MUX_PC/out
add wave -noupdate -divider ID
add wave -noupdate -group IF/ID /SoC_tb/CHIP/IFID/IFIDWrite
add wave -noupdate -group IF/ID -group In -radix decimal /SoC_tb/CHIP/IFID/PCplus_in
add wave -noupdate -group IF/ID -group In -radix decimal /SoC_tb/CHIP/IFID/Inst_in
add wave -noupdate -group IF/ID -group Out -radix decimal /SoC_tb/CHIP/IFID/PCplus_out
add wave -noupdate -group IF/ID -group Out -radix decimal /SoC_tb/CHIP/IFID/Inst_out
add wave -noupdate -group GPR /SoC_tb/CHIP/GPR/regWrite
add wave -noupdate -group GPR -radix decimal /SoC_tb/CHIP/GPR/w_data
add wave -noupdate -group GPR -radix unsigned /SoC_tb/CHIP/GPR/write_register
add wave -noupdate -group GPR -radix unsigned /SoC_tb/CHIP/GPR/read_register1
add wave -noupdate -group GPR -radix unsigned /SoC_tb/CHIP/GPR/read_register2
add wave -noupdate -group GPR -radix decimal /SoC_tb/CHIP/GPR/r_data1
add wave -noupdate -group GPR -radix decimal /SoC_tb/CHIP/GPR/r_data2
add wave -noupdate -group comparator -radix decimal /SoC_tb/CHIP/BRANCH_COMP/A
add wave -noupdate -group comparator -radix decimal /SoC_tb/CHIP/BRANCH_COMP/B
add wave -noupdate -group comparator /SoC_tb/CHIP/BRANCH_COMP/equal
add wave -noupdate -group comparator /SoC_tb/CHIP/BRANCH_COMP/result
add wave -noupdate -group UC /SoC_tb/CHIP/UC/opcode
add wave -noupdate -group UC /SoC_tb/CHIP/UC/funct
add wave -noupdate -group UC /SoC_tb/CHIP/UC/microcode
add wave -noupdate -group UC /SoC_tb/CHIP/UC/jump_flag
add wave -noupdate -group UC /SoC_tb/CHIP/UC/branch_flag
add wave -noupdate -group UC /SoC_tb/CHIP/UC/jal_flag
add wave -noupdate -group UC /SoC_tb/CHIP/UC/jr_flag
add wave -noupdate -group HazardUnit /SoC_tb/CHIP/HAZARD/Stall
add wave -noupdate -group HazardUnit /SoC_tb/CHIP/HAZARD/IFID_write
add wave -noupdate -group muxMicrocode -radix binary /SoC_tb/CHIP/MUX_IDflush/A
add wave -noupdate -group muxMicrocode -radix binary /SoC_tb/CHIP/MUX_IDflush/B
add wave -noupdate -group muxMicrocode /SoC_tb/CHIP/MUX_IDflush/Sel
add wave -noupdate -group muxMicrocode -radix binary /SoC_tb/CHIP/MUX_IDflush/out
add wave -noupdate -divider Divider
add wave -noupdate /SoC_tb/CHIP/clk
add wave -noupdate -divider EX
add wave -noupdate -group ID/EX -group In -radix decimal /SoC_tb/CHIP/IDEX/PCplus
add wave -noupdate -group ID/EX -group In /SoC_tb/CHIP/IDEX/WB
add wave -noupdate -group ID/EX -group In /SoC_tb/CHIP/IDEX/M
add wave -noupdate -group ID/EX -group In /SoC_tb/CHIP/IDEX/EX
add wave -noupdate -group ID/EX -group In -radix unsigned /SoC_tb/CHIP/IDEX/Rs
add wave -noupdate -group ID/EX -group In -radix unsigned /SoC_tb/CHIP/IDEX/Rt
add wave -noupdate -group ID/EX -group In -radix unsigned /SoC_tb/CHIP/IDEX/Rd
add wave -noupdate -group ID/EX -group In -radix decimal /SoC_tb/CHIP/IDEX/Data1
add wave -noupdate -group ID/EX -group In -radix decimal /SoC_tb/CHIP/IDEX/Data2
add wave -noupdate -group ID/EX -group In -radix decimal /SoC_tb/CHIP/IDEX/imm
add wave -noupdate -group ID/EX -group Out -radix decimal /SoC_tb/CHIP/IDEX/PCplus_out
add wave -noupdate -group ID/EX -group Out /SoC_tb/CHIP/IDEX/WB_out
add wave -noupdate -group ID/EX -group Out /SoC_tb/CHIP/IDEX/M_out
add wave -noupdate -group ID/EX -group Out /SoC_tb/CHIP/IDEX/EX_out
add wave -noupdate -group ID/EX -group Out -radix unsigned /SoC_tb/CHIP/IDEX/Rs_out
add wave -noupdate -group ID/EX -group Out -radix unsigned /SoC_tb/CHIP/IDEX/Rt_out
add wave -noupdate -group ID/EX -group Out -radix unsigned /SoC_tb/CHIP/IDEX/Rd_out
add wave -noupdate -group ID/EX -group Out -radix decimal /SoC_tb/CHIP/IDEX/Data1_out
add wave -noupdate -group ID/EX -group Out -radix decimal /SoC_tb/CHIP/IDEX/Data2_out
add wave -noupdate -group ID/EX -group Out -radix decimal /SoC_tb/CHIP/IDEX/imm_out
add wave -noupdate -group muxRD -radix unsigned /SoC_tb/CHIP/MUX_RD/A
add wave -noupdate -group muxRD -radix unsigned /SoC_tb/CHIP/MUX_RD/B
add wave -noupdate -group muxRD /SoC_tb/CHIP/MUX_RD/Sel
add wave -noupdate -group muxRD -radix unsigned /SoC_tb/CHIP/MUX_RD/out
add wave -noupdate -group Forwarding -group Signals /SoC_tb/CHIP/FORWARDING_UNIT/IDEX_RegWriteWB
add wave -noupdate -group Forwarding -group Signals /SoC_tb/CHIP/FORWARDING_UNIT/EXMEM_RegWriteWB
add wave -noupdate -group Forwarding -group Signals /SoC_tb/CHIP/FORWARDING_UNIT/MEMWB_RegWriteWB
add wave -noupdate -group Forwarding -group Signals /SoC_tb/CHIP/FORWARDING_UNIT/UC_Branch
add wave -noupdate -group Forwarding -group RegDest -radix unsigned /SoC_tb/CHIP/FORWARDING_UNIT/IDEX_Rd
add wave -noupdate -group Forwarding -group RegDest -radix unsigned /SoC_tb/CHIP/FORWARDING_UNIT/EXMEM_Rd
add wave -noupdate -group Forwarding -group RegDest -radix unsigned /SoC_tb/CHIP/FORWARDING_UNIT/MEMWB_Rd
add wave -noupdate -group Forwarding -group RegSource -radix unsigned /SoC_tb/CHIP/FORWARDING_UNIT/IFID_Rs
add wave -noupdate -group Forwarding -group RegSource -radix unsigned /SoC_tb/CHIP/FORWARDING_UNIT/IFID_Rt
add wave -noupdate -group Forwarding -group RegSource -radix unsigned /SoC_tb/CHIP/FORWARDING_UNIT/IDEX_Rs
add wave -noupdate -group Forwarding -group RegSource -radix unsigned /SoC_tb/CHIP/FORWARDING_UNIT/IDEX_Rt
add wave -noupdate -group Forwarding -group Out /SoC_tb/CHIP/FORWARDING_UNIT/ForwardA
add wave -noupdate -group Forwarding -group Out /SoC_tb/CHIP/FORWARDING_UNIT/ForwardB
add wave -noupdate -group Forwarding -group Out /SoC_tb/CHIP/FORWARDING_UNIT/ForwardC
add wave -noupdate -group Forwarding -group Out /SoC_tb/CHIP/FORWARDING_UNIT/ForwardD
add wave -noupdate -group muxForwardA -radix decimal /SoC_tb/CHIP/MUX_FA/A
add wave -noupdate -group muxForwardA -radix decimal /SoC_tb/CHIP/MUX_FA/B
add wave -noupdate -group muxForwardA -radix decimal /SoC_tb/CHIP/MUX_FA/C
add wave -noupdate -group muxForwardA -radix decimal /SoC_tb/CHIP/MUX_FA/D
add wave -noupdate -group muxForwardA /SoC_tb/CHIP/MUX_FA/Sel
add wave -noupdate -group muxForwardA -radix decimal /SoC_tb/CHIP/MUX_FA/out
add wave -noupdate -group muxForwardB -radix decimal /SoC_tb/CHIP/MUX_FB/A
add wave -noupdate -group muxForwardB -radix decimal /SoC_tb/CHIP/MUX_FB/B
add wave -noupdate -group muxForwardB -radix decimal /SoC_tb/CHIP/MUX_FB/C
add wave -noupdate -group muxForwardB -radix decimal /SoC_tb/CHIP/MUX_FB/D
add wave -noupdate -group muxForwardB /SoC_tb/CHIP/MUX_FB/Sel
add wave -noupdate -group muxForwardB -radix decimal /SoC_tb/CHIP/MUX_FB/out
add wave -noupdate -group muxForwardC -radix decimal /SoC_tb/CHIP/MUX_FC/A
add wave -noupdate -group muxForwardC -radix decimal /SoC_tb/CHIP/MUX_FC/B
add wave -noupdate -group muxForwardC -radix decimal /SoC_tb/CHIP/MUX_FC/C
add wave -noupdate -group muxForwardC -radix decimal /SoC_tb/CHIP/MUX_FC/D
add wave -noupdate -group muxForwardC /SoC_tb/CHIP/MUX_FC/Sel
add wave -noupdate -group muxForwardC -radix decimal /SoC_tb/CHIP/MUX_FC/out
add wave -noupdate -group muxForwardD -radix decimal /SoC_tb/CHIP/MUX_FD/A
add wave -noupdate -group muxForwardD -radix decimal /SoC_tb/CHIP/MUX_FD/B
add wave -noupdate -group muxForwardD -radix decimal /SoC_tb/CHIP/MUX_FD/C
add wave -noupdate -group muxForwardD -radix decimal /SoC_tb/CHIP/MUX_FD/D
add wave -noupdate -group muxForwardD /SoC_tb/CHIP/MUX_FD/Sel
add wave -noupdate -group muxForwardD -radix decimal /SoC_tb/CHIP/MUX_FD/out
add wave -noupdate -group muxImmediate -radix decimal /SoC_tb/CHIP/MUX_IMMEDIATE/A
add wave -noupdate -group muxImmediate -radix decimal /SoC_tb/CHIP/MUX_IMMEDIATE/B
add wave -noupdate -group muxImmediate /SoC_tb/CHIP/MUX_IMMEDIATE/Sel
add wave -noupdate -group muxImmediate -radix decimal /SoC_tb/CHIP/MUX_IMMEDIATE/out
add wave -noupdate -group ALUDEC /SoC_tb/CHIP/ALUDEC/funct
add wave -noupdate -group ALUDEC /SoC_tb/CHIP/ALUDEC/opcode
add wave -noupdate -group ALUDEC /SoC_tb/CHIP/ALUDEC/ALUop
add wave -noupdate -group ALU -radix decimal /SoC_tb/CHIP/ALU/A
add wave -noupdate -group ALU -radix decimal /SoC_tb/CHIP/ALU/B
add wave -noupdate -group ALU /SoC_tb/CHIP/ALU/ALUop
add wave -noupdate -group ALU -radix decimal /SoC_tb/CHIP/ALU/ALUresult
add wave -noupdate -group ALU /SoC_tb/CHIP/ALU/zero
add wave -noupdate -group ALU /SoC_tb/CHIP/ALU/overflow
add wave -noupdate -group ALU -radix decimal /SoC_tb/CHIP/ALU/HI
add wave -noupdate -group ALU -radix decimal /SoC_tb/CHIP/ALU/LO
add wave -noupdate -divider Divider
add wave -noupdate /SoC_tb/CHIP/clk
add wave -noupdate -divider MEM
add wave -noupdate -group EX/MEM -group In -radix decimal /SoC_tb/CHIP/EXMEM/PCplus
add wave -noupdate -group EX/MEM -group In /SoC_tb/CHIP/EXMEM/WB
add wave -noupdate -group EX/MEM -group In /SoC_tb/CHIP/EXMEM/M
add wave -noupdate -group EX/MEM -group In -radix unsigned /SoC_tb/CHIP/EXMEM/Rd
add wave -noupdate -group EX/MEM -group In -radix decimal /SoC_tb/CHIP/EXMEM/ALUresult
add wave -noupdate -group EX/MEM -group In -radix decimal /SoC_tb/CHIP/EXMEM/WriteData
add wave -noupdate -group EX/MEM -group Out -radix decimal /SoC_tb/CHIP/EXMEM/PCplus_out
add wave -noupdate -group EX/MEM -group Out /SoC_tb/CHIP/EXMEM/WB_out
add wave -noupdate -group EX/MEM -group Out /SoC_tb/CHIP/EXMEM/M_out
add wave -noupdate -group EX/MEM -group Out -radix unsigned /SoC_tb/CHIP/EXMEM/Rd_out
add wave -noupdate -group EX/MEM -group Out -radix decimal /SoC_tb/CHIP/EXMEM/ALUresult_out
add wave -noupdate -group EX/MEM -group Out -radix decimal /SoC_tb/CHIP/EXMEM/WriteData_out
add wave -noupdate -divider WB
add wave -noupdate -group MEM/WB -group In -radix decimal /SoC_tb/CHIP/MEMWB/PCplus
add wave -noupdate -group MEM/WB -group In /SoC_tb/CHIP/MEMWB/WB
add wave -noupdate -group MEM/WB -group In -radix unsigned /SoC_tb/CHIP/MEMWB/Rd
add wave -noupdate -group MEM/WB -group In -radix decimal /SoC_tb/CHIP/MEMWB/MemData
add wave -noupdate -group MEM/WB -group In -radix decimal /SoC_tb/CHIP/MEMWB/ALUresult
add wave -noupdate -group MEM/WB -group Out -radix decimal /SoC_tb/CHIP/MEMWB/PCplus_out
add wave -noupdate -group MEM/WB -group Out /SoC_tb/CHIP/MEMWB/WB_out
add wave -noupdate -group MEM/WB -group Out -radix unsigned /SoC_tb/CHIP/MEMWB/Rd_out
add wave -noupdate -group MEM/WB -group Out -radix decimal /SoC_tb/CHIP/MEMWB/MemData_out
add wave -noupdate -group MEM/WB -group Out -radix decimal /SoC_tb/CHIP/MEMWB/ALUresult_out
add wave -noupdate -group WB_return -radix decimal /SoC_tb/CHIP/MUX_ReturnData/A
add wave -noupdate -group WB_return -radix decimal /SoC_tb/CHIP/MUX_ReturnData/B
add wave -noupdate -group WB_return -radix decimal /SoC_tb/CHIP/MUX_ReturnData/C
add wave -noupdate -group WB_return -radix decimal /SoC_tb/CHIP/MUX_ReturnData/D
add wave -noupdate -group WB_return /SoC_tb/CHIP/MUX_ReturnData/Sel
add wave -noupdate -group WB_return -radix decimal /SoC_tb/CHIP/MUX_ReturnData/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 6} {279000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 298
configure wave -valuecolwidth 141
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
configure wave -timelineunits ps
update
WaveRestoreZoom {105603 ps} {316547 ps}
bookmark add wave bookmark0 {{0 ps} {913 ps}} 0
