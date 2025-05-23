vlib work
vlog -f src_files.list +cover
vsim -voptargs=+acc work.top -cover -classdebug -uvmcontrol=all
add wave /top/FIFOif/*
run -all
coverage save FIFO_top.ucdb -onexit