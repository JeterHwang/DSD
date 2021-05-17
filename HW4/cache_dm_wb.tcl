read_file -format verilog cache_dm_wb.v
source cache_syn.sdc
compile
write_sdf -version 2.1 cache_dm_wb_syn.sdf
write -format verilog -hier -output cache_dm_wb_syn.v
write -format ddc     -hier -output cache_dm_wb_syn.ddc