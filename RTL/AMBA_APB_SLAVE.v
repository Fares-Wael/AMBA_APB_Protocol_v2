//======================================================
// APB Slave Module
// Author : Fares Hegazi
// Description:
//   - Simple APB slave with 32-bit address/data
//   - Uses STRB_WDATA for partial write
//   - Error if address out of range or invalid data
//======================================================

module APB_Slave #(
    parameter ADDR_SIZE = 32,             // Address bus width (APB standard)
    parameter MEM_WIDTH = 32,             // Data bus width
    parameter PROT_SIZE = 3,              // Protection width
    localparam STRB_SIZE = MEM_WIDTH/8    // Write strobes per byte
) (
    //--------------------------------------------------
    // System
    input PCLK,
    input PRESETn,

    //--------------------------------------------------
    // Inputs from APB Master
    input SENABLE,                        // Access phase enable
    input SWRITE,                         // Write control
    input SSELX,                          // Slave select
    input [PROT_SIZE-1:0] SPROT,          // Protection attributes
    input [STRB_SIZE-1:0] SSTRB,          // Write strobes
    input [ADDR_SIZE-1:0] SADDR,          // Address
    input [MEM_WIDTH-1:0] SWDATA,         // Write data

    //--------------------------------------------------
    // Outputs back to APB Master
    output reg SREADY,                    // Ready signal
    output reg SSLVERR,                   // Error signal
    output reg [MEM_WIDTH-1:0] SRDATA     // Read data
);

    //--------------------------------------------------
    // Internal memory (depth = ADDR_SIZE locations)
    //--------------------------------------------------
    reg [MEM_WIDTH-1:0] mem [ADDR_SIZE-1:0];

    //--------------------------------------------------
    // Masked Write Data (STRB_WDATA)
    //--------------------------------------------------
    wire [MEM_WIDTH-1:0] STRB_WDATA;
    assign STRB_WDATA = (SWDATA & { {8{SSTRB[3]}}, {8{SSTRB[2]}}, {8{SSTRB[1]}}, {8{SSTRB[0]}} });

    //--------------------------------------------------
    // Enable condition
    //--------------------------------------------------
    wire en_mem = SSELX & SENABLE;

    //--------------------------------------------------
    // Ready signal
    //--------------------------------------------------
    always @(*) begin
        SREADY = en_mem;
    end

    //--------------------------------------------------
    // Error generation logic
    //--------------------------------------------------
    always @(*) begin
        if (SSELX && SENABLE && SREADY) begin
            if (SADDR > (ADDR_SIZE-1)) begin
                SSLVERR = 1'b1;   // Address out of range
            end
            else if (SWDATA > {MEM_WIDTH{1'b1}}) begin
                SSLVERR = 1'b1;   // Data exceeds width
            end
            else begin
                SSLVERR = 1'b0;   // No error
            end
        end
    end

    //--------------------------------------------------
    // Memory Read/Write logic
    //--------------------------------------------------
    always @(posedge PCLK) begin
        if (!PRESETn) begin
            SRDATA <= 0;
        end else if (en_mem & ~SSLVERR) begin
            if (SWRITE) begin
                // Write with strobes
                mem[SADDR] <= STRB_WDATA;
            end else begin
                // Read
                SRDATA <= mem[SADDR];
            end
        end
    end

endmodule
