//
// File: default_reset_gen.sv
//
// Generated from Mentor VIP Configurator (20230807)
// Generated using Mentor VIP Library ( 2023.3_1 : 08/18/2023:20:00 )
//
module default_reset_gen
(
    output reg  RESET,
    input  reg  CLK_IN
);
    
    initial
    begin
        RESET = 1;
        
        RESET = ~RESET;
        
        repeat ( 2 )
        begin
            @(posedge CLK_IN);
        end
        
        RESET = ~RESET;
    end
    

endmodule: default_reset_gen
