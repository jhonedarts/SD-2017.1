proc start {m} {vsim -L cycloneive_ver -sdftyp /DUT2=../../../syn/src/ALU_v.sdo work.$m}
set MODULE ALUTestVectorTestbench
start $MODULE
add wave $MODULE/*
add wave $MODULE/DUT1/*
add wave $MODULE/DUT2/*
run 100us
