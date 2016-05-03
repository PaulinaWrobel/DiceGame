if {$argc < 1} {
    puts "Missing testbench name"
    abort
}

set name $1

vcom -work work -2002 -explicit DG_NoSum.vhd
vcom -work work -2002 -explicit GameTest.vhd
vcom -work work -2002 -explicit TB_DG_0.vhd

vsim work.$name
view wave -title $name

add wave *
add wave sim:/tb_dg_0/UUT/state
add wave sim:/tb_dg_0/Test/state
add wave sim:/tb_dg_0/Test/n
run -all