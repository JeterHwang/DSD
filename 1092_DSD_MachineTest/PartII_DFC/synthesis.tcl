read_file -format verilog ALU.v
read_file -format verilog DFC.v
current_design DFC

source DFC_DC.sdc
compile

report_timing > DFC_syn.timing_rpt
write_sdf -version 2.1 DFC_syn.sdf
write -f verilog -hierarchy -output DFC_syn.v
write -f ddc -hierarchy -output DFC_syn.ddc