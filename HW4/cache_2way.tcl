read_file -format verilog cache_2way.v
source cache_syn.sdc
compile
write_sdf -version 2.1 cache_2way_syn.sdf
write -format verilog -hier -output cache_2way_syn.v
write -format ddc     -hier -output cache_2way_syn.ddc
