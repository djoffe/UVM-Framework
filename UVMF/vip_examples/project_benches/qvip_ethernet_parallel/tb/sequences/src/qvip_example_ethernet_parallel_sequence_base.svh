//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : vgill
// Creation Date   : 2015 Oct 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : qvip_ethernet_parallel Simulation Bench 
// Unit            : Bench Sequence Base
// File            : qvip_example_ethernet_parallel_sequence_base.svh
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

class qvip_example_ethernet_parallel_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( qvip_example_ethernet_parallel_sequence_base );

  // Instantiate sequences here
  //ethernet_mix_frame_sequence eth_mix_frame_seq;
  ethernet_mix_frame_sequence_finite eth_mix_frame_seq;

  // Sequencer handles for each active interface in the environment
  // Configuration handles to access interface BFM's
  mvc_sequencer ethernet_qvip_seqr;
  ethernet_vip_config ethernet_qvip_config;

// ****************************************************************************
  function new( string name = "" );
     super.new( name );

  // Retrieve the sequencer handles from the uvm_config_db
  if( !uvm_config_db #( mvc_sequencer )::get( null, UVMF_SEQUENCERS, qvip_ethernet_BFM, ethernet_qvip_seqr ) )
    `uvm_error("CFG" , "uvm_config_db #( mvc_sequencer )::get cannot find resource ethernet_qvip_seqr" )

  // Retrieve the configuration handles from the uvm_config_db
  endfunction



// ****************************************************************************
  task timeout();
    # 50us;
  endtask

// ****************************************************************************
  virtual task body();

  // Construct sequences here
  eth_mix_frame_seq = ethernet_mix_frame_sequence_finite::type_id::create("eth_mix_frame_seq");
  eth_mix_frame_seq.num_frames = 500; // Set the number of frames to generate

  // Start sequences here
  `uvm_info("SEQ", "Starting the Ethernet Mixed Frame Sequence", UVM_LOW)
  fork
    eth_mix_frame_seq.start(ethernet_qvip_seqr);
    timeout();
  join_any

   // Delay to allow for design latency

  endtask

endclass

