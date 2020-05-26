rm -rf fifo_int_tb.ghw fifo_int_tb
ghdl -a fifo_int.vhd
ghdl -a fifo_int_tb.vhd
ghdl -e fifo_int_tb
ghdl -r fifo_int_tb --wave=fifo_int_tb.ghw
gtkwave fifo_int_tb.ghw fifo_int_tb.sav
