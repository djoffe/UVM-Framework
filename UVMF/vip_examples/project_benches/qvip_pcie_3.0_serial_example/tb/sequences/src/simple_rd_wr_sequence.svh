/*****************************************************************************
 *
 * Copyright 2013-2014 Mentor Graphics Corporation
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 * PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT
 * TO LICENSE TERMS.
 *
 *****************************************************************************/


//------------------------------------------------------------------------------
//
// Class: simple_rd_wr_sequence
//
//------------------------------------------------------------------------------
//
// This sequence executes an PCIe write transaction followed by a read 
// transaction with the same address, length, and TC.
//
// It uses <pcie_tlp_req_sequence>  transaction level sequence to generate stimulus.
// 
//------------------------------------------------------------------------------
class simple_rd_wr_sequence #(int LANES=4, int PIPE_BYTES_MAX=1, int CONFIG_NUM_OF_FUNCTIONS=1)  extends mvc_sequence;

  typedef pcie_tlp_mem_write_sequence #(LANES, 
                                        PIPE_BYTES_MAX, 
                                        CONFIG_NUM_OF_FUNCTIONS
                                       ) mem_wr_t;

  typedef pcie_tlp_mem_read_sequence #(LANES, 
                                        PIPE_BYTES_MAX, 
                                        CONFIG_NUM_OF_FUNCTIONS
                                       ) mem_rd_t;

  typedef pcie_device_end_facing_completion #(LANES, 
                                             PIPE_BYTES_MAX, 
                                             CONFIG_NUM_OF_FUNCTIONS
                                            ) cpld_rx_t;

  typedef pcie_vip_config #(LANES, 
                            PIPE_BYTES_MAX, 
                            CONFIG_NUM_OF_FUNCTIONS
                           ) cfg_t;
    
  `uvm_object_param_utils( simple_rd_wr_sequence #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS))

  cfg_t  cfg;

  function new (string name = "pcie_simple_rd_wr_sequence");
    super.new( name );
  endfunction
  
  extern task body();
endclass

// Task: body
//
// This is standard UVM body task.
//
// It executes the write followed by read transaction.
//
task simple_rd_wr_sequence::body();
  mem_wr_t wr_txn = mem_wr_t::type_id::create( "wr_txn",, get_full_name());
  mem_rd_t rd_txn = mem_rd_t::type_id::create( "rd_txn",, get_full_name());

  // Get the config object so that you can wait for a clock after reset
  // to issue the first sequence_item.
  cfg = cfg_t::get_config(m_sequencer);

  wr_txn.m_td       = 0;
  wr_txn.m_length   = 10'd3;
  wr_txn.m_fdwe     = 4'hf;
  wr_txn.m_ldwe     = 4'hf;
  wr_txn.m_address  = cfg.get_address_range_32_mem(0, wr_txn.m_length);
  wr_txn.start(m_sequencer, this);
  rd_txn.m_td       = 0;
  rd_txn.m_length   = 10'd3;
  rd_txn.m_fdwe     = 4'hf;
  rd_txn.m_ldwe     = 4'hf;
  rd_txn.m_address = wr_txn.m_address;
  rd_txn.start(m_sequencer, this);
endtask
