//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : dbole
// Creation Date   : 2015 Oct 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : qvip_example_ethernet_serial Simulation Bench 
// Unit            : Bench Sequence Base
// File            : qvip_example_ethernet_serial_sequence_base.svh
//----------------------------------------------------------------------
//
// Description: This file contains the top level and utility sequences
//     used by test_top. It can be extended to create derivative top
//     level sequences.
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

class qvip_example_ethernet_serial_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( qvip_example_ethernet_serial_sequence_base );

  // Instantiate sequences here
  ethernet_mix_frame_sequence_finite ethernet_mix_frame_sequence_finite_t;

  // Sequencer handles for each active interface in the environment
  // Configuration handles to access interface BFM's
  mvc_sequencer ethernet_qvip_seqr;
  ethernet_vip_config ethernet_qvip_config;
// ****************************************************************************
  function new( string name = "" );
     super.new( name );

  // Retrieve the sequencer handles from the uvm_config_db
 if( !uvm_config_db #( mvc_sequencer )::get( null, UVMF_SEQUENCERS, ETH_10G_IF, ethernet_qvip_seqr ) )
    `uvm_error("CFG" , "uvm_config_db #( mvc_sequencer )::get cannot find resource ethernet_qvip_seqr" )


  // Retrieve the configuration handles from the uvm_config_db

  endfunction


// ****************************************************************************
  task timeout();
    # 100us;
  endtask

// ****************************************************************************
  virtual task body();

    ethernet_mix_frame_sequence_finite_t = ethernet_mix_frame_sequence_finite::type_id::create("ethernet_mix_frame_sequence_finite_t");


  // Start sequences here
  `uvm_info("SEQ", "Starting the Ethernet Mixed Frame Sequence", UVM_LOW)
  fork
    ethernet_mix_frame_sequence_finite_t.start(ethernet_qvip_seqr);
    timeout();
  join_any
   // Delay to allow for design latency

  endtask

endclass

