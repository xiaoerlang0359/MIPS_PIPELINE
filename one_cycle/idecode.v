`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/22 22:20:28
// Design Name: 
// Module Name: idecode
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


module idecode(
        input [31:0] Instruction,
        output [5:0] Op_Code,
        output [5:0] Function_Code,
        input Syscall,
        input RegDst,
        input Jal,
        input RegWrite,
        input MemtoReg,
        input clk,
        input rst,
        input SignedExt,
        output [31:0] Addr_Jmp,
        output [31:0] Addr_Beq,
        output [31:0] Read_data_1,
        output [31:0] Read_data_2,
        output [31:0] SignedExt_imm,
        input [31:0] PC_plus_4,
        input [31:0] Alu_result,
        input [31:0] Mem_read_data,
        output [4:0] Shamt
    );
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [15:0] imme;
    wire [15:0] offset;
    wire [4:0] r1_num;
    wire [4:0] r2_num;
    wire [4:0] w1_num;
    wire [31:0] Reg_write_data;
    reg [31:0] register_file[31:0];
    assign rs = Instruction[25:21];
    assign rt = Instruction[20:16];
    assign rd = Instruction[15:11];
    assign Shamt = Instruction[10:6];
    assign Op_Code = Instruction[31:26];
    assign Function_Code = Instruction[5:0];
    assign imme = Instruction[15:0];
    assign offset = Instruction[25:0];
    assign r1_num = (!Syscall)? rs:5'd2;
    assign r2_num = (!Syscall)? rt:5'd4;
    assign Reg_write_data = (Jal)? PC_plus_4:
                            (MemtoReg)? Mem_read_data: Alu_result;
    assign w1_num = (Jal)? 5'h1f:
                    (RegDst)? rd:rt;
    assign Read_data_1=register_file[r1_num];
    assign Read_data_2=register_file[r2_num];
    assign Addr_Jmp = {6'd0,offset}<<2;
    assign SignedExt_imm = (SignedExt)? {{16{imme[15]}},imme}:{16'h0000,imme};
    assign Addr_Beq = (SignedExt_imm<<2) + PC_plus_4;
    integer i;
    always @(posedge clk or negedge rst)
    begin
        if (rst==1'b0)
        begin
            for(i=0;i<32;i=i+1) register_file[i] <= 32'd0;
        end
        else if (RegWrite==1'b1) begin
            for(i=1;i<32;i=i+1) 
                if (i==w1_num)
                    register_file[i]<=Reg_write_data;
                else
                    register_file[i]<=register_file[i];
        end
    end
endmodule
