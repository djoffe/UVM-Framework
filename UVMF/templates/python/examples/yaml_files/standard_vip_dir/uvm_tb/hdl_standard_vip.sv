//
// File: hdl_standard_vip.sv
//
// Generated from Mentor VIP Configurator (20230807)
// Generated using Mentor VIP Library ( 2023.3_1 : 08/18/2023:20:00 )
//
//Time resolution of '1ns' will be used (See Makefiles and scripts)
module hdl_standard_vip;
    import uvm_pkg::*;
    import standard_vip_params_pkg::*;
    wire                                                          default_clk_gen_CLK;
    wire                                                          default_reset_gen_RESET;
    wire                                                          axi4_master_0_AWVALID;
    wire [axi4_master_0_params::AXI4_ADDRESS_WIDTH-1:0]           axi4_master_0_AWADDR;
    wire [2:0]                                                    axi4_master_0_AWPROT;
    wire [3:0]                                                    axi4_master_0_AWREGION;
    wire [7:0]                                                    axi4_master_0_AWLEN;
    wire [((axi4_master_0_params::AXI4_WDATA_WIDTH==2048)?3:2):0] axi4_master_0_AWSIZE;
    wire [1:0]                                                    axi4_master_0_AWBURST;
    wire                                                          axi4_master_0_AWLOCK;
    wire [3:0]                                                    axi4_master_0_AWCACHE;
    wire [3:0]                                                    axi4_master_0_AWQOS;
    wire [axi4_master_0_params::AXI4_ID_WIDTH-1:0]                axi4_master_0_AWID;
    wire [axi4_master_0_params::AXI4_USER_WIDTH-1:0]              axi4_master_0_AWUSER;
    wire                                                          axi4_master_0_AWREADY;
    wire                                                          axi4_master_0_ARVALID;
    wire [axi4_master_0_params::AXI4_ADDRESS_WIDTH-1:0]           axi4_master_0_ARADDR;
    wire [2:0]                                                    axi4_master_0_ARPROT;
    wire [3:0]                                                    axi4_master_0_ARREGION;
    wire [7:0]                                                    axi4_master_0_ARLEN;
    wire [((axi4_master_0_params::AXI4_RDATA_WIDTH==2048)?3:2):0] axi4_master_0_ARSIZE;
    wire [1:0]                                                    axi4_master_0_ARBURST;
    wire                                                          axi4_master_0_ARLOCK;
    wire [3:0]                                                    axi4_master_0_ARCACHE;
    wire [3:0]                                                    axi4_master_0_ARQOS;
    wire [axi4_master_0_params::AXI4_ID_WIDTH-1:0]                axi4_master_0_ARID;
    wire [axi4_master_0_params::AXI4_USER_WIDTH-1:0]              axi4_master_0_ARUSER;
    wire                                                          axi4_master_0_ARREADY;
    wire                                                          axi4_master_0_RVALID;
    wire [axi4_master_0_params::AXI4_RDATA_WIDTH-1:0]             axi4_master_0_RDATA;
    wire [1:0]                                                    axi4_master_0_RRESP;
    wire                                                          axi4_master_0_RLAST;
    wire [axi4_master_0_params::AXI4_ID_WIDTH-1:0]                axi4_master_0_RID;
    wire [axi4_master_0_params::AXI4_USER_WIDTH-1:0]              axi4_master_0_RUSER;
    wire                                                          axi4_master_0_RREADY;
    wire                                                          axi4_master_0_WVALID;
    wire [axi4_master_0_params::AXI4_WDATA_WIDTH-1:0]             axi4_master_0_WDATA;
    wire [(axi4_master_0_params::AXI4_WDATA_WIDTH/8)-1:0]         axi4_master_0_WSTRB;
    wire                                                          axi4_master_0_WLAST;
    wire [axi4_master_0_params::AXI4_USER_WIDTH-1:0]              axi4_master_0_WUSER;
    wire                                                          axi4_master_0_WREADY;
    wire                                                          axi4_master_0_BVALID;
    wire [1:0]                                                    axi4_master_0_BRESP;
    wire [axi4_master_0_params::AXI4_ID_WIDTH-1:0]                axi4_master_0_BID;
    wire [axi4_master_0_params::AXI4_USER_WIDTH-1:0]              axi4_master_0_BUSER;
    wire                                                          axi4_master_0_BREADY;
    
    axi4_master 
    #(
        .ADDR_WIDTH(axi4_master_0_params::AXI4_ADDRESS_WIDTH),
        .RDATA_WIDTH(axi4_master_0_params::AXI4_RDATA_WIDTH),
        .WDATA_WIDTH(axi4_master_0_params::AXI4_WDATA_WIDTH),
        .ID_WIDTH(axi4_master_0_params::AXI4_ID_WIDTH),
        .USER_WIDTH(axi4_master_0_params::AXI4_USER_WIDTH),
        .REGION_MAP_SIZE(axi4_master_0_params::AXI4_REGION_MAP_SIZE),
        .IF_NAME("axi4_master_0"),
        .PATH_NAME("uvm_test_top")
    )
    axi4_master_0
    (
        .ACLK(default_clk_gen_CLK),
        .ARESETn(default_reset_gen_RESET),
        .AWVALID(axi4_master_0_AWVALID),
        .AWADDR(axi4_master_0_AWADDR),
        .AWPROT(axi4_master_0_AWPROT),
        .AWREGION(axi4_master_0_AWREGION),
        .AWLEN(axi4_master_0_AWLEN),
        .AWSIZE(axi4_master_0_AWSIZE),
        .AWBURST(axi4_master_0_AWBURST),
        .AWLOCK(axi4_master_0_AWLOCK),
        .AWCACHE(axi4_master_0_AWCACHE),
        .AWQOS(axi4_master_0_AWQOS),
        .AWID(axi4_master_0_AWID),
        .AWUSER(axi4_master_0_AWUSER),
        .AWREADY(axi4_master_0_AWREADY),
        .ARVALID(axi4_master_0_ARVALID),
        .ARADDR(axi4_master_0_ARADDR),
        .ARPROT(axi4_master_0_ARPROT),
        .ARREGION(axi4_master_0_ARREGION),
        .ARLEN(axi4_master_0_ARLEN),
        .ARSIZE(axi4_master_0_ARSIZE),
        .ARBURST(axi4_master_0_ARBURST),
        .ARLOCK(axi4_master_0_ARLOCK),
        .ARCACHE(axi4_master_0_ARCACHE),
        .ARQOS(axi4_master_0_ARQOS),
        .ARID(axi4_master_0_ARID),
        .ARUSER(axi4_master_0_ARUSER),
        .ARREADY(axi4_master_0_ARREADY),
        .RVALID(axi4_master_0_RVALID),
        .RDATA(axi4_master_0_RDATA),
        .RRESP(axi4_master_0_RRESP),
        .RLAST(axi4_master_0_RLAST),
        .RID(axi4_master_0_RID),
        .RUSER(axi4_master_0_RUSER),
        .RREADY(axi4_master_0_RREADY),
        .WVALID(axi4_master_0_WVALID),
        .WDATA(axi4_master_0_WDATA),
        .WSTRB(axi4_master_0_WSTRB),
        .WLAST(axi4_master_0_WLAST),
        .WUSER(axi4_master_0_WUSER),
        .WREADY(axi4_master_0_WREADY),
        .BVALID(axi4_master_0_BVALID),
        .BRESP(axi4_master_0_BRESP),
        .BID(axi4_master_0_BID),
        .BUSER(axi4_master_0_BUSER),
        .BREADY(axi4_master_0_BREADY)
    );
    default_clk_gen default_clk_gen
    (
        .CLK(default_clk_gen_CLK)
    );
    default_reset_gen default_reset_gen
    (
        .RESET(default_reset_gen_RESET),
        .CLK_IN(default_clk_gen_CLK)
    );

endmodule: hdl_standard_vip
