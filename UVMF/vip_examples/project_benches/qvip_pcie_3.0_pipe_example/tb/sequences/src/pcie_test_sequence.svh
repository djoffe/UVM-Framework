//----------------------------------------------------------------------
//   Copyright 2013 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
/*****************************************************************************
 *
 * Copyright 2007-2013 Mentor Graphics Corporation
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 * PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT
 * TO LICENSE TERMS.
 *
 *****************************************************************************/

// Title: pcie_test_sequence

//
// Class : pcie_test_requester_sequence 
//
// This sequence is more of directed sequence where the usage of most common sequences
// (defined in pcie_tl_sequence) are shown. Refer pcie_tl_sequence for more common 
// sequences.
// Here the linkup is done 2.5GT/s.5 packets are transmitted from RC side in Gen1.
// Then a transition is done to Gen2(5GT/S).5 packets are transmitted from RC side in Gen2.
// Then a transition is done to Gen3(8GT/S).5 packets are transmitted from RC side in Gen3.
// Then a transition is done to Gen1(2.5GT/S).5 packets are transmitted from RC side in Gen1.
// Then a transition is done to Gen3(8GT/S).5 packets are transmitted from RC side in Gen3.
// Random TLP packets are transmitted from EP side.
//
class pcie_test_requester_sequence #(int LANES = 4,
                                     int PIPE_BYTES_MAX = 1,
                                     int CONFIG_NUM_OF_FUNCTIONS = 1) extends pcie_random_requester_sequence #(LANES,PIPE_BYTES_MAX,CONFIG_NUM_OF_FUNCTIONS);

  typedef pcie_test_requester_sequence         #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS) this_t;
  typedef pcie_vip_config                      #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS) pcie_vip_config_t;
  typedef pcie_tlp_read_cfg_space_sequence     #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS) pcie_cfg_read_sequence_t;
  typedef pcie_tlp_write_cfg_space_sequence    #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS) pcie_cfg_write_sequence_t;

  local pcie_vip_config_t                    m_pcie_cfg;
  local pcie_cfg_read_sequence_t             m_cfgrd_seq;
  local pcie_cfg_write_sequence_t            m_cfgwr_seq;
  local bit [15:0]                           m_rc_bdf;
  local bit [11:0]                           m_pcie_cap_offset_rc;

  // UVM Factory Registration 
  `uvm_object_param_utils(this_t);

  local bit                   okay;

  // 
  // Task: body
  //
  // This is standard UVM body task.
  // 
  extern task body();

  //
  // Task: initiate_gen1_transition
  //
  // This task will do the transition from Gen3/Gen2 to Gen1.
  // 
  extern task initiate_gen1_transition();

  //
  // Task: initiate_gen2_transition
  //
  // This task will do the transition from Gen1/Gen3 to Gen2.
  // 
  extern task initiate_gen2_transition();

  //
  // Task: initiate_gen3_transition
  //
  // This task will do the transition from Gen1/Gen2 to Gen3.
  // 
  extern task initiate_gen3_transition();

  //
  // Task: wait_for_ltssm_state
  //
  // This task will wait till the defined LTSSM state is not reached.
  // 
  extern task wait_for_ltssm_state(input device_type_e device_type,
                                   input pl_state_e    ltssm_state);
endclass :  pcie_test_requester_sequence

task pcie_test_requester_sequence::body();
  m_pcie_cfg           = pcie_vip_config_t::get_config(m_sequencer);
  device_type          = m_pcie_cfg.m_device_type;
  device_type_bit      = device_type == PCIE_RC || device_type == PCIE_SW_DS;

  while(m_pcie_cfg.m_bfm.get_g_current_dll_state_index1(device_type_bit) != PCIE_DL_ACTIVE)
  begin
      m_pcie_cfg.m_bfm.wait_for_g_current_dll_state_index1(device_type_bit);
  end
  // Perform Bus enumeration 
  if ( (device_type == PCIE_RC) || (device_type == PCIE_SW_DS) )
  begin
      initiate_random_transfer(5);
      initiate_gen2_transition();
      initiate_random_transfer(5);
      initiate_gen3_transition();
      initiate_random_transfer(5);
      initiate_gen1_transition();
      initiate_random_transfer(5);
      initiate_gen3_transition();
      initiate_random_transfer(5);
    end

endtask : body



task pcie_test_requester_sequence::initiate_gen1_transition();
bit [31:0]   reg_data;

begin
  m_cfgrd_seq   = pcie_cfg_read_sequence_t::type_id::create("m_cfgrd_seq");
  m_cfgwr_seq   = pcie_cfg_write_sequence_t::type_id::create("m_cfgwr_seq");

  while(m_pcie_cfg.m_bfm.get_g_current_dll_state_index1(0) != PCIE_DL_ACTIVE)
  begin
      m_pcie_cfg.m_bfm.wait_for_g_current_dll_state_index1(0);
  end
  repeat(500) m_pcie_cfg.wait_for_clock();

  if((device_type == PCIE_RC) || (device_type == PCIE_SW_DS))
    begin

      // Configuring the RC device for Gen3/Gne2 to Gen1 transition
      m_rc_bdf = m_pcie_cfg.bdf_map[0];
      m_pcie_cfg.get_capablity_base(m_pcie_cfg.m_device_type, m_rc_bdf[15:13], 8'h10, okay, m_pcie_cap_offset_rc);
      // Setting the Target Link Speed field in the Link Control 2 register
      m_cfgrd_seq.m_bdf    = m_rc_bdf;
      m_cfgrd_seq.m_offset = (m_pcie_cap_offset_rc + 12'h30);
      m_cfgrd_seq.start(m_sequencer, this);
      reg_data = m_cfgrd_seq.m_data;

      reg_data[3:0] = 4'b0001; // 5.0 GT/s
      m_cfgwr_seq.m_bdf    = m_rc_bdf;
      m_cfgwr_seq.m_offset = (m_pcie_cap_offset_rc + 12'h30);
      m_cfgwr_seq.m_data   = reg_data;
      m_cfgwr_seq.start(m_sequencer, this);

      //m_pcie_cfg.m_pcie_vip_plp_config.m_pl_direct_speed_change = 1'b1;
      m_pcie_cfg.m_bfm.set_config_directed_speed_change_index1(0,1'b1);

      // Setting the Retrain Link field in the Link Control Register
      m_cfgrd_seq.m_bdf    = m_rc_bdf;
      m_cfgrd_seq.m_offset = (m_pcie_cap_offset_rc + 12'h10);
      m_cfgrd_seq.start(m_sequencer, this);
      reg_data = m_cfgrd_seq.m_data;

      reg_data[5] = 1'b1;
      m_cfgwr_seq.m_bdf    = m_rc_bdf;
      m_cfgwr_seq.m_offset = (m_pcie_cap_offset_rc + 12'h10);
      m_cfgwr_seq.m_data   = reg_data;
      m_cfgwr_seq.start(m_sequencer, this);
    end

  repeat(200) m_pcie_cfg.wait_for_clock();
  wait_for_ltssm_state(PCIE_RC, PCIE_L0_STATE);
  m_pcie_cfg.m_bfm.set_config_directed_speed_change_index1(0,1'b0);
end
endtask


task pcie_test_requester_sequence::initiate_gen2_transition();
bit [31:0]   reg_data;

begin
  m_cfgrd_seq   = pcie_cfg_read_sequence_t::type_id::create("m_cfgrd_seq");
  m_cfgwr_seq   = pcie_cfg_write_sequence_t::type_id::create("m_cfgwr_seq");

  while(m_pcie_cfg.m_bfm.get_g_current_dll_state_index1(0) != PCIE_DL_ACTIVE)
  begin
      m_pcie_cfg.m_bfm.wait_for_g_current_dll_state_index1(0);
  end
  repeat(500) m_pcie_cfg.wait_for_clock();

  if((device_type == PCIE_RC) || (device_type == PCIE_SW_DS))
    begin

      // Configuring the RC device for Gen1 to Gen2 transition 
      m_rc_bdf = m_pcie_cfg.bdf_map[0];
      m_pcie_cfg.get_capablity_base(m_pcie_cfg.m_device_type, m_rc_bdf[15:13], 8'h10, okay, m_pcie_cap_offset_rc);
      // Setting the Target Link Speed field in the Link Control 2 register
      m_cfgrd_seq.m_bdf    = m_rc_bdf;
      m_cfgrd_seq.m_offset = (m_pcie_cap_offset_rc + 12'h30);
      m_cfgrd_seq.start(m_sequencer, this);
      reg_data = m_cfgrd_seq.m_data;

      reg_data[3:0] = 4'b0010; // 5.0 GT/s
      m_cfgwr_seq.m_bdf    = m_rc_bdf;
      m_cfgwr_seq.m_offset = (m_pcie_cap_offset_rc + 12'h30);
      m_cfgwr_seq.m_data   = reg_data;
      m_cfgwr_seq.start(m_sequencer, this);

      m_pcie_cfg.m_bfm.set_config_directed_speed_change_index1(0,1'b1);
      
      // Setting the Retrain Link field in the Link Control Register
      m_cfgrd_seq.m_bdf    = m_rc_bdf;
      m_cfgrd_seq.m_offset = (m_pcie_cap_offset_rc + 12'h10);
      m_cfgrd_seq.start(m_sequencer, this);
      reg_data = m_cfgrd_seq.m_data;

      reg_data[5] = 1'b1;
      m_cfgwr_seq.m_bdf    = m_rc_bdf;
      m_cfgwr_seq.m_offset = (m_pcie_cap_offset_rc + 12'h10);
      m_cfgwr_seq.m_data   = reg_data;
      m_cfgwr_seq.start(m_sequencer, this);
    end

  repeat(200) m_pcie_cfg.wait_for_clock();
  wait_for_ltssm_state(PCIE_RC, PCIE_L0_STATE);
  m_pcie_cfg.m_bfm.set_config_directed_speed_change_index1(0,1'b0);
end
endtask


task pcie_test_requester_sequence::initiate_gen3_transition();
bit [31:0]   reg_data;

begin
  m_cfgrd_seq   = pcie_cfg_read_sequence_t::type_id::create("m_cfgrd_seq");
  m_cfgwr_seq   = pcie_cfg_write_sequence_t::type_id::create("m_cfgwr_seq");

  while(m_pcie_cfg.m_bfm.get_g_current_dll_state_index1(0) != PCIE_DL_ACTIVE)
  begin
      m_pcie_cfg.m_bfm.wait_for_g_current_dll_state_index1(0);
  end
  repeat(500) m_pcie_cfg.wait_for_clock();

  if((device_type == PCIE_RC) || (device_type == PCIE_SW_DS))
    begin

      // Configuring the RC device for Gen2 to Gen3 transition 
      m_rc_bdf = m_pcie_cfg.bdf_map[0];
      m_pcie_cfg.get_capablity_base(m_pcie_cfg.m_device_type, m_rc_bdf[15:13], 8'h10, okay, m_pcie_cap_offset_rc);
      // Setting the Target Link Speed field in the Link Control 2 register
      m_cfgrd_seq.m_bdf    = m_rc_bdf;
      m_cfgrd_seq.m_offset = (m_pcie_cap_offset_rc + 12'h30);
      m_cfgrd_seq.start(m_sequencer, this);
      reg_data = m_cfgrd_seq.m_data;

      reg_data[3:0] = 4'b0011; // 8.0 GT/s
      m_cfgwr_seq.m_bdf    = m_rc_bdf;
      m_cfgwr_seq.m_offset = (m_pcie_cap_offset_rc + 12'h30);
      m_cfgwr_seq.m_data   = reg_data;
      m_cfgwr_seq.start(m_sequencer, this);

      m_pcie_cfg.m_bfm.set_config_directed_speed_change_index1(0,1'b1);

      // Setting the Retrain Link field in the Link Control Register
      m_cfgrd_seq.m_bdf    = m_rc_bdf;
      m_cfgrd_seq.m_offset = (m_pcie_cap_offset_rc + 12'h10);
      m_cfgrd_seq.start(m_sequencer, this);
      reg_data = m_cfgrd_seq.m_data;

      reg_data[5] = 1'b1;
      m_cfgwr_seq.m_bdf    = m_rc_bdf;
      m_cfgwr_seq.m_offset = (m_pcie_cap_offset_rc + 12'h10);
      m_cfgwr_seq.m_data   = reg_data;
      m_cfgwr_seq.start(m_sequencer, this);
    end

  repeat(200) m_pcie_cfg.wait_for_clock();
  wait_for_ltssm_state(PCIE_RC, PCIE_L0_STATE);
  m_pcie_cfg.m_bfm.set_config_directed_speed_change_index1(0,1'b0);
end
endtask


task pcie_test_requester_sequence::wait_for_ltssm_state(input device_type_e device_type,
                                                        input pl_state_e    ltssm_state);
bit okay;
pl_state_e main_ltssm_state;
pl_substate_e main_ltssm_substate;

begin
  do
    begin
      m_pcie_cfg.get_ltssm_status(device_type, okay, main_ltssm_state, main_ltssm_substate);
    end
  while(main_ltssm_state != ltssm_state);
end
endtask
