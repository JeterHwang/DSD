read_file -format verilog cache_dm.v
source cache_syn.sdc
compile
write_sdf -version 2.1 cache_dm_syn.sdf
write -format verilog -hier -output cache_dm_syn.v
write -format ddc     -hier -output cache_dm_syn.ddc
