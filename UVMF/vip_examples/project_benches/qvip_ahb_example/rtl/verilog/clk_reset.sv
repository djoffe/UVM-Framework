/*****************************************************************************
 *
 * Copyright 2007-2015 Mentor Graphics Corporation
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 * PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT
 * TO LICENSE TERMS.
 *
 *****************************************************************************/

// Module:- clk_reset
//
// This is the clk_reset module, generating the clock and reset logic.

module clk_reset (output bit clk, reset);

  reg iclk, irst;
  
  assign clk = iclk;
  assign reset = irst;
  
  initial
  begin
    iclk = 0;
	  forever #5 iclk = ~iclk;
  end
  
  initial
  begin
    irst = 0;
	  #37 irst = 1;
  end
  
endmodule
