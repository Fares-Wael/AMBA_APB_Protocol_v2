//======================================================
// AMBA APB Protocol Bus (Bridge)
// Author : Fares Hegazi
// Description:
//   - This module implements an APB Master (Bridge) 
//     that interfaces between a CPU (main master) and 
//     APB slaves (peripherals).
//   - FSM states: IDLE → SETUP → ACCESS
//   - Handles read/write transfers according to 
//     AMBA APB protocol specification.
//======================================================

module AMBA_APB_PROTOCOL_BUS #(
    // FSM State Encoding
    parameter IDLE    = 2'b00,
    parameter SETUP   = 2'b01,
    parameter ACCESS  = 2'b10,

    // Configurable Sizes
    parameter ADDR_SIZE = 32,           // Address bus width
    parameter DATA_SIZE = 32,           // Data bus width
    parameter PROT_SIZE = 3,            // Protection attributes width
    parameter STRB_SIZE = DATA_SIZE/8   // Write strobes (per byte)
) (
    //--------------------------------------------------
    // INPUTS FROM SLAVE TO MASTER
    //--------------------------------------------------
    input PCLK,                         // APB Clock
    input PRESETn,                      // Active-low Reset
    input PREADY,                       // Slave ready
    input PSLVERR,                      // Slave error
    input [DATA_SIZE-1:0] PRDATA,       // Data read from slave

    //--------------------------------------------------
    // OUTPUTS TO SLAVE
    //--------------------------------------------------
    output reg PSELX,                   // Slave select
    output reg PENABLE,                 // Access phase enable
    output reg PWRITE,                  // Write control (1=write, 0=read)
    output reg [ADDR_SIZE-1:0] PADDR,   // Address to slave
    output reg [DATA_SIZE-1:0] PWDATA,  // Write data to slave
    output reg [PROT_SIZE-1:0] PPROT,   // Protection attributes
    output [STRB_SIZE-1:0] PSTRB,       // Write strobes

    //--------------------------------------------------
    // INPUTS FROM CPU (MAIN MASTER)
    //--------------------------------------------------
    input MWRITE,                       // Write control from CPU
    input [PROT_SIZE-1:0] MPROT,        // Protection attributes from CPU
    input [ADDR_SIZE-1:0] MADDR,        // Address from CPU
    input [DATA_SIZE-1:0] MWDATA,       // Write data from CPU
    input [STRB_SIZE-1:0] MSTRB,        // Write strobes from CPU

    //--------------------------------------------------
    // OUTPUTS BACK TO CPU
    //--------------------------------------------------
    output [DATA_SIZE-1:0] MRDATA,      // Read data to CPU
    output MSLVERR                      // Error signal to CPU
);

    //--------------------------------------------------
    // FSM State Registers
    //--------------------------------------------------
    reg [1 : 0] cs, ns;                 // cs=current state, ns=next state

    //--------------------------------------------------
    // Transfer Detection Logic
    // Checks if new request from CPU differs from
    // current signals (address, data, protection, write)
    //--------------------------------------------------
    wire Transfer;
    assign Transfer = (PPROT  != MPROT)  || 
                      (PADDR  != MADDR)  || 
                      (PWDATA != MWDATA) || 
                      (PWRITE != MWRITE);

    //--------------------------------------------------
    // STATE MEMORY (Sequential Block)
    //--------------------------------------------------
    always @(posedge PCLK) begin
        if (!PRESETn) 
            cs <= IDLE;                 // On reset → go to IDLE
        else 
            cs <= ns;                   // Otherwise → update current state
    end

    //--------------------------------------------------
    // NEXT STATE LOGIC (Combinational)
    //--------------------------------------------------
    always @(*) begin
        case (cs)
            IDLE: begin
                if (Transfer)           // New transfer detected
                    ns = SETUP;         // Move to SETUP
                else
                    ns = IDLE;          // Stay in IDLE
            end

            SETUP: begin
                ns = ACCESS;            // Always move to ACCESS next
            end

            ACCESS: begin
                if (PREADY) begin       // Slave ready
                    if (Transfer)       // If another transfer is pending
                        ns = SETUP;     // Go to SETUP
                    else
                        ns = IDLE;      // Otherwise back to IDLE
                end else begin
                    ns = ACCESS;        // Stay until slave ready
                end
            end

            default: ns = IDLE;         // Safety fallback
        endcase    
    end

    //--------------------------------------------------
    // OUTPUT LOGIC for PSEL & PENABLE
    //--------------------------------------------------
    always @(*) begin
        case (cs)
            IDLE: begin
                PSELX   = 1'b0;         // No slave selected
                PENABLE = 1'b0;         // No access
            end
            SETUP: begin
                PSELX   = 1'b1;         // Select slave
                PENABLE = 1'b0;         // Not yet in access phase
            end
            ACCESS: begin
                PSELX   = 1'b1;         // Keep slave selected
                PENABLE = 1'b1;         // Access phase active
            end
        endcase
    end

    //--------------------------------------------------
    // REGISTER Address, Data, Control during SETUP
    // Latch master signals only in SETUP phase
    //--------------------------------------------------
    always @(posedge PCLK) begin
        if (!PRESETn) begin
            PWRITE <= 0;
            PPROT  <= 0;
            PWDATA <= 0;
            PADDR  <= 0;
        end else begin
            if (ns == SETUP) begin
                PWRITE <= MWRITE;
                PPROT  <= MPROT;
                PWDATA <= MWDATA;
                PADDR  <= MADDR;
            end
        end
    end

    //--------------------------------------------------
    // STRB Assignment (for partial writes)
    //--------------------------------------------------
    assign PSTRB   = PWRITE ? MSTRB : {STRB_SIZE{1'b0}};

    //--------------------------------------------------
    // CPU Outputs
    //--------------------------------------------------
    assign MRDATA  = PRDATA;   // Data read from slave → CPU
    assign MSLVERR = PSLVERR;  // Error from slave → CPU

endmodule
