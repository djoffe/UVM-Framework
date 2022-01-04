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
// (begin split source)
//
// Title: Ethernet 10G Sequences
//
// This file documents various Ethernet ~sequence~ classes.
//
//------------------------------------------------------------------------------
//
// CLASS: ethernet_mix_frame_sequence_finite
//
// This sequence is the basic sequence and generates the random Data and Control
// frames in a predefined ratio
//
// The percentage of data frames can be set as needed by the variable
// m_data_frame_percentage provided in the sequence. It uses
// ethernet_device_data_frame sequence item for Data frame and
// ethernet_device_control_frame for Control frame.
//------------------------------------------------------------------------------

class ethernet_mix_frame_sequence_finite extends mvc_sequence;

  // Group: Variables
  //
  // Variable: m_data_frame_percentage
  // Set this to percentage of data frames in randomly generated data and
  // control frame.
  int m_data_frame_percentage = 90;
  int num_frames = 25; // Default to 25 frames

  mvc_config_base m_config;
  `uvm_object_utils( ethernet_mix_frame_sequence_finite);

  extern function new( string name = "" );
  extern task body();
endclass

// Function- new

// Constructs a new ethernet_mix_frame_sequence_parameterized

function ethernet_mix_frame_sequence_finite::new( string name = "" );
    super.new(name);
endfunction

// (begin inline source)
// Task: body
// This task starts data or control frame child sequences at random.
task ethernet_mix_frame_sequence_finite::body();

  int random_var;
  int frame_number = 1;
  ethernet_device_data_frame               data_frame    = ethernet_device_data_frame::type_id::create("data_frame");
  ethernet_device_control_frame_constraint control_frame = ethernet_device_control_frame_constraint::type_id::create("control_frame");

  m_config = mvc_config_base::get_config(m_sequencer);

  m_config.wait_for_reset();
  m_config.wait_for_clock();

  repeat(num_frames)
  begin
    `uvm_info("SEQ", $sformatf("Frame Number %0d", frame_number), UVM_LOW)
    random_var = $urandom_range(100, 1);
    if(random_var < m_data_frame_percentage)
    begin
      start_item(data_frame);
      if ( !data_frame.randomize() with { data_frame.tx_error == 1'b0 ; data_frame.tx_error_on_cycle == 0 ; })
      `uvm_error("ASSRT","Assert statement failure");
      finish_item(data_frame);
    end
    else
    begin
      start_item(control_frame);
      if ( !control_frame.randomize() with { control_frame.tx_error == 1'b0 ; control_frame.is_reserved_opcode == 0; control_frame.tx_error_on_cycle == 0; })
      `uvm_error("ASSRT","Assert statement failure");
      finish_item(control_frame);
    end
    frame_number++;
  end
endtask
