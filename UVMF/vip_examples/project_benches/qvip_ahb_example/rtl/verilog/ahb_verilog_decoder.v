// *****************************************************************************
//
// Copyright 2007-2015 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************

module ahb_verilog_decoder(
                                  HRESETn,
                                  HADDR,
                                  HREADY,
                                  HSEL
                          );

parameter S0_START_ADDRESS = 0;
parameter S0_END_ADDRESS   = 1023;

parameter S1_START_ADDRESS = 1024;
parameter S1_END_ADDRESS   = 2047;

parameter S2_START_ADDRESS = 2048;
parameter S2_END_ADDRESS   = 3071;

parameter S3_START_ADDRESS = 3072;
parameter S3_END_ADDRESS   = 4095;

parameter AHB_NUM_SLAVES      = 4;
parameter ADDRESSWIDTH        = 32;


input    HRESETn;
input    [(ADDRESSWIDTH-1):0] HADDR;
input    HREADY;

// output   [AHB_NUM_SLAVES-1:0] HSEL;
output   HSEL[AHB_NUM_SLAVES];

reg      slave_hsel[AHB_NUM_SLAVES-1:0];

integer index,i,i1; 
  generate
    genvar slave_id;
    for( slave_id = 0; slave_id < AHB_NUM_SLAVES; slave_id = slave_id + 1)
    begin
      assign HSEL[slave_id] = slave_hsel[slave_id];
    end
  endgenerate

  initial
    for(i=0; i<AHB_NUM_SLAVES;i=i+1) // initialize slave_hsel
      slave_hsel[i] = 'b0;

  always @(HADDR or HREADY or HRESETn)
  begin
    if ((HREADY == 1'b1) || (HRESETn == 1'b1))
    begin
      if ((HADDR >= S0_START_ADDRESS) && (HADDR <= S0_END_ADDRESS))
         index =0;
      else if ((HADDR >= S1_START_ADDRESS) && (HADDR <= S1_END_ADDRESS))
         index = 1;
      else if ((HADDR >= S2_START_ADDRESS) && (HADDR <= S2_END_ADDRESS))
         index = 2;
      else if ((HADDR >= S3_START_ADDRESS) && (HADDR <= S3_END_ADDRESS))
         index = 3;
     for(i1=0; i1<AHB_NUM_SLAVES;i1=i1+1) // initialize slave_hsel
        if(i1 == index) 
          slave_hsel[i1] <= 1'b1;
        else
          slave_hsel[i1] <= 1'b0;
    end
  end

endmodule
