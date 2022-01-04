/*****************************************************************************
 *
 * Copyright 2007-2015 Mentor Graphics Corporation
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
 * MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
 *
 *****************************************************************************/

// CLASS: protocol_random_seq
//
// The following scenarios are covered in this sequence:
//
// - Control transfer for all types of requests with all types of recipient.
// Requests are generated randomly with constraints imposed over randomization.
//
// - Data transfers for Isochronous/Bulk/Interrupt of IN/OUT endpoints.
//
// - Device entering into ~Flow Control~ condition.
//
// - Error injections in Data Packet in format of crc32 error and mismatch dpp
// length.
//
// - ISPSM and OSPSM transitions are covered. Both hosts initiated and device
// initiated streaming are generated.
//
// - STALL, NRDY, and ACK as device response to DP/TP received from host.
//
// - Device endpoints halted.
//
// - ACK TPs with retry bit set are generated from both device/host.
//
// Error injections, device entering flow control conditions, etc. are
// generated randomly.
class protocol_random_seq #(int DATA_BUS_WIDTH = 32) extends usb_ss_host_sequence #(DATA_BUS_WIDTH);

  typedef master_setup_stage_constraint #(DATA_BUS_WIDTH)   setup_stage_reqc_t;
  typedef usb_ss_host_ping_sequence #(DATA_BUS_WIDTH)       ping_seq_t;

  typedef bit[4:0]                        endp_t;

  `uvm_object_param_utils(protocol_random_seq #(DATA_BUS_WIDTH));

// Instance of the derived stage constraints
  setup_stage_reqc_t setup_stage_req;

  bit success;
  bit flow_cntrl_mgmt_running[endp_t];
  bit prev_not_complete[32];
  int next_expected_data[32];

  // Below bits are added to control the randomization
  bit[1:0] control_random_gen1;
  bit[1:0] control_random_gen2;
  bit[1:0] control_random_gen3;
  bit[1:0] control_random_gen4;
  bit[1:0] control_random_gen5;
  bit[1:0] control_random_gen6;
  bit[1:0] control_random_gen7;
  bit[1:0] control_random_gen8;
  bit[1:0] control_random_gen9;
  bit[1:0] control_random_gen10;
  bit[1:0] control_random_gen11;
  bit[1:0] control_random_gen12;
  bit[1:0] control_random_gen13;
  bit[1:0] control_random_gen14;
  bit      not_first_ping_in;
  bit      not_first_ping_out;
  int      count_1;
  int      count_2;
  int      count_3;
  int      count_4;
  int      count_5;
  int      count_6;
  int      count_7;
  int      count_8;
  int      count_9;
  int      count_10;
  int      count_11;
  int      count_12;
  int      count_13;
  int      count_14;
  int      count_15;
  int      count_16;
  int      count_17;
  int      count_18;
  int      count_19;
  int      count_20;
  int      count_21;

  extern function new (string name ="");
  extern function void update_error_injections ( input bit [4:0] endp_addr );
  extern task body ();
  extern task set_stall (input bit [3:0] endp_addr, input bit dir);
  extern task perform_streaming ( input bit [4:0]  endp_addr,
                                  input bit [15:0] stream_id = 0
                                );
  extern task wait_for_device_initiated_streaming (input bit[4:0] endp_addr,
                                                   input bit [15:0] tmp_id );
  extern task perform_control_transfer( input setup_stage_reqc_t  control_req);
  extern task perform_burst_transfer ( input bit[4:0] endp_addr,
                                       input bit      iso_xfr
                                     );
  extern task update_wValue ( input  setup_stage_reqc_t control_req,
                              output bit[7:0]           _data[2]
                            );
  extern task update_wIndex ( input  setup_stage_reqc_t control_req,
                              output bit[7:0]           _data[2]
                            );
endclass : protocol_random_seq

// This is a standard UVM new function.
function protocol_random_seq :: new (string name = "");
  super.new(name);
endfunction : new

// Random scenarios are generated.
task protocol_random_seq :: body();

  int                  endp_size;
  bit [4:0]            current_endp;
  usb_endpoint_type_e  ep_type;

  bit u2_enable_set_req_done   = 1'b0;
  bit u2_enable_clear_req_done = 1'b0;

  //These variables are use to ensure one time occurrence of bulk IN/OUT streaming/non-streaming
  bit bulk_in_non_stream_endpoint_used  = 1'b0;
  bit bulk_in_streaming_endpoint_used   = 1'b0;
  bit bulk_out_non_stream_endpoint_used = 1'b0;
  bit bulk_out_streaming_endpoint_used  = 1'b0;
  int bulk_in_non_stream_count  = 0;
  int bulk_in_stream_count      = 0;
  int bulk_out_non_stream_count = 0;
  int bulk_out_stream_count     = 0;
  int count = 0;
  bit interrupt_in_endpoint_used  = 1'b0;
  bit interrupt_out_endpoint_used = 1'b0;
  int interrupt_in_count  = 0;
  int interrupt_out_count = 0;
  int interrupt_count = 0;
  bit isoch_in_endpoint_used  = 1'b0;
  bit isoch_out_endpoint_used = 1'b0;
  int isoch_in_count  = 0;
  int isoch_out_count = 0;
  int isoch_count = 0;
  bit non_interrupt_in  = 1'b0;
  bit non_interrupt_out = 1'b0;
  bit non_isoch_in  = 1'b0;
  bit non_isoch_out = 1'b0;

  setup_stage_req                 = new();

  super.body();

  device_cfg.m_flow_control_delay = 10000;

  for (int i=0; i<32; ++i)
  begin
    prev_not_complete[i] = 1'b0;
    next_expected_data[i] = 0;
  end

  configure_device (8'hB);

  for (int i=0;i<400;i++)
  begin
    
    if((i[3:0] == 0) || (i[3:0] == 1) || (i[3:0] == 2) || (i[3:0] == 6) || (i[3:0] == 7) || (i[3:0] == 10) || (i[3:0] == 11) || (i[3:0] == 13) || (i[3:0] == 15) || (i[3:0] == 14))
    begin
      ep_type = USB_BULK;
    end 
    if((i[3:0] == 3) || (i[3:0] == 4) || (i[3:0] == 8) || (i[3:0] == 9))
    begin
      ep_type = USB_INTERRUPT;
    end
    if((i[3:0] == 5) || (i[3:0] == 12))
    begin
      ep_type = USB_ISOCHRONOUS;
    end
    
    `uvm_info("SEQ", {$psprintf(" Running Scenarion No. %4d for endpoint %s. \n",i, ep_type.name())}, UVM_LOW);

    repeat (40) cfg.wait_for_clock();

    case (ep_type)
      USB_BULK :
        begin
          endp_size    = cfg.host_db.active_bulk_endpoints[route_string].active_endpoints.size();
          while((bulk_in_non_stream_endpoint_used == 1'b0) && (bulk_in_non_stream_count < endp_size) && (count == 0))
          begin
            if((cfg.host_db.active_bulk_endpoints[route_string].active_endpoints[bulk_in_non_stream_count][4] == 1'b1) && (cfg.host_db.endp_prop[route_string].max_stream_size[cfg.host_db.active_bulk_endpoints[route_string].active_endpoints[bulk_in_non_stream_count]] == 0)) // IN bulk endpoint and non-streaming
            begin
              current_endp                     = cfg.host_db.active_bulk_endpoints[route_string].active_endpoints[bulk_in_non_stream_count];
              bulk_in_non_stream_endpoint_used = 1'b1;
              perform_burst_transfer ( .endp_addr   (current_endp),
                                       .iso_xfr     (1'b0)
                                     );
            end
            else
            begin
              bulk_in_non_stream_count++;
            end 
          end
          while((bulk_in_streaming_endpoint_used == 1'b0) && (bulk_in_stream_count < endp_size) && (count == 1))
          begin
            if((cfg.host_db.active_bulk_endpoints[route_string].active_endpoints[bulk_in_stream_count][4] == 1'b1) && (cfg.host_db.endp_prop[route_string].max_stream_size[cfg.host_db.active_bulk_endpoints[route_string].active_endpoints[bulk_in_stream_count]] != 0)) // IN bulk endpoint and streaming
            begin
              current_endp                    = cfg.host_db.active_bulk_endpoints[route_string].active_endpoints[bulk_in_stream_count];
              bulk_in_streaming_endpoint_used = 1'b1;
              perform_streaming (current_endp,);
            end
            else
            begin
              bulk_in_stream_count++;
            end 
          end
          while((bulk_out_non_stream_endpoint_used == 1'b0) && (bulk_out_non_stream_count < endp_size) && (count == 2))
          begin
            if((cfg.host_db.active_bulk_endpoints[route_string].active_endpoints[bulk_out_non_stream_count][4] == 1'b0) && (cfg.host_db.endp_prop[route_string].max_stream_size[cfg.host_db.active_bulk_endpoints[route_string].active_endpoints[bulk_out_non_stream_count]] == 0)) // OUT bulk endpoint and non-streaming
            begin
              current_endp                      = cfg.host_db.active_bulk_endpoints[route_string].active_endpoints[bulk_out_non_stream_count];
              bulk_out_non_stream_endpoint_used = 1'b1;
              perform_burst_transfer ( .endp_addr   (current_endp),
                                       .iso_xfr     (1'b0)
                                     );
            end
            else
            begin
              bulk_out_non_stream_count++;
            end 
          end
          while((bulk_out_streaming_endpoint_used == 1'b0) && (bulk_out_stream_count < endp_size) && (count == 3))
          begin
            if((cfg.host_db.active_bulk_endpoints[route_string].active_endpoints[bulk_out_stream_count][4] == 1'b0) && (cfg.host_db.endp_prop[route_string].max_stream_size[cfg.host_db.active_bulk_endpoints[route_string].active_endpoints[bulk_out_stream_count]] != 0)) // OUT bulk endpoint and streaming
            begin
              current_endp                    = cfg.host_db.active_bulk_endpoints[route_string].active_endpoints[bulk_out_stream_count];
              bulk_out_streaming_endpoint_used = 1'b1;
              perform_streaming (current_endp,);
            end
            else
            begin
              bulk_out_stream_count++;
            end 
          end
          //--------------------
          if((bulk_out_non_stream_endpoint_used == 1'b1) && (bulk_out_streaming_endpoint_used == 1'b1) && (bulk_out_non_stream_endpoint_used == 1'b1) && (bulk_out_streaming_endpoint_used == 1'b1))
          begin
             current_endp = cfg.host_db.active_bulk_endpoints[route_string].active_endpoints[($urandom_range((endp_size - 1),0))];

             if (cfg.host_db.endp_prop[route_string].max_stream_size[current_endp] == 0)
             begin
               perform_burst_transfer ( .endp_addr   (current_endp),
                                        .iso_xfr     (1'b0)
                                      );
             end
             else // Streaming
             begin
               perform_streaming (current_endp,);
             end
          end
          count++;
        end
      USB_INTERRUPT :
        begin
          endp_size    = cfg.host_db.active_interrupt_endpoints[route_string].active_endpoints.size();
          while((interrupt_in_endpoint_used == 1'b0) && (interrupt_in_count < endp_size) && (interrupt_count == 0))
          begin
            if((cfg.host_db.active_interrupt_endpoints[route_string].active_endpoints[interrupt_in_count][4] == 1'b1)) // IN Interrupt endpoint
            begin
              current_endp                     = cfg.host_db.active_interrupt_endpoints[route_string].active_endpoints[interrupt_in_count];
              interrupt_in_endpoint_used = 1'b1;
              perform_burst_transfer ( .endp_addr   (current_endp),
                                       .iso_xfr     (1'b0)
                                     );
            end
            interrupt_in_count++;
            if((interrupt_in_count == endp_size) && (interrupt_in_endpoint_used == 1'b0))
            begin
              interrupt_count = 1;
              non_interrupt_in = 1'b1;
            end
          end
          while((interrupt_out_endpoint_used == 1'b0) && (interrupt_out_count < endp_size) && (interrupt_count == 1))
          begin
            if((cfg.host_db.active_interrupt_endpoints[route_string].active_endpoints[interrupt_out_count][4] == 1'b0)) // OUT Interrupt endpoint
            begin
              current_endp                    = cfg.host_db.active_interrupt_endpoints[route_string].active_endpoints[interrupt_out_count];
              interrupt_out_endpoint_used = 1'b1;
              perform_burst_transfer ( .endp_addr   (current_endp),
                                       .iso_xfr     (1'b0)
                                     );
            end
            interrupt_out_count++;
            if((interrupt_out_count == endp_size) && (interrupt_out_endpoint_used == 1'b0))
            begin
              non_interrupt_out = 1'b1;
            end
          end

          if(((non_interrupt_in == 1'b1) && (non_interrupt_out == 1'b0) && (interrupt_out_endpoint_used == 1'b1)) || ((non_interrupt_in == 1'b0) && (non_interrupt_out == 1'b1) && (interrupt_in_endpoint_used == 1'b1)) || ((non_interrupt_in == 1'b0) && (non_interrupt_out == 1'b0) && (interrupt_in_endpoint_used == 1'b1) && (interrupt_out_endpoint_used == 1'b1)) || ((non_interrupt_in == 1'b1) && (non_interrupt_out == 1'b1)))
          begin
            current_endp = cfg.host_db.active_interrupt_endpoints[route_string].active_endpoints[($urandom_range((endp_size - 1),0))];
            perform_burst_transfer ( .endp_addr   (current_endp),
                                     .iso_xfr     (1'b0)
                                   );
          end
          interrupt_count++;
        end
      USB_ISOCHRONOUS :
        begin
          endp_size    = cfg.host_db.active_isochronous_endpoints[route_string].active_endpoints.size();
          while((isoch_in_endpoint_used == 1'b0) && (isoch_in_count < endp_size) && (isoch_count == 0))
          begin
            if((cfg.host_db.active_isochronous_endpoints[route_string].active_endpoints[isoch_in_count][4] == 1'b1)) // IN Isochronous endpoint
            begin
              current_endp                     = cfg.host_db.active_isochronous_endpoints[route_string].active_endpoints[isoch_in_count];
              isoch_in_endpoint_used = 1'b1;
              perform_burst_transfer ( .endp_addr   (current_endp),
                                       .iso_xfr     (1'b1)
                                     );
            end
            isoch_in_count++;
            if((isoch_in_count == endp_size) && (isoch_in_endpoint_used == 1'b0))
            begin
              isoch_count = 1;
              non_isoch_in = 1'b1;
            end
          end
          while((isoch_out_endpoint_used == 1'b0) && (isoch_out_count < endp_size) && (isoch_count == 1))
          begin
            if((cfg.host_db.active_isochronous_endpoints[route_string].active_endpoints[isoch_out_count][4] == 1'b0)) // OUT Isochronous endpoint
            begin
              current_endp                    = cfg.host_db.active_isochronous_endpoints[route_string].active_endpoints[isoch_out_count];
              isoch_out_endpoint_used = 1'b1;
              perform_burst_transfer ( .endp_addr   (current_endp),
                                       .iso_xfr     (1'b1)
                                     );
            end
            isoch_out_count++;
            if((isoch_out_count == endp_size) && (isoch_out_endpoint_used == 1'b0))
            begin
              non_isoch_out = 1'b1;
            end
          end

          //-----------------------------------
          if(((non_isoch_in == 1'b1) && (non_isoch_out == 1'b0) && (isoch_out_endpoint_used == 1'b1)) || ((non_isoch_in == 1'b0) && (non_isoch_out == 1'b1) && (isoch_in_endpoint_used == 1'b1)) || ((non_isoch_in == 1'b0) && (non_isoch_out == 1'b0) && (isoch_in_endpoint_used == 1'b1) && (isoch_out_endpoint_used == 1'b1)) || ((non_isoch_in == 1'b1) && (non_isoch_out == 1'b1)))
          begin
            current_endp = cfg.host_db.active_isochronous_endpoints[route_string].active_endpoints[($urandom_range((endp_size - 1),0))];

            perform_burst_transfer ( .endp_addr   (current_endp),
                                     .iso_xfr     (1'b1)
                                   );
          end
          isoch_count++;
        end
    endcase
  end
  
  ep_type = USB_CONTROL;

  for(int j=0;j<150;j++)
  begin
    repeat (40) cfg.wait_for_clock();
    case (j[4:0])
      0 :
      begin
            setup_stage_req.transfer_type      = USB_STANDARD;
            setup_stage_req.bRequest           = USB_GET_STATUS;
            setup_stage_req.transfer_recipient = USB_RECIP_DEVICE;
            setup_stage_req.transfer_direction = USB_DEVICE_TO_HOST;
            setup_stage_req.wLength            = 2;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
      1 :
      begin
            setup_stage_req.transfer_type      = USB_STANDARD;
            setup_stage_req.bRequest           = USB_GET_STATUS;
            setup_stage_req.transfer_recipient = USB_RECIP_ENDPOINT;
            setup_stage_req.transfer_direction = USB_DEVICE_TO_HOST;
            setup_stage_req.wLength            = 2;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
      2 :
      begin
            setup_stage_req.transfer_type      = USB_STANDARD;
            setup_stage_req.bRequest           = USB_GET_STATUS;
            setup_stage_req.transfer_recipient = USB_RECIP_INTERFACE;
            setup_stage_req.transfer_direction = USB_DEVICE_TO_HOST;
            setup_stage_req.wLength            = 2;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
      3 :
      begin
            setup_stage_req.transfer_type      = USB_STANDARD;
            setup_stage_req.bRequest           = USB_SET_FEATURE;
            setup_stage_req.feature_selector   = USB_SS_U2_ENABLE;
            setup_stage_req.transfer_recipient = USB_RECIP_DEVICE;
            setup_stage_req.transfer_direction = USB_HOST_TO_DEVICE;
            setup_stage_req.wLength            = 0;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
      4 :
      begin
            setup_stage_req.transfer_type      = USB_STANDARD;
            setup_stage_req.bRequest           = USB_CLEAR_FEATURE;
            setup_stage_req.feature_selector   = USB_SS_U2_ENABLE;
            setup_stage_req.transfer_recipient = USB_RECIP_DEVICE;
            setup_stage_req.transfer_direction = USB_HOST_TO_DEVICE;
            setup_stage_req.wLength            = 0;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
      5 :
      begin
            setup_stage_req.transfer_type      = USB_STANDARD;
            setup_stage_req.bRequest           = USB_SET_FEATURE;
            setup_stage_req.feature_selector   = USB_SS_U1_ENABLE;
            setup_stage_req.transfer_recipient = USB_RECIP_DEVICE;
            setup_stage_req.transfer_direction = USB_HOST_TO_DEVICE;
            setup_stage_req.wLength            = 0;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
      6 :
      begin
            setup_stage_req.transfer_type      = USB_STANDARD;
            setup_stage_req.bRequest           = USB_CLEAR_FEATURE;
            setup_stage_req.feature_selector   = USB_SS_U1_ENABLE;
            setup_stage_req.transfer_recipient = USB_RECIP_DEVICE;
            setup_stage_req.transfer_direction = USB_HOST_TO_DEVICE;
            setup_stage_req.wLength            = 0;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
      7 :
      begin
            setup_stage_req.transfer_type      = USB_STANDARD;
            setup_stage_req.bRequest           = USB_SET_FEATURE;
            setup_stage_req.feature_selector   = USB_SS_LTM_ENABLE;
            setup_stage_req.transfer_recipient = USB_RECIP_DEVICE;
            setup_stage_req.transfer_direction = USB_HOST_TO_DEVICE;
            setup_stage_req.wLength            = 0;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
      8 :
      begin
            setup_stage_req.transfer_type      = USB_STANDARD;
            setup_stage_req.bRequest           = USB_CLEAR_FEATURE;
            setup_stage_req.feature_selector   = USB_SS_LTM_ENABLE;
            setup_stage_req.transfer_recipient = USB_RECIP_DEVICE;
            setup_stage_req.transfer_direction = USB_HOST_TO_DEVICE;
            setup_stage_req.wLength            = 0;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
      9 :
      begin
            setup_stage_req.transfer_type      = USB_STANDARD;
            setup_stage_req.bRequest           = USB_SET_FEATURE;
            setup_stage_req.feature_selector   = USB_SS_ENDP_HALT_FUNC_SUSPEND;
            setup_stage_req.transfer_recipient = USB_RECIP_ENDPOINT;
            setup_stage_req.transfer_direction = USB_HOST_TO_DEVICE;
            setup_stage_req.wLength            = 0;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
     10 :
      begin
            setup_stage_req.transfer_type      = USB_STANDARD;
            setup_stage_req.bRequest           = USB_CLEAR_FEATURE;
            setup_stage_req.feature_selector   = USB_SS_ENDP_HALT_FUNC_SUSPEND;
            setup_stage_req.transfer_recipient = USB_RECIP_ENDPOINT;
            setup_stage_req.transfer_direction = USB_HOST_TO_DEVICE;
            setup_stage_req.wLength            = 0;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
     11 :
      begin
            setup_stage_req.transfer_type      = USB_STANDARD;
            setup_stage_req.bRequest           = USB_SET_FEATURE;
            setup_stage_req.feature_selector   = USB_SS_ENDP_HALT_FUNC_SUSPEND;
            setup_stage_req.transfer_recipient = USB_RECIP_INTERFACE;
            setup_stage_req.transfer_direction = USB_HOST_TO_DEVICE;
            setup_stage_req.wLength            = 0;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
     12 :
      begin
            setup_stage_req.transfer_type      = USB_STANDARD;
            setup_stage_req.bRequest           = USB_CLEAR_FEATURE;
            setup_stage_req.feature_selector   = USB_SS_ENDP_HALT_FUNC_SUSPEND;
            setup_stage_req.transfer_recipient = USB_RECIP_INTERFACE;
            setup_stage_req.transfer_direction = USB_HOST_TO_DEVICE;
            setup_stage_req.wLength            = 0;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
     13 :
      begin
            setup_stage_req.transfer_type       = USB_STANDARD;
            setup_stage_req.bRequest            = USB_SET_ADDRESS;
            setup_stage_req.transfer_recipient  = USB_RECIP_DEVICE;
            setup_stage_req.transfer_direction  = USB_HOST_TO_DEVICE;
            setup_stage_req.wLength             = 0;
            setup_stage_req.dev_addr_for_wValue = 11;//6;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
     14 :
      begin
            setup_stage_req.transfer_type       = USB_STANDARD;
            setup_stage_req.bRequest            = USB_GET_DESCRIPTOR;
            setup_stage_req.transfer_recipient  = USB_RECIP_DEVICE;
            setup_stage_req.transfer_direction  = USB_DEVICE_TO_HOST;
            setup_stage_req.wLength             = 18;
            setup_stage_req.descriptor_type     = USB_DEVICE;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
     15 :
      begin
            setup_stage_req.transfer_type       = USB_STANDARD;
            setup_stage_req.bRequest            = USB_GET_DESCRIPTOR;
            setup_stage_req.transfer_recipient  = USB_RECIP_DEVICE;
            setup_stage_req.transfer_direction  = USB_DEVICE_TO_HOST;
            setup_stage_req.wLength             = 18;
            setup_stage_req.descriptor_type     = USB_CONFIGURATION;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
     16 :
      begin
            setup_stage_req.transfer_type       = USB_STANDARD;
            setup_stage_req.bRequest            = USB_GET_DESCRIPTOR;
            setup_stage_req.transfer_recipient  = USB_RECIP_DEVICE;
            setup_stage_req.transfer_direction  = USB_DEVICE_TO_HOST;
            setup_stage_req.wLength             = 18;
            setup_stage_req.descriptor_type     = USB_SS_BOS;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
     17 :
      begin
            setup_stage_req.transfer_type       = USB_STANDARD;
            setup_stage_req.bRequest            = USB_GET_CONFIGURATION;
            setup_stage_req.transfer_recipient  = USB_RECIP_DEVICE;
            setup_stage_req.transfer_direction  = USB_DEVICE_TO_HOST;
            setup_stage_req.wLength             = 1;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
     18 :
      begin
            setup_stage_req.transfer_type       = USB_STANDARD;
            setup_stage_req.bRequest            = USB_SET_CONFIGURATION;
            setup_stage_req.transfer_recipient  = USB_RECIP_DEVICE;
            setup_stage_req.transfer_direction  = USB_HOST_TO_DEVICE;
            setup_stage_req.wLength             = 0;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
     19 :
      begin
            setup_stage_req.transfer_type       = USB_STANDARD;
            setup_stage_req.bRequest            = USB_GET_INTERFACE;
            setup_stage_req.transfer_recipient  = USB_RECIP_INTERFACE;
            setup_stage_req.transfer_direction  = USB_DEVICE_TO_HOST;
            setup_stage_req.wLength             = 1;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
     20 :
      begin
            setup_stage_req.transfer_type       = USB_STANDARD;
            setup_stage_req.bRequest            = USB_SET_INTERFACE;
            setup_stage_req.transfer_recipient  = USB_RECIP_INTERFACE;
            setup_stage_req.transfer_direction  = USB_HOST_TO_DEVICE;
            setup_stage_req.wLength             = 0;
            perform_control_transfer ( .control_req (setup_stage_req));
      end
  endcase
  end
  setup_stage_req.transfer_type       = USB_STANDARD;
  setup_stage_req.bRequest            = USB_SET_ADDRESS;
  setup_stage_req.transfer_recipient  = USB_RECIP_DEVICE;
  setup_stage_req.transfer_direction  = USB_HOST_TO_DEVICE;
  setup_stage_req.wLength             = 0;
  setup_stage_req.dev_addr_for_wValue = 0;//6;
  perform_control_transfer ( .control_req (setup_stage_req));

endtask : body

// Task: set_stall
//
// This task is used to halt an endpoint by sending SET FEATURE with feature
// selector -> ENDPOINT_HALT.
//
task protocol_random_seq :: set_stall ( input bit [3:0] endp_addr,
                                                input bit       dir
                                              );

  bit[7:0] setup_data[8];

  setup_data[0] = { USB_HOST_TO_DEVICE, USB_STANDARD, USB_RECIP_ENDPOINT };
  setup_data[1] = USB_SET_FEATURE;
  setup_data[2] = USB_SS_ENDP_HALT_FUNC_SUSPEND;
  setup_data[3] = 8'h00;
  setup_data[4] = {dir, 3'h0, endp_addr};
  setup_data[5] = 8'h00;
  setup_data[6] = 8'h00;
  setup_data[7] = 8'h00;

  usb_ss_control_write ( .setup_data_packet (setup_data),
                         .device_addr       (cfg.host_db.device_addr[route_string]),
                         .endp_addr         ('h00),
                         .max_packet_size   ('h200),
                         .success           (success),
                         .route_string      (route_string)
                       );
endtask : set_stall

// Task: perform_control_transfer
//
// This task is used to perform control transfer.
//
task protocol_random_seq :: perform_control_transfer ( input  setup_stage_reqc_t control_req );

  bit[7:0]  setup_data[8];
  bit[7:0]  tmp_data[2];
  bit[7:0]  exp_data[];
  bit[16:0] length;
  bit[3:0]  endp_addr;

  $cast(length, control_req.wLength);

  endp_addr = 4'h0;

  // Conversion to byte form
  setup_data[0] = {control_req.transfer_direction, control_req.transfer_type, control_req.transfer_recipient};
  setup_data[1] = control_req.bRequest;
  setup_data[6] = length[7:0];
  setup_data[7] = length[15:8];

  update_wValue( .control_req (control_req),
                 ._data       (tmp_data)
               );

  setup_data[2] = tmp_data[0];
  setup_data[3] = tmp_data[1];

  update_wIndex( .control_req (control_req),
                 ._data       (tmp_data)
               );

  setup_data[4] = tmp_data[0];
  setup_data[5] = tmp_data[1];

  // Error Injection in Protocol Layer
  update_error_injections (endp_addr);

  if (control_req.transfer_direction == USB_HOST_TO_DEVICE)
  begin
    usb_ss_control_write ( .setup_data_packet (setup_data),
                           .device_addr       (cfg.host_db.device_addr[route_string]),
                           .endp_addr         (endp_addr),
                           .max_packet_size   ('h200),
                           .success           (success),
                           .route_string      (route_string),
                           .inject_error      (1'b1)
                          );
  end
  else
  begin
    usb_ss_control_read ( .setup_data_packet (setup_data),
                          .device_addr       (cfg.host_db.device_addr[route_string]),
                          .endp_addr         (endp_addr),
                          .exp_num_bytes     ({setup_data[7], setup_data[6]}),
                          .max_packet_size   ('h200),
                          .exp_data          (exp_data),
                          .success           (success),
                          .route_string      (route_string),
                          .inject_error      (1'b1)
                        );
  end
endtask : perform_control_transfer

// Task: perform_burst_transfer
//
// This task is used for performing Burst transactions for
// Bulk/Interrupt/Isochronous IN/OUT endpoints.
//
task protocol_random_seq :: perform_burst_transfer ( input bit[4:0] endp_addr,
                                                             input bit      iso_xfr
                                                           );

  bit[7:0] exp_data[];
  bit[7:0] data[];
  int      data_size;
  int      ulimit;
  bit[3:0] rand_data;
    
  // Determining data size for the OUT/IN data stage
  randcase
  1 * ((count_5 < 1) || ((count_5 == 1) && (count_6 == 1) && (count_7 == 2))) :
  begin
    data_size = cfg.host_db.endp_prop[route_string].max_packet_size[endp_addr];
    if((count_5 == 1) && (count_6 == 1) && (count_7 == 2))
    begin
      count_5 = 0; count_6 = 0; count_7 = 0;
    end
    count_5++;
  end 
  1 * ((count_6 < 1) || ((count_5 == 1) && (count_7 == 2) && (count_6 == 1))) :
  begin
    data_size = cfg.host_db.endp_prop[route_string].max_packet_size[endp_addr]+1;
    if((count_5 == 1) && (count_6 == 1) && (count_7 == 2))
    begin
      count_6 = 0; count_5 = 0; count_7 = 0;
    end
    count_6++;
  end 
  1 * ((count_7 < 2) || ((count_5 == 1) && (count_6 == 1) && (count_7 == 2))) :
  begin
    data_size = (cfg.host_db.endp_prop[route_string].max_packet_size[endp_addr])/2;
    if((count_5 == 1) && (count_6 == 1) && (count_7 == 2))
    begin
      count_7 = 0;count_5 = 0; count_6 = 0;
    end
    count_7++;
  end
  endcase

  // Error Injection in Protocol Layer
  if ( !std::randomize (rand_data)) `uvm_error("ASSRT","Assert statement failure");
  update_error_injections (endp_addr);

  if (endp_addr[4] == 1'b1) // IN Data Stage
  begin
    device_cfg.number_of_exp_bytes[endp_addr] = data_size;

    randcase
    1 * ((count_3 < 1) || ((count_3 == 1) && (count_4 == 1))) :
    begin
      randcase 
        1 * ((count_1 < 3) || ((count_2 == 1) && (count_1 == 3))) : 
        begin
          if((count_2 == 1) && (count_1 == 3))
          begin
            count_1 = 0;count_2 = 0;
          end
          count_1++;
        end
        1 * ((count_2 < 1) || ((count_1 == 3) && (count_2 == 1))) : 
        begin
          set_stall (endp_addr, 1'b1);
          if((count_2 == 1) && (count_1 == 3))
          begin
            count_2 = 0;count_1 = 0;
          end
          count_2++;
        end
      endcase
      if((count_4 == 1) && (count_3 == 1))
      begin
        count_3 = 0;count_4 = 0;
      end 
      count_3++;
    end
    1 * ((count_4 < 1) || ((count_3 == 1) && (count_4 == 1))) :
    begin
      if((count_4 == 1) && (count_3 == 1))
      begin
        count_4 = 0;count_3 = 0;
      end 
      count_4++;
    end
    endcase

    if (iso_xfr == 1'b0)
    begin
      if (prev_not_complete[endp_addr] == 1'b1)
      begin
        data_size                                 = next_expected_data[endp_addr];
        prev_not_complete[endp_addr]              = 1'b0;
        next_expected_data[endp_addr]             = 0;
        device_cfg.number_of_exp_bytes[endp_addr] = data_size;
      end
      
      usb_ss_in_data_stage ( .device_addr     (cfg.host_db.device_addr[route_string]),
                             .endp_addr       (endp_addr),
                             .exp_num_bytes   (data_size),
                             .max_packet_size (cfg.host_db.endp_prop[route_string].max_packet_size[endp_addr]),
                             .max_burst_size  (cfg.host_db.endp_prop[route_string].max_burst_size[endp_addr]),
                             .tx_seq_num      (cfg.host_db.endp_prop[route_string].seq_num[endp_addr]),
                             .exp_data        (exp_data),
                             .success         (success)
                           );

      if ((success == 1'b1) && (data_size > exp_data.size()))
      begin
        prev_not_complete[endp_addr]  = 1'b1;
        next_expected_data[endp_addr] = data_size - exp_data.size();
      end
    end
    else
    begin
      randcase
        1 * ((count_8 < 3) || ((count_9 == 1) && (count_8 == 3))) :
        begin
          if((count_8 == 3) && (count_9 == 1))
          begin
            count_8 = 0;count_9 = 0;
          end
          count_8++;
        end
        1 * ((count_9 < 1) || ((count_8 == 3) && (count_9 == 1))) :
        begin
          ping_seq_t ping_seq = ping_seq_t::type_id::create("ping_seq");
          
          ping_seq.device_addr    = cfg.host_db.device_addr[route_string];
          ping_seq.endp_addr      = endp_addr[3:0];
          ping_seq.endp_direction = USB_SS_DEVICE_TO_HOST;
          if((count_8 == 3) && (count_9 == 1))
          begin
            count_9 = 0;count_8 = 0;
          end
          count_9++; 

          ping_seq.start(m_sequencer);
        end
      endcase

      usb_ss_iso_in_data_stage ( .device_addr     (cfg.host_db.device_addr[route_string]),
                                 .endp_addr       (endp_addr),
                                 .exp_num_bytes   (data_size),
                                 .max_packet_size (cfg.host_db.endp_prop[route_string].max_packet_size[endp_addr]),
                                 .max_burst_size  (cfg.host_db.endp_prop[route_string].max_burst_size[endp_addr]),
                                 .tx_seq_num      (cfg.host_db.endp_prop[route_string].seq_num[endp_addr]),
                                 .exp_data        (exp_data)
                               );
    end
  end
  else // OUT Data Stage
  begin
    data = new [data_size];
    if ( !std::randomize (data)) `uvm_error("ASSRT","Assert statement failure");

    if (iso_xfr == 1'b0)
    begin
      randcase
      1 * ((count_12 < 1) || ((count_13 == 1) && (count_12 == 1))) :
      begin
        if((count_12 == 1) && (count_13 == 1))
        begin
          count_12 = 0;count_13 = 0;
        end
        count_12++;
      end
      1 * ((count_13 < 1) || ((count_12 == 1)&& (count_13 == 1))) :
      begin
        set_stall (endp_addr, 1'b0);
        if((count_12 == 1) && (count_13 == 1))
        begin 
          count_13 = 0;count_12 = 0;
        end
        count_13++;
      end
      endcase

      usb_ss_out_data_stage ( .device_addr      (cfg.host_db.device_addr[route_string]),
                              .endp_addr        (endp_addr),
                              .max_packet_size  (cfg.host_db.endp_prop[route_string].max_packet_size[endp_addr]),
                              .next_burst_size  (cfg.host_db.endp_prop[route_string].next_burst_size[endp_addr]),
                              .tx_seq_num       (cfg.host_db.endp_prop[route_string].seq_num[endp_addr]),
                              .data_payload     (data),
                              .success          (success),
                              .route_string     (route_string),
                              .inject_error     (1'b1)
                            );
    end
    else
    begin
      randcase
        1 * ((count_10 < 3) || ((count_11 == 1) && (count_10 == 3))) :
        begin
          if((count_10 == 3) && (count_11 == 1))
          begin
            count_10 = 0;count_11 = 0;
          end
          count_10++;
        end
        1 * ((count_11 < 1) || ((count_10 == 3) && (count_11 == 1))) :
        begin
          ping_seq_t ping_seq = ping_seq_t::type_id::create("ping_seq");

          ping_seq.device_addr    = cfg.host_db.device_addr[route_string];
          ping_seq.endp_addr      = endp_addr[3:0];
          ping_seq.endp_direction = USB_SS_HOST_TO_DEVICE;
          if((count_10 == 3) && (count_11 == 1))
          begin
            count_11 = 0;count_10 = 0;
          end
          count_11++; 

          ping_seq.start(m_sequencer);
        end
      endcase

      usb_ss_iso_out_data_stage ( .device_addr      (cfg.host_db.device_addr[route_string]),
                                  .endp_addr        (endp_addr),
                                  .max_packet_size  (cfg.host_db.endp_prop[route_string].max_packet_size[endp_addr]),
                                  .max_burst_size   (cfg.host_db.endp_prop[route_string].max_burst_size[endp_addr]),
                                  .tx_seq_num       (cfg.host_db.endp_prop[route_string].seq_num[endp_addr]),
                                  .data_payload     (data),
                                  .lpf_send         (rand_data[2]),
                                  .inject_error     (1'b1)
                               );

      if (rand_data[2])
        cfg.host_db.endp_prop[route_string].seq_num[endp_addr] = 'h00;
    end
  end
endtask : perform_burst_transfer

// Task: perform_streaming
//
// This task is used for performing streaming.
//
task protocol_random_seq :: perform_streaming ( input bit[4:0]  endp_addr,
                                                        input bit[15:0] stream_id = 0
                                                      );

  bit[7:0]  data[];
  bit[1:0]  rand_gen;
  bit[1:0]  stream_complete;
  bit[15:0] tmp_id;
  int       data_size;
  int       ulimit;

  usb_ss_host_bulk_in_stream_data_sequence #(DATA_BUS_WIDTH)  bulk_in_stream_seq  = usb_ss_host_bulk_in_stream_data_sequence #(DATA_BUS_WIDTH)::type_id::create("bulk_in_stream_seq");
  usb_ss_host_bulk_out_stream_data_sequence #(DATA_BUS_WIDTH) bulk_out_stream_seq = usb_ss_host_bulk_out_stream_data_sequence #(DATA_BUS_WIDTH)::type_id::create("bulk_out_stream_seq");

  // Determining data size for the OUT/IN data stage
  randcase
  1 * ((count_16 < 1) || ((count_17 == 1) && (count_18 == 4) && (count_16 == 1))) :
  begin
    data_size = cfg.host_db.endp_prop[route_string].max_packet_size[endp_addr];
    if((count_16 == 1) && (count_17 == 1) && (count_18 == 4))
    begin
      count_16 = 0;count_17 = 0;count_18 = 0;
    end
    count_16++;
  end 
  1 * ((count_17 < 1) || ((count_16 == 1) && (count_18 == 4) && (count_17 == 1))) :
  begin
    data_size = (cfg.host_db.endp_prop[route_string].max_packet_size[endp_addr])/2;
    if((count_16 == 1) && (count_17 == 1) && (count_18 == 4))
    begin
      count_17 = 0;count_16 = 0;count_18 = 0;
    end
    count_17++;
  end 
  1 * ((count_18 < 4) || ((count_16 == 1) && (count_17 == 1) && (count_18 == 4))) :
  begin
    data_size = 2 * cfg.host_db.endp_prop[route_string].max_packet_size[endp_addr];
    if((count_16 == 1) && (count_17 == 1) && (count_18 == 4))
    begin
      count_18 = 0;count_17 = 0;count_16 = 0;
    end
    count_18++;
  end
  endcase 


  // Error Injection in Protocol Layer
  update_error_injections (endp_addr);

  if (stream_id == 0)
  begin
    randcase
    1 * ((count_14 < 5) || ((count_15 == 1) && (count_14 == 5))) :
    begin
      if((count_14 == 5) && (count_15 == 1))
      begin
        count_14 = 0;count_15 = 0;
      end 
      count_14++;
    end
    1 * ((count_15 < 1) || ((count_14 == 5) && (count_15 == 1))) :
    begin
      set_stall ( endp_addr[3:0], endp_addr[4] );
      if((count_14 == 5) && (count_15 == 1))
      begin
        count_15 = 0;count_14 = 0;
      end
      count_15++;
    end
    endcase
  end

  if (flow_cntrl_mgmt_running.exists(endp_addr) && flow_cntrl_mgmt_running[endp_addr])
    wait (flow_cntrl_mgmt_running[endp_addr] == 1'b0);

  fork
    begin
      if (endp_addr[4] == 1'b0)
      begin
        data = new[data_size];
        if ( !std::randomize (data)) `uvm_error("ASSRT","Assert statement failure");
        if ( !std::randomize (rand_gen)) `uvm_error("ASSRT","Assert statement failure");

        bulk_out_stream_seq.device_addr          = cfg.host_db.device_addr[route_string];
        bulk_out_stream_seq.endp_addr            = endp_addr;
        bulk_out_stream_seq.send_num_bytes       = data_size;
        bulk_out_stream_seq.data_payload         = data;
        bulk_out_stream_seq.seq_num              = cfg.host_db.endp_prop[route_string].seq_num[endp_addr] ;
        bulk_out_stream_seq.next_burst_size      = cfg.host_db.endp_prop[route_string].max_burst_size[endp_addr];
        bulk_out_stream_seq.max_packet_size      = cfg.host_db.endp_prop[route_string].max_packet_size[endp_addr];
        bulk_out_stream_seq.max_stream_size      = cfg.host_db.endp_prop[route_string].max_stream_size[endp_addr];
        bulk_out_stream_seq.host_initiate_stream = rand_gen[0];
        bulk_out_stream_seq.back_to_prime_pipe   = rand_gen[1];
        bulk_out_stream_seq.accept_device_stream = (rand_gen[0] == 1'b1) ? 1'b0 : $urandom_range(1,0);
        bulk_out_stream_seq.stream_id            = (stream_id != 0) ? stream_id : $urandom_range(cfg.host_db.endp_prop[route_string].max_stream_size[endp_addr], 1);
        bulk_out_stream_seq.stream_state         = cfg.host_db.endp_prop[route_string].current_stream_state[endp_addr];

        device_cfg.move_from_prime_to_idle_state[endp_addr]        = 1'b1;
        device_cfg.move_from_idle_to_start_stream_state[endp_addr] = ~rand_gen[0];

        if (bulk_out_stream_seq.stream_state == START_STREAM_STATE) 
        begin
          bulk_out_stream_seq.host_initiate_stream = ~bulk_out_stream_seq.accept_device_stream;
        end

        fork
          if ((bulk_out_stream_seq.back_to_prime_pipe == 1'b1) && (bulk_out_stream_seq.host_initiate_stream == 1'b0))
          begin
            if (bulk_out_stream_seq.stream_state == DISABLED_STATE)
            begin
              wait (bulk_out_stream_seq.stream_state == PRIME_PIPE_STATE);
              wait (bulk_out_stream_seq.stream_state == IDLE_STATE);
              wait (bulk_out_stream_seq.stream_state == PRIME_PIPE_STATE);
              wait (bulk_out_stream_seq.stream_state == IDLE_STATE);

              device_cfg.move_from_idle_to_start_stream_state[endp_addr] = 1'b1;
            end
            else if (bulk_out_stream_seq.stream_state == IDLE_STATE)
            begin
              wait (bulk_out_stream_seq.stream_state == PRIME_PIPE_STATE);
              wait (bulk_out_stream_seq.stream_state == IDLE_STATE);

              device_cfg.move_from_idle_to_start_stream_state[endp_addr] = 1'b1;
            end
          end
        join_none

        bulk_out_stream_seq.start(m_sequencer);

        cfg.host_db.endp_prop[route_string].current_stream_state[endp_addr] = bulk_out_stream_seq.stream_state;
        cfg.host_db.endp_prop[route_string].seq_num[endp_addr]              = bulk_out_stream_seq.seq_num;
        tmp_id                          = bulk_out_stream_seq.stream_id;
        stream_complete[0]              = 1'b1;
      end
      else
      begin
        bulk_in_stream_seq.device_addr          = cfg.host_db.device_addr[route_string];
        bulk_in_stream_seq.endp_addr            = endp_addr;
        bulk_in_stream_seq.exp_num_bytes        = data_size;
        bulk_in_stream_seq.seq_num              = cfg.host_db.endp_prop[route_string].seq_num[endp_addr];
        bulk_in_stream_seq.max_burst_size       = cfg.host_db.endp_prop[route_string].max_burst_size[endp_addr];
        bulk_in_stream_seq.max_packet_size      = cfg.host_db.endp_prop[route_string].max_packet_size[endp_addr];
        bulk_in_stream_seq.max_stream_size      = cfg.host_db.endp_prop[route_string].max_stream_size[endp_addr];
        bulk_in_stream_seq.host_initiate_stream = rand_gen[0];
        bulk_in_stream_seq.back_to_prime_pipe   = rand_gen[1];
        bulk_in_stream_seq.accept_device_stream = (rand_gen[0] == 1'b1) ? 1'b0 : $urandom_range(1,0);
        bulk_in_stream_seq.stream_id            = (stream_id != 0) ? stream_id : $urandom_range(cfg.host_db.endp_prop[route_string].max_stream_size[endp_addr], 1);
        bulk_in_stream_seq.stream_state         = cfg.host_db.endp_prop[route_string].current_stream_state[endp_addr];

        device_cfg.move_from_prime_to_idle_state[endp_addr]        = 1'b1;
        device_cfg.move_from_idle_to_start_stream_state[endp_addr] = ~rand_gen[0];
        device_cfg.number_of_exp_bytes[endp_addr]                  = data_size;

        if (bulk_in_stream_seq.stream_state == START_STREAM_STATE) 
        begin
          bulk_in_stream_seq.host_initiate_stream = ~bulk_in_stream_seq.accept_device_stream;
        end

        fork
          if ((bulk_in_stream_seq.back_to_prime_pipe == 1'b1) && (bulk_in_stream_seq.host_initiate_stream == 1'b0))
          begin
            if (bulk_in_stream_seq.stream_state == DISABLED_STATE)
            begin
              wait (bulk_in_stream_seq.stream_state == PRIME_PIPE_STATE);
              wait (bulk_in_stream_seq.stream_state == IDLE_STATE);
              wait (bulk_in_stream_seq.stream_state == PRIME_PIPE_STATE);
              wait (bulk_in_stream_seq.stream_state == IDLE_STATE);

              device_cfg.move_from_idle_to_start_stream_state[endp_addr] = 1'b1;
            end
            else if (bulk_in_stream_seq.stream_state == IDLE_STATE)
            begin
              wait (bulk_in_stream_seq.stream_state == PRIME_PIPE_STATE);
              wait (bulk_in_stream_seq.stream_state == IDLE_STATE);

              device_cfg.move_from_idle_to_start_stream_state[endp_addr] = 1'b1;
            end
          end
        join_none

        bulk_in_stream_seq.start(m_sequencer);

        cfg.host_db.endp_prop[route_string].current_stream_state[endp_addr] = bulk_in_stream_seq.stream_state;
        cfg.host_db.endp_prop[route_string].seq_num[endp_addr]              = bulk_in_stream_seq.seq_num;
        tmp_id                          = bulk_in_stream_seq.stream_id;
        stream_complete[1]              = 1'b1;
      end
    end
  join_none

  wait (stream_complete[0] || stream_complete[1]);

  if ((cfg.host_db.endp_prop[route_string].current_stream_state[endp_addr] == IDLE_STATE) &&
       device_cfg.move_from_idle_to_start_stream_state[endp_addr] &&
       (!flow_cntrl_mgmt_running.exists(endp_addr) || !flow_cntrl_mgmt_running[endp_addr]))
    wait_for_device_initiated_streaming (endp_addr, tmp_id);

endtask : perform_streaming

// Task: wait_for_device_initiated_streaming
//
// This task is used for receiving ERDY. Stream n and wait for SPSM
// transition to START STREAM.
//
task protocol_random_seq :: wait_for_device_initiated_streaming (input bit[4:0]   endp_addr,
                                                                         input bit [15:0] tmp_id
                                                                        );

  usb_ss_host_endp_flow_control_mgmt #(DATA_BUS_WIDTH) flow_cntrl_mgmt = usb_ss_host_endp_flow_control_mgmt #(DATA_BUS_WIDTH)::type_id::create("flow_cntrl_mgmt");

  flow_cntrl_mgmt_running[endp_addr] = (flow_cntrl_mgmt_running.exists(endp_addr)) ? flow_cntrl_mgmt_running[endp_addr] : 0;

  if ((cfg.host_db.endp_prop[route_string].current_stream_state[endp_addr] == IDLE_STATE) && !flow_cntrl_mgmt_running[endp_addr])
  begin
    fork
      begin
        flow_cntrl_mgmt.device_addr    = cfg.host_db.device_addr[route_string];
        flow_cntrl_mgmt.endp_addr      = endp_addr;
        flow_cntrl_mgmt.endp_direction = usb_ss_endp_direction_e'(endp_addr[4]);

        do
        begin
          flow_cntrl_mgmt_running[endp_addr] = 1'b1;

          flow_cntrl_mgmt.start(m_sequencer);
        end
        while (flow_cntrl_mgmt.stream_id == 0);

        if (cfg.host_db.endp_prop[route_string].current_stream_state[endp_addr] == IDLE_STATE)
        begin
          cfg.host_db.endp_prop[route_string].current_stream_state[endp_addr] = START_STREAM_STATE;
          //perform_streaming (endp_addr, flow_cntrl_mgmt.stream_id);
        end

        flow_cntrl_mgmt_running[endp_addr] = 1'b0;
      end
    join_none
  end
endtask : wait_for_device_initiated_streaming

// Task: update_wValue
//
// This task is used for updating wValue values to the control transfers.
// Incorrect wValue values are injected randomly.
//
task protocol_random_seq :: update_wValue ( input  setup_stage_reqc_t control_req,
                                                    output bit[7:0]           _data[2]
                                                  );

  case (control_req.bRequest)
    USB_GET_STATUS :
      begin
        randcase
          4 * ((control_random_gen7 == 2'b00) || (control_random_gen7 == 2'b11)) :
          begin 
            {_data[0], _data[1]} = 'h0;
            if(control_random_gen7 != 2'b11)
              control_random_gen7 = 2'b01;
          end
          1 * ((control_random_gen7 == 2'b01) || (control_random_gen7 == 2'b11)) :
          begin
            {_data[0], _data[1]} = {control_req.wValue[0], control_req.wValue[1]};
            control_random_gen7 = 2'b11;
          end
        endcase
      end
    USB_CLEAR_FEATURE :
      begin
        _data[1] = 'h0;
        _data[0] = control_req.feature_selector;
      end
    USB_SET_FEATURE :
      begin
        _data[1] = 'h0;
        _data[0] = control_req.feature_selector;
      end
    USB_SET_ADDRESS :
      begin
        _data[1] = 'h0;
        _data[0] = control_req.dev_addr_for_wValue;;
      end
    USB_GET_DESCRIPTOR :
      begin
        _data[1] = control_req.descriptor_type;
        _data[0] = $urandom(int'(cfg.host_db.device_descriptor[route_string].descriptor[17]));
      end
    USB_GET_CONFIGURATION :
      begin
        randcase
          4 * ((control_random_gen8 == 2'b00) || (control_random_gen8 == 2'b11)):
          begin
            {_data[0], _data[1]} = 'h0;
            if(control_random_gen8 != 2'b11)
              control_random_gen8 = 2'b01;
          end
          1 * ((control_random_gen8 == 2'b01) || (control_random_gen8 == 2'b11)):
          begin
            {_data[0], _data[1]} = {control_req.wValue[0], control_req.wValue[1]};
            control_random_gen8 = 2'b11;
          end
        endcase
      end
    USB_SET_CONFIGURATION :
      begin
        _data[1] = 'h0;
        _data[0] = cfg.host_db.config_descriptor[$urandom_range((cfg.host_db.config_descriptor.size() - 1), 0 )].descriptor[5];
      end
    USB_GET_INTERFACE :
      begin
        randcase
          4 * ((control_random_gen9 == 2'b00) || (control_random_gen9 == 2'b11)) :
          begin
            {_data[0], _data[1]} = 'h0;
            if(control_random_gen9 != 2'b11)
              control_random_gen9 = 2'b01;
          end
          1 * ((control_random_gen9 == 2'b01) || (control_random_gen9 == 2'b11)) :
          begin 
            {_data[0], _data[1]} = {control_req.wValue[0], control_req.wValue[1]};
            control_random_gen9 = 2'b11;
          end  
        endcase
      end
    USB_SET_INTERFACE :
      begin
        randcase
          4 * ((control_random_gen10 == 2'b00) || (control_random_gen10 == 2'b11)):
          begin 
            {_data[0], _data[1]} = 'h1;
            if(control_random_gen10 != 2'b11)
              control_random_gen10 = 2'b01;
          end
          1 * ((control_random_gen10 == 2'b01) || (control_random_gen10 == 2'b11)):
          begin
            {_data[0], _data[1]} = {control_req.wValue[0], control_req.wValue[1]};
            control_random_gen10 = 2'b11;
          end
        endcase
      end
  endcase
endtask : update_wValue

// Task: update_wIndex
//
// This task is used for updating wIndex values to the control transfers.
// Incorrect wIndex values are injected randomly.
//
task protocol_random_seq :: update_wIndex ( input  setup_stage_reqc_t control_req,
                                                    output bit[7:0]           _data[2]
                                                  );

  case (control_req.bRequest)
    USB_GET_STATUS :
      begin
        randcase
          4 * ((control_random_gen2 == 2'b00) || (control_random_gen2 == 2'b11)):
          begin
            case (control_req.transfer_recipient)
              USB_RECIP_DEVICE    : {_data[0], _data[1]} = 'h0;
              USB_RECIP_INTERFACE : {_data[1], _data[0]} = $urandom_range(cfg.host_db.alt_setting[route_string].active_alternate_setting.size(), 0);
              USB_RECIP_ENDPOINT  :
                begin
                  bit[15:0] endp_num;
                  int       rand_endp_num;
                  randcase
                    1 * ((control_random_gen1 == 2'b00) || (control_random_gen1 == 2'b11)): 
                      begin
                        rand_endp_num = $urandom_range((cfg.host_db.active_bulk_endpoints[route_string].active_endpoints.size() - 1), 0);
                        endp_num = {11'h000, cfg.host_db.active_bulk_endpoints[route_string].active_endpoints[rand_endp_num]};
                        if(control_random_gen1 != 2'b11)
                          control_random_gen1 = 2'b01;
                      end
                    1 * ((control_random_gen1 == 2'b01) || (control_random_gen1 == 2'b11)):
                      begin
                        rand_endp_num = $urandom_range((cfg.host_db.active_interrupt_endpoints[route_string].active_endpoints.size() - 1), 0);
                        endp_num = {11'h000, cfg.host_db.active_interrupt_endpoints[route_string].active_endpoints[rand_endp_num]};
                        if(control_random_gen1 != 2'b11)
                          control_random_gen1 = 2'b10;
                      end
                    1 * ((control_random_gen1 == 2'b10) || (control_random_gen1 == 2'b11)): 
                      begin
                        rand_endp_num = $urandom_range((cfg.host_db.active_isochronous_endpoints[route_string].active_endpoints.size() - 1), 0);
                        endp_num = {11'h000, cfg.host_db.active_isochronous_endpoints[route_string].active_endpoints[rand_endp_num]};
                        control_random_gen1 = 2'b11;
                      end
                  endcase
                  {_data[1], _data[0]} = endp_num;
                end
            endcase
            if(control_random_gen2 != 2'b11)
              control_random_gen2 = 2'b01;
          end
          1 * ((control_random_gen2 == 2'b01) || (control_random_gen2 == 2'b11)) :
          begin
            {_data[0], _data[1]} = {control_req.wValue[0], control_req.wValue[1]};
            control_random_gen2 = 2'b11;
          end
        endcase
      end
    USB_CLEAR_FEATURE :
      begin
        randcase
          4 * ((control_random_gen4 == 2'b00) || (control_random_gen4 == 2'b11)):
          begin
            case (control_req.transfer_recipient)
              USB_RECIP_DEVICE    : {_data[0], _data[1]} = 'h0;
              USB_RECIP_INTERFACE : {_data[1], _data[0]} = $urandom_range(cfg.host_db.alt_setting[route_string].active_alternate_setting.size(), 0);
              USB_RECIP_ENDPOINT  :
                begin
                  bit[15:0] endp_num;
                  int       rand_endp_num;
                  randcase
                    1 * ((control_random_gen3 == 2'b00) || (control_random_gen3 == 2'b11)) : 
                      begin
                        rand_endp_num = $urandom_range((cfg.host_db.active_bulk_endpoints[route_string].active_endpoints.size() - 1), 0);
                        endp_num = {11'h000, cfg.host_db.active_bulk_endpoints[route_string].active_endpoints[rand_endp_num]};
                        if(control_random_gen3 != 2'b11)
                          control_random_gen3 = 2'b01;
                      end
                    1 * ((control_random_gen3 == 2'b01) || (control_random_gen3 == 2'b11)) :
                      begin
                        rand_endp_num = $urandom_range((cfg.host_db.active_interrupt_endpoints[route_string].active_endpoints.size() - 1), 0);
                        endp_num = {11'h000, cfg.host_db.active_interrupt_endpoints[route_string].active_endpoints[rand_endp_num]};
                        if(control_random_gen3 != 2'b11)
                          control_random_gen3 = 2'b10;
                      end
                    1 * ((control_random_gen3 == 2'b10) || (control_random_gen3 == 2'b11)) : 
                      begin
                        rand_endp_num = $urandom_range((cfg.host_db.active_isochronous_endpoints[route_string].active_endpoints.size() - 1), 0);
                        endp_num = {11'h000, cfg.host_db.active_isochronous_endpoints[route_string].active_endpoints[rand_endp_num]};
                        control_random_gen3 = 2'b11;
                      end
                  endcase
                  {_data[1], _data[0]} = endp_num;
                end
            endcase
            if(control_random_gen4 != 2'b11)
              control_random_gen4 = 2'b01;
          end
          1 * ((control_random_gen4 == 2'b01) || (control_random_gen4 == 2'b11)): 
          begin
            {_data[0], _data[1]} = {control_req.wValue[0], control_req.wValue[1]};
            control_random_gen4 = 2'b11;
          end
        endcase
      end
    USB_SET_FEATURE :
      begin
        _data[1] = 'h0;
        _data[0] = control_req.feature_selector;
      end
    USB_SET_ADDRESS :
      begin
        _data[1] = 'h0;
        _data[0] = control_req.dev_addr_for_wValue;;
      end
    USB_GET_DESCRIPTOR :
      begin
        randcase
          4 * ((control_random_gen11 == 2'b00) || (control_random_gen11 == 2'b11)):
          begin 
            {_data[0], _data[1]} = 'h0;
            if(control_random_gen11 != 2'b11)
              control_random_gen11 = 2'b01;
          end
          1 * ((control_random_gen11 == 2'b01) || (control_random_gen11 == 2'b11)):
          begin
            {_data[0], _data[1]} = {control_req.wValue[0], control_req.wValue[1]};
            control_random_gen11 = 2'b11;
          end
        endcase
      end
    USB_GET_CONFIGURATION :
      begin
        randcase
          4 * ((control_random_gen12 == 2'b00) || (control_random_gen12 == 2'b11)):
          begin
            {_data[0], _data[1]} = 'h0;
            if(control_random_gen12 != 2'b11)
              control_random_gen12 = 2'b01;
          end  
          1 * ((control_random_gen12 == 2'b01) || (control_random_gen12 == 2'b11)):
          begin
            {_data[0], _data[1]} = {control_req.wValue[0], control_req.wValue[1]};
            control_random_gen12 = 2'b11;
          end  
        endcase
      end
    USB_SET_CONFIGURATION :
      begin
        _data[1] = 'h0;
        _data[0] = cfg.host_db.config_descriptor[$urandom_range((cfg.host_db.config_descriptor.size() - 1), 0 )].descriptor[5];
      end
    USB_GET_INTERFACE :
      begin
        randcase
          4 * ((control_random_gen13 == 2'b00) || (control_random_gen13 == 2'b11)) :
          begin
            {_data[1], _data[0]} = $urandom_range((cfg.host_db.alt_setting[route_string].active_alternate_setting.size() - 1), 0);
            if(control_random_gen13 != 2'b11)
              control_random_gen13 = 2'b01;
          end
          1 * ((control_random_gen13 == 2'b01) || (control_random_gen13 == 2'b11)) :
          begin
            {_data[0], _data[1]} = {control_req.wValue[0], control_req.wValue[1]};
            control_random_gen13 = 2'b11;
          end
        endcase
      end
    USB_SET_INTERFACE :
      begin
        randcase
          4 * ((control_random_gen14 == 2'b00) || (control_random_gen14 == 2'b11)):
          begin
            {_data[1], _data[0]} = $urandom_range((cfg.host_db.alt_setting[route_string].active_alternate_setting.size() - 1), 0);
            if(control_random_gen14 != 2'b11)
              control_random_gen14 = 2'b01;
          end
          1 * ((control_random_gen14 == 2'b01) || (control_random_gen14 == 2'b11)):
          begin
            {_data[0], _data[1]} = {control_req.wValue[0], control_req.wValue[1]};
            control_random_gen14 = 2'b11;
          end
        endcase
      end
  endcase
endtask : update_wIndex

// Task: update_error_injections
//
// This task is used to inject errors in DP transmitted from device.
//
function void protocol_random_seq :: update_error_injections ( input bit [4:0] endp_addr );

  bit[2:0] seed;

  if ( !std::randomize (seed)) `uvm_error("ASSRT","Assert statement failure");

  device_cfg.enter_flow_control_state[endp_addr] = seed[0];
  device_cfg.inject_data_packet_error[endp_addr] = seed[1];

endfunction : update_error_injections
