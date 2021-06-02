module Decompressor(inst_16,
                    inst_32,
                    jj
    );
    /* ==================== IO ==================== */
    input  [15:0] inst_16;
    output [31:0] inst_32;
    output        jj;
    /* ================= WIRE/REG ================= */
    reg  [29:0]inst_30;
    wire [1:0] C     ;
    wire [2:0] fun3  ;

    wire [2:0] rd_rs2;
    wire [2:0] rs1   ;
    wire [6:0] imm_ls;

    wire       imm_12;
    wire [4:0] imm_rs2;
    wire [4:0] rd_rs1;
    wire       imm_rs2_eqz;
    wire [20:1]jal_addr;
    wire [12:1]bra_addr;
    wire [4:0] IOP,SBOP,UJOP,ROP,JALR;
    /* ================== Conti =================== */
    //output
    assign inst_32= {inst_30,2'b11};
    assign jj     = inst_30[0];
    
    assign C      = inst_16[1:0];
    assign fun3   = inst_16[15:13];
    //C0 DECODER
    assign rd_rs2 = inst_16[4:2];
    assign rs1    = inst_16[9:7];
    assign imm_ls = {inst_16[5],inst_16[12:10],inst_16[6],2'b0};

    //C2 DECODER
    assign imm_12 = inst_16[12];
    assign imm_rs2= inst_16[6:2];
    assign rd_rs1 = inst_16[11:7];
    assign imm_rs2_eqz = ~|(imm_rs2);

    assign jal_addr = {{10{inst_16[12]}},inst_16[8],inst_16[10:9],inst_16[6],inst_16[7],inst_16[2],inst_16[11],inst_16[5:3]};
    assign bra_addr = {{5{inst_16[12]}},inst_16[6:5],inst_16[2],inst_16[11:10],inst_16[4:3]};

    //opcode
    assign IOP  = 5'b00100;
    assign SBOP = 5'b11000;
    assign UJOP = 5'b11011;
    assign ROP  = 5'b01100;
    assign JALR = 5'b11001;

    //for optimize
    wire opt1,opt2; //distinguish ANDI & SRLI(SRAI)
    wire [4:0] opt3;
    assign opt1 = rd_rs1[4]&imm_12;
    assign opt2 = rd_rs1[3]|opt1;//(~opt1&rd_rs1[3])|opt1 = rd_rs1[3]|opt1
    assign opt3 = rd_rs1&{5{imm_12}};
    /* ================ Combination =============== */
    always @(*) begin
        inst_30 = 30'b0;  
        case (C)
            2'b00:begin  //C0 for C.LW or C.SW
                if (fun3[2]==1'b0) inst_30 = {{5'b0,imm_ls},{2'b01,rs1},3'b010,{2'b01,rd_rs2},5'b00000};   //LW(I)
                else inst_30 = {{5'b0,imm_ls[6:5]},{2'b01,rd_rs2},{2'b01,rs1},3'b010,imm_ls[4:0],5'b01000};//SW(S)
            end 
            2'b01:begin  //C1
                case (fun3)
                    3'b000:inst_30 = {{{7{imm_12}},imm_rs2},rd_rs1,3'b000,rd_rs1,IOP};                                     //ADDI(I) & NOP
                    3'b001:inst_30 = {jal_addr[20],jal_addr[10:1],jal_addr[11],jal_addr[19:12],5'b1,UJOP};                 //JAL(UJ) 
                    3'b101:inst_30 = {jal_addr[20],jal_addr[10:1],jal_addr[11],jal_addr[19:12],5'b0,UJOP};                 //J = jal(UJ)
                    3'b110:inst_30 = {bra_addr[12],bra_addr[10:5],5'b0,{2'b01,rs1},3'b000,bra_addr[4:1],bra_addr[11],SBOP};//BEQZ(SB)
                    3'b111:inst_30 = {bra_addr[12],bra_addr[10:5],5'b0,{2'b01,rs1},3'b001,bra_addr[4:1],bra_addr[11],SBOP};//BNEZ(SB)
                    3'b100:inst_30 = {opt1,opt2,{5{opt1}},imm_rs2,{2'b01,rs1},{1'b1,rd_rs1[4],1'b1},{2'b01,rs1},IOP};      //SRLI(I) & SRAI(I) & ANDI(I)                                                          
                endcase
            end
            2'b10:begin  //C2
                case (fun3[2]) // combine select signal trade off betewwn AT
                    1'b0:inst_30 = {{{7{imm_12}},imm_rs2},rd_rs1,3'b001,rd_rs1,IOP}; // SLLI
                    1'b1:begin
                        case (imm_rs2_eqz)
                            1'b0:inst_30 = {7'b0,imm_rs2,opt3,3'b000,rd_rs1,ROP};          //MV = ADD(R) & ADD(R)
                            1'b1:inst_30 = {7'b0,imm_rs2,rd_rs1,3'b000,{4'b0,imm_12},JALR};//JR(I) & JALR(I)
                        endcase
                    end 
                endcase
            end
        endcase
    end
    
endmodule