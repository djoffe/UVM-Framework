//
// File: axi4_master_0_config_policy.sv
//
// Generated from Mentor VIP Configurator (20230807)
// Generated using Mentor VIP Library ( 2023.3_1 : 08/18/2023:20:00 )
//
class axi4_master_0_config_policy;
    static function void configure
    (
        input axi4_master_0_cfg_t cfg,
        input address_map addrm
    );
        //
        // Agent setup configurations:
        //
        cfg.agent_cfg.is_active = 1;
        cfg.agent_cfg.agent_type = mgc_axi4_v1_0_pkg::AXI4_MASTER;
        // Interface type
        cfg.agent_cfg.if_type = mgc_axi4_v1_0_pkg::AXI4;
        // Use external clock
        cfg.agent_cfg.ext_clock = 1;
        // Use external reset
        cfg.agent_cfg.ext_reset = 1;
        // Enable functional coverage
        cfg.agent_cfg.en_cvg.func = 1'b0;
        // Enable write ch toggle coverage
        cfg.agent_cfg.en_cvg.wr_ch_toggle = 1'b0;
        // Enable read ch toggle coverage
        cfg.agent_cfg.en_cvg.rd_ch_toggle = 1'b0;
        // Enable transaction logger
        cfg.agent_cfg.en_logger.txn_log = 0;
        // Enable beat logger
        cfg.agent_cfg.en_logger.beat_log = 0;
        // Transaction logger file name
        cfg.agent_cfg.en_logger.txn_log_name = "txn.log";
        // Beat logger file name
        cfg.agent_cfg.en_logger.beat_log_name = "beat.log";
        cfg.agent_cfg.en_logger.txn_column.tr = 1;
        cfg.agent_cfg.en_logger.txn_column.id = 1;
        cfg.agent_cfg.en_logger.txn_column.addr = 1;
        cfg.agent_cfg.en_logger.txn_column.addr_time = 1;
        cfg.agent_cfg.en_logger.txn_column.data = 1;
        cfg.agent_cfg.en_logger.txn_column.strb = 1;
        cfg.agent_cfg.en_logger.txn_column.data_time = 1;
        cfg.agent_cfg.en_logger.txn_column.resp = 1;
        cfg.agent_cfg.en_logger.txn_column.resp_time = 1;
        cfg.agent_cfg.en_logger.txn_column.len = 1;
        cfg.agent_cfg.en_logger.txn_column.burst_type = 1;
        cfg.agent_cfg.en_logger.txn_column.burst_size = 1;
        cfg.agent_cfg.en_logger.txn_column.addr_user = 1;
        cfg.agent_cfg.en_logger.txn_column.data_user = 1;
        cfg.agent_cfg.en_logger.txn_column.resp_user = 1;
        cfg.agent_cfg.en_logger.beat_column.id = 1;
        cfg.agent_cfg.en_logger.beat_column.valid_time = 1;
        cfg.agent_cfg.en_logger.beat_column.ready_time = 1;
        cfg.agent_cfg.en_logger.beat_column.dir_ph = 1;
        cfg.agent_cfg.en_logger.beat_column.addr = 1;
        cfg.agent_cfg.en_logger.beat_column.beat_num = 1;
        cfg.agent_cfg.en_logger.beat_column.len = 1;
        cfg.agent_cfg.en_logger.beat_column.strb = 1;
        cfg.agent_cfg.en_logger.beat_column.data = 1;
        cfg.agent_cfg.en_logger.beat_column.resp = 1;
        cfg.agent_cfg.en_logger.beat_column.last = 1;
        cfg.agent_cfg.en_logger.beat_column.burst_type = 1;
        cfg.agent_cfg.en_logger.beat_column.burst_size = 1;
        cfg.agent_cfg.en_logger.beat_column.lock = 1;
        cfg.agent_cfg.en_logger.beat_column.cache = 1;
        cfg.agent_cfg.en_logger.beat_column.prot = 1;
        cfg.agent_cfg.en_logger.beat_column.qos = 1;
        cfg.agent_cfg.en_logger.beat_column.region = 1;
        cfg.agent_cfg.en_logger.beat_column.addr_user = 1;
        cfg.agent_cfg.en_logger.beat_column.data_user = 1;
        cfg.agent_cfg.en_logger.beat_column.resp_user = 1;
        // Transaction logger data mask
        cfg.agent_cfg.en_logger.txn_data_mask = 1;
        // Beat logger data mask
        cfg.agent_cfg.en_logger.beat_data_mask = 1;
        // Enable clock period change logging
        cfg.agent_cfg.en_logger.clk_mon = 0;
        // Enable error reporting in logger
        cfg.agent_cfg.en_logger.en_assertions_log = 0;
        // Enable scoreboard
        cfg.agent_cfg.en_sb = 1;
        // Enable transaction listener
        cfg.agent_cfg.en_txn_ltnr = 1'b0;
        // Enable generic payload adapter
        cfg.agent_cfg.en_rw_adapter = 1'b0;
        cfg.agent_cfg.en_perf_stats.enable = 0;
        cfg.agent_cfg.en_perf_stats.step = 100;
        cfg.agent_cfg.en_perf_stats.multiple = 5;
        cfg.agent_cfg.en_debug.master_seq = 1'b0;
        cfg.agent_cfg.en_debug.slave_seq = 1'b0;
        cfg.agent_cfg.en_debug.vip_config = 1'b0;
        //
        // VIP Config setup configurations:
        //
        if ( addrm != null )
        begin
            cfg.addr_map = addrm;
        end
        cfg.master_delay = new();
        cfg.master_delay.set_config( cfg );
        if ( addrm != null )
        begin
            cfg.master_delay.set_address_map( addrm );
        end
        cfg.master_delay.set_ready_delay_mode( .random_delay(1'b0), .valid2ready(1'b1));
        
        
        
        
        
        cfg.cov_enable.raddr_user = 1'b0;
        cfg.cov_enable.wdata_user = 1'b0;
        cfg.cov_enable.wresp_user = 1'b0;
        cfg.cov_enable.waddr_user = 1'b0;
        cfg.cov_enable.rdata_user = 1'b0;
        //
        // VIP Config setup configurations at default value:
        //    // Slave ID
        //    cfg.slave_id = -1;
        //    // Enable ready control
        //    cfg.en_ready_control = 0;
        //    // Enable warning for uninitialized reads
        //    cfg.m_warn_on_uninitialized_read = 1'b0;
        //    // Enable FIXED burst transactions to access normal sequential memory
        //    cfg.m_fixed_burst_mem_norm = 1'b0;
        //    // Maximum write or read ID bin count in coverage
        //    cfg.config_id_cov_bin_count = 16;
        //    // Delete the scoreboard/slave memory on reset.
        //    cfg.m_delete_memory_on_reset = 0;
        //
        
        //
        // BFM setup configurations:
        //
        //
        //
        // Read interleaving depth
        cfg.m_bfm.config_rd_interleave_depth = 1073741824;
        // AWUSER signal width configuration
        cfg.m_bfm.config_awuser_width = 4;
        // WUSER signal width configuration
        cfg.m_bfm.config_wuser_width = 4;
        // ARUSER signal width configuration
        cfg.m_bfm.config_aruser_width = 4;
        // RUSER signal width configuration
        cfg.m_bfm.config_ruser_width = 4;
        // BUSER signal width configuration
        cfg.m_bfm.config_buser_width = 4;
        //
        // BFM setup configurations at default value:
        //    // Write address before data weight
        //    cfg.m_bfm.config_write_ctrl_first_ratio = 1;
        //    // Write data before address weight
        //    cfg.m_bfm.config_write_data_first_ratio = 0;
        //    // Set all write strobes enabled
        //    cfg.m_bfm.config_set_all_write_strobes = 1'b0;
        //    // Enable optional RLAST signal
        //    cfg.m_bfm.config_enable_rlast = 1'b1;
        //    // Enable ID signals
        //    cfg.m_bfm.config_enable_id = 1'b1;
        //    // Enable all protocol assertions
        //    cfg.m_bfm.config_enable_all_assertions = 1'b1;
        //    // Enable individual protocol assertion
        //    cfg.m_bfm.config_enable_assertion = 216'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        //    // Enable user sideband signals
        //    cfg.m_bfm.config_enable_user_sideband = 1'b1;
        //    // Enable burst reserved value
        //    cfg.m_bfm.config_enable_burst_reserved_value = 1'b0;
        //    // Enable warning messages from bfm
        //    cfg.m_bfm.config_enable_warnings = 1'b1;
        //    // Enable error on unexpected assertion of VALID signal
        //    cfg.m_bfm.config_error_on_deleted_valid_cycles = 1'b1;
        //    // Enable exclusive transaction support
        //    cfg.m_bfm.config_enable_slave_exclusive = 1'b1;
        //    // Read data reordering depth
        //    cfg.m_bfm.config_read_data_reordering_depth = 16;
        //    // Read number of beats to be interleaved
        //    cfg.m_bfm.config_rd_num_interleave_beats = 1;
        //    // Assert WREADY only after receiving the corresponding address phase
        //    cfg.m_bfm.config_wready_after_addr = 0;
        //    // Assert AWREADY only after both AWVALID and WVALID are asserted
        //    cfg.m_bfm.config_awready_after_wvalid = 0;
        //    // Assert AWREADY only after WREADY are asserted
        //    cfg.m_bfm.config_awready_after_wdata = 0;
        //    // Timeout for complete Read/Write transaction
        //    cfg.m_bfm.config_max_transaction_time_factor = 100000;
        //    // Burst timeout between individual phases of a transaction
        //    cfg.m_bfm.config_burst_timeout_factor = 10000;
        //    // Timeout from AWVALID to AWREADY assertion
        //    cfg.m_bfm.config_max_latency_AWVALID_assertion_to_AWREADY = 10000;
        //    // Timeout from ARVALID to ARREADY assertion
        //    cfg.m_bfm.config_max_latency_ARVALID_assertion_to_ARREADY = 10000;
        //    // Timeout from RVALID to RREADY assertion
        //    cfg.m_bfm.config_max_latency_RVALID_assertion_to_RREADY = 10000;
        //    // Timeout from BVALID to BREADY assertion
        //    cfg.m_bfm.config_max_latency_BVALID_assertion_to_BREADY = 10000;
        //    // Timeout from WVALID to WREADY assertion
        //    cfg.m_bfm.config_max_latency_WVALID_assertion_to_WREADY = 10000;
        //    // Enable assertion for Non-OKAY response
        //    cfg.m_bfm.config_enable_assertions_on_error_response = 1'b0;
        //    // Enable quality of service support
        //    cfg.m_bfm.config_enable_qos = 1'b1;
        //    // Enable address region support
        //    cfg.m_bfm.config_enable_region_support = 1'b0;
        //    // Set number of slave address regions
        //    cfg.m_bfm.config_slave_regions = 16;
        //    // Set slave address regions
        //    cfg.m_bfm.config_region = 2128'h0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        //    // Disable ready phase analysis to improve performance
        //    cfg.m_bfm.config_protect_ready = 1'b1;
        //    // Config enable error injection
        //    cfg.m_bfm.config_error_inj = '{AXI4_ERR_INJ_NONE,'{32{1'b0}}};
        //    cfg.m_bfm.config_clk_init_value = 1'b0;
        //    cfg.m_bfm.config_clk_phase_shift = QUESTA_MVC::questa_mvc_sv_convert_to_precision(5000, QUESTA_MVC::QUESTA_MVC_TIME_X);
        //    cfg.m_bfm.config_clk_1st_time = QUESTA_MVC::questa_mvc_sv_convert_to_precision(5000, QUESTA_MVC::QUESTA_MVC_TIME_X);
        //    cfg.m_bfm.config_clk_2nd_time = QUESTA_MVC::questa_mvc_sv_convert_to_precision(5000, QUESTA_MVC::QUESTA_MVC_TIME_X);
        //    cfg.m_bfm.config_reset_low_clocks = 5;
        //    cfg.m_bfm.config_reset_hold_time = QUESTA_MVC::questa_mvc_sv_convert_to_precision(0, QUESTA_MVC::QUESTA_MVC_TIME_X);
        //    // Configures maximum outstanding reads
        //    cfg.m_bfm.config_num_max_outstanding_reads = -1;
        //    // Configures maximum outstanding writes
        //    cfg.m_bfm.config_num_max_outstanding_writes = -1;
        //    // Configures checking addr in addr_map
        //    cfg.m_bfm.check_addr_map = AXI4_CHK_LEGAL;
        //
        
    endfunction: configure
    
endclass: axi4_master_0_config_policy

