/*****************************************************************************
 *
 * Copyright 2007-2015 Mentor Graphics Corporation
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
 * MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
 *
 *****************************************************************************/

// CLASS: usb_ss_host_burst_test_sequence_local
//
// usb_ss_host_burst_test_sequence_local derives from usb_ss_host_sequence #(DATA_BUS_WIDTH) and sends
// basic USB_SS Control read and write commands, such as SET_FEATURE, etc.
//
// It also sends Burst transfers to all types of active endpoints in the device.
class usb_ss_host_burst_test_sequence_local #(int DATA_BUS_WIDTH = 32) extends usb_ss_host_sequence #(DATA_BUS_WIDTH);

  typedef usb_ss_low_power_request_sequence #(DATA_BUS_WIDTH) low_pwr_seq_t;
  `ifdef MGC_ALL_ENDP_SB_USB3
  typedef usb_ss_sb_mem                     #(DATA_BUS_WIDTH) sb_memory_t;
  `endif

   typedef bit [7:0] byte_t;

   byte_t address = 8'd5;
   `ifdef MGC_ALL_ENDP_SB_USB3
  sb_memory_t sb_mem;
  `endif
  
  `uvm_object_param_utils(usb_ss_host_burst_test_sequence_local #(DATA_BUS_WIDTH));

  extern task body();
  extern function new(string name="");
endclass : usb_ss_host_burst_test_sequence_local

// This is a standard UVM new function.
function usb_ss_host_burst_test_sequence_local :: new (string name = "");
  super.new(name);
endfunction : new

// This task runs the basic Control read and write commands, such as SET_FEATURE,
// etc. It also runs burst transfers to all type of active endpoints in the
// device.
task usb_ss_host_burst_test_sequence_local :: body();

  low_pwr_seq_t         low_pwr_seq     = low_pwr_seq_t::type_id::create("low_pwr_seq");

  byte_t  setup_data_packet[];
  byte_t  data[] , exp_data[];
  int exp_num_bytes;
  bit success;
  bit inject_error;
  `ifdef MGC_ALL_ENDP_SB_USB3
  sb_mem = sb_memory_t::get_config(m_sequencer);
  `endif

  super.body();
  configure_device(address, route_string);

  repeat (4000) cfg.wait_for_clock();

endtask : body

