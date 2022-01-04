//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu Simulation Bench 
// Unit            : Bench Sequence Base
// File            : alu_bench_sequence_base.svh
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

class alu_bench_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( alu_bench_sequence_base );

  // UVMF_CHANGE_ME : Instantiate, construct, and start sequences as needed to create stimulus scenarios.

  // Instantiate sequences here
typedef alu_in_random_sequence  alu_in_agent_random_seq_t;
alu_in_agent_random_seq_t alu_in_agent_random_seq;
typedef alu_out_random_sequence  alu_out_agent_random_seq_t;
alu_out_agent_random_seq_t alu_out_agent_random_seq;

  // Sequencer handles for each active interface in the environment
typedef alu_in_transaction  alu_in_agent_transaction_t;
uvm_sequencer #(alu_in_agent_transaction_t)  alu_in_agent_sequencer; 

// Sequencer handles for each QVIP interface

// Configuration handles to access interface BFM's
alu_in_configuration   alu_in_agent_config;
alu_out_configuration   alu_out_agent_config;




// ****************************************************************************
  function new( string name = "" );
     super.new( name );

  // Retrieve the configuration handles from the uvm_config_db
if( !uvm_config_db #( alu_in_configuration )::get( null , UVMF_CONFIGURATIONS , alu_in_pkg_alu_in_agent_BFM , alu_in_agent_config ) ) 
`uvm_error("Config Error" , "uvm_config_db #( alu_in_configuration )::get cannot find resource alu_in_pkg_alu_in_agent_BFM" )
if( !uvm_config_db #( alu_out_configuration )::get( null , UVMF_CONFIGURATIONS , alu_out_pkg_alu_out_agent_BFM , alu_out_agent_config ) ) 
`uvm_error("Config Error" , "uvm_config_db #( alu_out_configuration )::get cannot find resource alu_out_pkg_alu_out_agent_BFM" )

  // Retrieve the sequencer handles from the uvm_config_db
if( !uvm_config_db #( uvm_sequencer #(alu_in_agent_transaction_t) )::get( null , UVMF_SEQUENCERS , alu_in_pkg_alu_in_agent_BFM , alu_in_agent_sequencer ) ) 
`uvm_error("Config Error" , "uvm_config_db #( uvm_sequencer #(alu_in_transaction) )::get cannot find resource alu_in_pkg_alu_in_agent_BFM" ) 

  // Retrieve QVIP sequencer handles from the uvm_config_db



  endfunction


// ****************************************************************************
  virtual task body();

  // Construct sequences here
   alu_in_agent_random_seq     = alu_in_agent_random_seq_t::type_id::create("alu_in_agent_random_seq");
 
  // Delay start of sequences til lreset has ended and then wait a few clocks after that 
   alu_in_agent_config.wait_for_reset();
   alu_in_agent_config.wait_for_num_clocks(10);

  // Start INITIATOR sequences here
   fork
       repeat (25) alu_in_agent_random_seq.start(alu_in_agent_sequencer);
   join

   // UVMF_CHANGE_ME : Extend the simulation XXX number of clocks after 
   // the last sequence to allow for the last sequence item to flow 
   // through the design.

  fork
    alu_in_agent_config.wait_for_num_clocks(400);
    alu_out_agent_config.wait_for_num_clocks(400);
  join

  endtask

endclass

