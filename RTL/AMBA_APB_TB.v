module AMBA_APB_PROTOCOL_TB ();

    //--------------------------------------------------
    // Parameters
    //--------------------------------------------------
    parameter ADDR_SIZE = 32;           // Address bus width
    parameter DATA_SIZE = 32;           // Data bus width
    parameter PROT_SIZE = 3;            // Protection attributes width
    parameter STRB_SIZE = DATA_SIZE/8;  // Write strobes (per byte)

    //--------------------------------------------------
    // Clock and Reset
    //--------------------------------------------------
    reg PCLK;
    reg PRESETn;

    //--------------------------------------------------
    // INPUTS FROM CPU (MAIN MASTER)
    //--------------------------------------------------
    reg MWRITE;                        
    reg [PROT_SIZE-1:0] MPROT;         
    reg [ADDR_SIZE-1:0] MADDR;         
    reg [DATA_SIZE-1:0] MWDATA;        
    reg [STRB_SIZE-1:0] MSTRB;         

    //--------------------------------------------------
    // OUTPUTS BACK TO CPU
    //--------------------------------------------------
    wire [DATA_SIZE-1:0] MRDATA;       
    wire MSLVERR;                      

    //--------------------------------------------------
    // Instantiate the TOP module
    //--------------------------------------------------
    TOP #(
        .ADDR_SIZE(ADDR_SIZE),
        .DATA_SIZE(DATA_SIZE),
        .PROT_SIZE(PROT_SIZE),
        .STRB_SIZE(STRB_SIZE)
    ) dut (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .MWRITE(MWRITE),
        .MPROT(MPROT),
        .MADDR(MADDR),
        .MWDATA(MWDATA),
        .MSTRB(MSTRB),
        .MRDATA(MRDATA),
        .MSLVERR(MSLVERR)
    );

    //--------------------------------------------------
    // Clock Generation
    //--------------------------------------------------
    initial begin
        PCLK = 0;
        forever #5 PCLK = ~PCLK;  // 10 time units clock period
    end

// ==============================
// Stimulus process
// ==============================
initial begin

    // Initial reset and default values
    PRESETn   = 0;
    MPROT     = 0;
    MSTRB     = 0;
    MADDR     = 0;
    MWDATA    = 0;
    MWRITE    = 0;
    repeat (2) @(negedge PCLK);

    // Release reset
    PRESETn   = 1;

    // ==============================
    // Test 1: Write full word at address 2
    // ==============================
    MPROT     = 3'b011;
    MSTRB     = 4'b1111; 
    MADDR     = 2;
    MWDATA    = 32'h1234567;
    MWRITE    = 1;
    repeat (3) @(negedge PCLK);

    // ==============================
    // Test 2: Write full word at address 3
    // ==============================
    MADDR     = 3;
    MWDATA    = 32'h89ABCDEF;
    repeat (3) @(negedge PCLK);

    // ==============================
    // Test 3: Write full word at address 4
    // ==============================
    MADDR     = 4;
    MWDATA    = 32'h754123;
    repeat (3) @(negedge PCLK);

    // ==============================
    // Test 4: Write with partial strobe (upper 3 bytes)
    // ==============================
    MPROT     = 3'b001;
    MSTRB     = 4'b1110;
    MADDR     = 5;
    MWDATA    = 32'h78254535;
    repeat (3) @(negedge PCLK);

    // ==============================
    // Test 5: Write with different strobe (lower 2 bytes)
    // ==============================
    MPROT     = 3'b001;
    MSTRB     = 4'b0011;
    MADDR     = 6;
    MWDATA    = 32'h78254535;
    repeat (3) @(negedge PCLK);

    // ==============================
    // Test 6: Read back from addresses 5 and 6
    // ==============================
    MWRITE    = 0;
    MADDR     = 5;
    repeat (2) @(negedge PCLK);
    MADDR     = 6;
    repeat (2) @(negedge PCLK);

    // ==============================
    // Test 7: Write outside valid range => expect error
    // ==============================
    MWRITE    = 1;
    MADDR     = 35;
    MWDATA    = 32'h754113;
    repeat (3) @(negedge PCLK);

    // ==============================
    // Test 8: Read outside valid range => expect error
    // ==============================
    MWRITE    = 0;
    MADDR     = 60;
    repeat (3) @(negedge PCLK);

    // ==============================
    // Test 9: Force wait states
    // ==============================
    MADDR     = 5;
    force dut.APB_Protocol_Bus.PREADY = 0; // Slave not ready
    repeat (8) @(negedge PCLK);

    // Release wait state and continue
    release dut.APB_Protocol_Bus.PREADY;
    repeat (5) begin
        MWRITE  = 0;
        MADDR   = 5;
        repeat (2) @(negedge PCLK);
    end

    // End simulation
    $stop;
end
endmodule