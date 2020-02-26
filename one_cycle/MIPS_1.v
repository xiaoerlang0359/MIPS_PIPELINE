`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/24 09:38:09
// Design Name: 
// Module Name: MIPS_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MIPS_1(
        input clk,
        input rst
    );
    wire [31:0] Instruction;
    wire en,Jmp,Jal,Jr,Branch;
    wire [31:0] Addr_Beq;
    wire [31:0] Addr_Jmp;
    wire [31:0] Read_data_1;
    wire [31:0] PC_plus_4;
    wire [5:0] Op_Code;
    wire [5:0] Function_Code;
    wire Syscall,RegDst,RegWrite,MemtoReg,SignedExt;
    wire [31:0] Read_data_2;
    wire [31:0] SignedExt_imm;
    wire [31:0] Alu_result;
    wire [31:0] Mem_read_data;
    wire [4:0] Shamt;
    wire MemWrite,AluSrcB,Beq,Bne;
    wire [3:0] AluOP;
    assign en=1'b1;
ifetch ifetch0(
        .Instruction(Instruction),.rst(rst),.clk(clk),.en(en),.Jmp(Jmp),.Jal(Jal),
        .Jr(Jr),.Branch(Branch),.Addr_Beq(Addr_Beq),.Addr_Jmp(Addr_Jmp),.Addr_Jr(Read_data_1),
        .PC_plus_4(PC_plus_4)
);
idecode idecode0(
        .Instruction(Instruction),.Op_Code(Op_Code),.Function_Code(Function_Code),.Syscall(Syscall),
        .RegDst(RegDst),.Jal(Jal),.RegWrite(RegWrite),.MemtoReg(MemtoReg),.clk(clk),.rst(rst),
        .SignedExt(SignedExt),.Addr_Jmp(Addr_Jmp),.Addr_Beq(Addr_Beq),.Read_data_1(Read_data_1),
        .Read_data_2(Read_data_2),.SignedExt_imm(SignedExt_imm),.PC_plus_4(PC_plus_4),
        .Alu_result(Alu_result),.Mem_read_data(Mem_read_data),.Shamt(Shamt)
);
control control0(
        .Op_Code(Op_Code),.Function_Code(Function_Code),.Beq(Beq),.Bne(Bne),.MemtoReg(MemtoReg),
        .MemWrite(MemWrite),.AluOP(AluOP),.AluSrcB(AluSrcB),.RegWrite(RegWrite),.Jal(Jal),
        .RegDst(RegDst),.Syscall(Syscall),.Jmp(Jmp),.Jr(Jr),.SignedExt(SignedExt)
);
exe exe0(
        .Read_data_1(Read_data_1),.Read_data_2(Read_data_2),.SignedExt_imm(SignedExt_imm),.AluOP(AluOP),
        .AluSrcB(AluSrcB),.Beq(Beq),.Bne(Bne),.Shamt(Shamt),.Alu_result(Alu_result),.Branch(Branch)
);  
dmem dmem0(
        .address(Alu_result),.Store_data(Read_data_2),.MemWrite(MemWrite),.clk(clk),.Mem_read_data(Mem_read_data)
    );   
endmodule
