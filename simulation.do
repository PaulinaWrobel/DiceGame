if {$argc < 1} {
    puts "Missing testbench name"
    abort
}

set name $1

if {$name == "TB_DG_0"} {

vcom -work work -2002 -explicit DG_NoSum.vhd
vcom -work work -2002 -explicit GameTest.vhd
vcom -work work -2002 -explicit TB_DG_0.vhd

vsim -assertdebug -msgmode both work.$name
view wave -title $name

add wave *
add wave sim:/tb_dg_0/UUT/state
add wave sim:/tb_dg_0/Test/state
run -all

}

if {$name == "TB_DG_ALL"} {

vcom -work work -2002 -explicit clk_gen.vhd
vcom -work work -2002 -explicit led4dp_driver.vhd

vcom -work work -2002 -explicit DFlipFlop.vhd
vcom -work work -2002 -explicit fullAdder.vhd
vcom -work work -2002 -explicit register.vhd
vcom -work work -2002 -explicit executiveSystem.vhd
vcom -work work -2002 -explicit control2.vhd
vcom -work work -2002 -explicit serialAdder.vhd

vcom -work work -2002 -explicit counter.vhd
vcom -work work -2002 -explicit DG_NoSum.vhd
vcom -work work -2002 -explicit DG_ALL.vhd
vcom -work work -2008 -explicit TB_DG_ALL.vhd

vsim -assertdebug -msgmode both work.$name
view wave -title $name

add wave -position insertpoint sim:/tb_dg_all/state
add wave -position insertpoint sim:/tb_dg_all/ResetI
add wave -position insertpoint sim:/tb_dg_all/RbI
add wave -position insertpoint sim:/tb_dg_all/WinI
add wave -position insertpoint sim:/tb_dg_all/LoseI

add wave -position insertpoint sim:/tb_dg_all/UUT/Roll
add wave -position insertpoint sim:/tb_dg_all/UUT/stop
add wave -position insertpoint sim:/tb_dg_all/UUT/Rb_stop
add wave -position insertpoint sim:/tb_dg_all/UUT/clk_10Hz
add wave -position insertpoint sim:/tb_dg_all/UUT/clk_A
add wave -position insertpoint sim:/tb_dg_all/UUT/clk_B
add wave -position insertpoint sim:/tb_dg_all/UUT/DG_NoSum/state

add wave -position insertpoint sim:/tb_dg_all/UUT/numberA
add wave -position insertpoint sim:/tb_dg_all/UUT/numberB
add wave -position insertpoint sim:/tb_dg_all/UUT/Sum
add wave -position insertpoint sim:/tb_dg_all/UUT/DG_NoSum/SumReg

add wave -position insertpoint sim:/tb_dg_all/UUT/DG_NoSum/Eq
add wave -position insertpoint sim:/tb_dg_all/UUT/DG_NoSum/D7
add wave -position insertpoint sim:/tb_dg_all/UUT/DG_NoSum/D711
add wave -position insertpoint sim:/tb_dg_all/UUT/DG_NoSum/D2312

run -all
}

if {$name == "clk_gen"} {

vcom -work work -2002 -explicit clk_gen.vhd
vsim -assertdebug -msgmode both work.$name
view wave -title $name
add wave *
force clk_in 1 0, 0 10 ns -r 20 ns
run 500 ms
}