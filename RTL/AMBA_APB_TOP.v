module TOP #(
    parameter ADDR_SIZE = 32,
    DATA_SIZE = 32,
    PROT_SIZE = 3,
    STRB_SIZE = DATA_SIZE/8
) (
    input PCLK,
    input PRESETn,

    // INPUTS FROM CPU (MAIN MASTER)
    input MWRITE,
    input [PROT_SIZE-1:0] MPROT,
    input [ADDR_SIZE-1:0] MADDR,
    input [DATA_SIZE-1:0] MWDATA,
    input [STRB_SIZE-1:0] MSTRB,

    // OUTPUTS BACK TO CPU
    output [DATA_SIZE-1:0] MRDATA,
    output MSLVERR
);

    // SLAVE --> APB
    wire TREADY;
    wire TSLVERR;
    wire [DATA_SIZE-1:0] TRDATA;

    // APB --> SLAVE
    wire TSELx;
    wire TENABLE;
    wire TWRITE;
    wire [ADDR_SIZE-1:0] TADDR;
    wire [DATA_SIZE-1:0] TWDATA;
    wire [PROT_SIZE-1:0] TPROT;
    wire [STRB_SIZE-1:0] TSTRB;

    AMBA_APB_PROTOCOL_BUS #(
        .ADDR_SIZE(ADDR_SIZE),
        .DATA_SIZE(DATA_SIZE),
        .PROT_SIZE(PROT_SIZE),
        .STRB_SIZE(STRB_SIZE)
    ) APB_Protocol_Bus (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PREADY(TREADY),
        .PSLVERR(TSLVERR),
        .PRDATA(TRDATA),

        .PSELX(TSELx),
        .PENABLE(TENABLE),
        .PWRITE(TWRITE),
        .PADDR(TADDR),
        .PWDATA(TWDATA),
        .PPROT(TPROT),
        .PSTRB(TSTRB),

        .MWRITE(MWRITE),
        .MPROT(MPROT),
        .MADDR(MADDR),
        .MWDATA(MWDATA),
        .MSTRB(MSTRB),

        .MRDATA(MRDATA),
        .MSLVERR(MSLVERR)
    );

    APB_Slave #(
        .ADDR_SIZE(ADDR_SIZE),
        .MEM_WIDTH(DATA_SIZE),
        .PROT_SIZE(PROT_SIZE)
    ) APB_Slave_Inst (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .SSELX(TSELx),
        .SENABLE(TENABLE),
        .SREADY(TREADY),
        .SWRITE(TWRITE),
        .SADDR(TADDR),
        .SWDATA(TWDATA),
        .SPROT(TPROT),
        .SSTRB(TSTRB),
        .SSLVERR(TSLVERR),
        .SRDATA(TRDATA)
    );

endmodule