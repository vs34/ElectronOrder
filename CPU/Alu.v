module Alu (
    input wire [4:0] rd,            // Destination register
    input wire [2:0] funct3,        // funct3 field
    input wire [4:0] rs1,           // Source register 1
    input wire [4:0] rs2,           // Source register 2
    input wire [6:0] funct7,        // funct7 field
    input wire [31:0] imm           // Immediate value
);
    always @(*) begin
        case (funct7)
            0110011'b7: begin // type R
            case (funct3)
               000'b3: begin // type R
                   
               end

               001'b0: begin // type 

                end

               010'b0: begin // type 

               end

               011'b0: begin // type 

               end

               100'b0: begin // type     

               end

               101'b0: begin // type 

               end

               110'b0: begin // type 

               end

               111'b0: begin // type 

               end
            endcase
        end

        0010011'b7: begin // I-type (Immediate ALU operations)
                
        case (funct7)
            0110011'b7: begin // type R
            case (funct3)
               000'b3: begin // type R
                   
               end

               001'b0: begin // type 

                end

               010'b0: begin // type 

               end

               011'b0: begin // type 

               end

               100'b0: begin // type     

               end

               101'b0: begin // type 

               end

               110'b0: begin // type 

               end

               111'b0: begin // type 

               end
            endcase
        end
        endcase
        

    end
  

endmodule
