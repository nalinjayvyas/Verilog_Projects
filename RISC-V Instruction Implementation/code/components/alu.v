
// alu.v - ALU module

module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,       // operands
    input       [2:0] alu_ctrl,         // ALU control
    input            funct7b5,          // Funct 7 Bit 5
    input  [2:0]      funct3,            // funct3
    output reg  [WIDTH-1:0] alu_out,    // ALU output
    output      zero                    // zero flag
    
);

always @(a, b, alu_ctrl) begin
    case (alu_ctrl)
        3'b000:  alu_out <= a + b;       // ADD
        3'b001:  alu_out <= a + ~b + 1;  // SUB
        3'b010:  alu_out <= a & b;       // AND
        3'b011:  alu_out <= a | b;       // OR
        3'b100:  begin 
                    if (funct3 == 3'b100) alu_out <= a ^ b;       // XOR
                    else alu_out <= $unsigned(a) < $unsigned(b) ?  1 : 0; // sltu         
                end     
        3'b101:  begin                   // SLT
                    
                    alu_out <= $signed(a) < $signed(b) ? 1 : 0; // slti
                    // 3'b010: alu_out <= $unsigned(a) < $unsigned(b) ?  1 : 0; // sltu
                   
                    //  if (funct3 == 3'b010) alu_out <= $signed(a) < $signed(b) ? 0 : 1; // SLT/ SLTI
                    //  else if (funct3 == 3'b011) alu_out <= $unsigned(a) < $unsigned(b) ?  0 : 1; // SLTU/ SLTIU
                 end
        3'b110:  alu_out <= a << b[4:0]; // SLL
        3'b111:  begin 
            if (funct7b5 == 0) alu_out <= a >> b[4:0]; // SRL  
            else alu_out <= $signed(a) >>> b[4:0];  // SRA 
        end           
        default: alu_out = 0;
    endcase
end

assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

endmodule

