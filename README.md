# 🧩 AMBA APB Protocol v2

header_banner: "APB.png"

project_info:
  title: "Advanced Microcontroller Bus Architecture – APB Version 2"
  developed_by: "Fares Wael Mohamed Mahmoud Hegazi"
  language: "Verilog HDL"
  toolchain: "Vivado 2023.1"
  target_fpga: "Basys3 (Xilinx Artix-7)"

---

project_overview:
  description: >
    The AMBA APB Protocol v2 provides a lightweight and low-power interface to connect peripherals 
    (UART, GPIO, Timers, etc.) with a CPU through the AHB–APB bridge.
    This implementation focuses on modular Verilog design, testbench verification, and FPGA synthesis.

---

project_specifications:
  FPGA_Board: "Basys3 (Xilinx Artix-7 XC7A35T)"
  Clock_Frequency: "50 MHz"
  Data_Bus_Width: "32 bits"
  Address_Bus_Width: "32 bits"
  Simulation_Tool: "Vivado Simulator"
  Target_Device: "Embedded peripherals simulation"
  Protocol_Version: "AMBA APB v2"
  Reset_Type: "Active Low"
  note: "You can edit this table if you change the clock or FPGA board."

---

system_architecture:
  description: >
    CPU → AHB Bus → APB Bus → Peripherals (UART, GPIO, Timer…)
  explanation: >
    Instead of making the CPU directly handle every peripheral, 
    the APB manages those communications to reduce CPU load and power consumption 
    while maintaining efficient data transfer.

---

implemented_modules:
  - module: "AMBA_APB_PROTOCOL_BUS.v"
    functionality: "Implements the bus protocol logic, state transitions, and control signals."
  - module: "AMBA_APB_SLAVE.v"
    functionality: "Simulates peripheral behavior, data memory, and response generation."
  - module: "AMBA_APB_TOP.v"
    functionality: "Integrates master and slave modules into a single connected system."
  - module: "AMBA_APB_TB.v"
    functionality: "Testbench used for functional verification and waveform generation."

---

main_signals:
  - signal: "PCLK"
    direction: "Input"
    width: "1 bit"
    description: "APB clock"
  - signal: "PRESETn"
    direction: "Input"
    width: "1 bit"
    description: "Active-low reset"
  - signal: "PSEL"
    direction: "Output"
    width: "1 bit"
    description: "Slave select signal"
  - signal: "PENABLE"
    direction: "Output"
    width: "1 bit"
    description: "Indicates access phase"
  - signal: "PWRITE"
    direction: "Output"
    width: "1 bit"
    description: "1 = Write, 0 = Read"
  - signal: "PADDR"
    direction: "Output"
    width: "32 bits"
    description: "Address line"
  - signal: "PWDATA"
    direction: "Output"
    width: "32 bits"
    description: "Write data line"
  - signal: "PRDATA"
    direction: "Input"
    width: "32 bits"
    description: "Read data line"
  - signal: "PREADY"
    direction: "Input"
    width: "1 bit"
    description: "Slave ready signal"
  - signal: "PSLVERR"
    direction: "Input"
    width: "1 bit"
    description: "Slave error indicator"

---

block_diagram:
  ascii_diagram: |
            ┌──────────────────────────────┐
            │      AMBA_APB_TB (Testbench) │
            │   • Stimulus + Verification  │
            └──────────────▲──────────────┘
                           │
            ┌──────────────────────────────┐
            │        AMBA_APB_TOP          │
            │   • Connects BUS & SLAVE     │
            └────────────▲────────────┘
                  ▲              ▲
                  │              │
 ┌──────────────────────────┐    ┌──────────────────────────┐
 │ AMBA_APB_PROTOCOL_BUS    │    │     AMBA_APB_SLAVE       │
 │ • State machine logic    │    │ • Data storage + error   │
 │ • Controls handshake     │    │ • Responds to access     │
 └──────────────────────────┘    └──────────────────────────┘
  image: "images/apb_block_diagram.png"

---

file_structure: |
  ├── src/
  │ ├── AMBA_APB_PROTOCOL_BUS.v
  │ ├── AMBA_APB_SLAVE.v
  │ ├── AMBA_APB_TOP.v
  │ └── AMBA_APB_TB.v
  │
  ├── constraints/
  │ └── basys3_debug.xdc
  │
  ├── simulation/
  │ ├── waveform_results.vcd
  │ └── test_logs.txt
  │
  ├── images/
  │ ├── header_banner.png
  │ ├── apb_block_diagram.png
  │ ├── elaboration_design.png
  │ ├── synthesis_design.png
  │ ├── implementation_design.png
  │ ├── write_waveform_full.png
  │ ├── read_waveform_full.png
  │ ├── error_waveform_full.png
  │ ├── waveform_snippet1.png
  │ ├── waveform_snippet2.png
  │ ├── waveform_snippet3.png
  │ └── fpga_demo_photo.jpg
  │
  └── README.md

---

design_flow:
  elaboration:
    description: "Checks design hierarchy and module connectivity."
    image: "images/elaboration_design.png"
  synthesis:
    description: "Converts RTL into a gate-level representation, showing logic utilization and timing."
    image: "images/synthesis_design.png"
  implementation:
    description: "Performs placement, routing, and timing optimization for FPGA deployment."
    image: "images/implementation_design.png"

---

simulation_results:
  write_transaction: 
    steps: 
      - "Master asserts PWRITE = 1 and PSEL"
      - "Data transferred via PWDATA"
      - "PREADY goes high indicating successful write"
  read_transaction:
    steps:
      - "Master sets PWRITE = 0"
      - "Slave drives PRDATA with requested data"
      - "PREADY indicates valid read"
  error_case:
    steps:
      - "Invalid address or out-of-range access triggers PSLVERR = 1"

---

waveform_outputs:
  full_waveforms:
    - "images/write_waveform_full.png"
    - "images/read_waveform_full.png"
    - "images/error_waveform_full.png"
  snippets:
    - "images/waveform_snippet1.png"
    - "images/waveform_snippet2.png"
    - "images/waveform_snippet3.png"

---

fpga_setup:
  - io: "PCLK"
    fpga_pin: "W5"
    description: "50 MHz system clock"
  - io: "PRESETn"
    fpga_pin: "U18"
    description: "Active-low reset"
  - io: "PSEL"
    fpga_pin: "V17"
    description: "Slave select switch"
  - io: "PENABLE"
    fpga_pin: "V16"
    description: "Transfer enable"
  - io: "PWRITE"
    fpga_pin: "W16"
    description: "Write/Read control"
  - io: "PRDATA[3:0]"
    fpga_pin: "LEDs [3:0]"
    description: "Display read data"
  - io: "PSLVERR"
    fpga_pin: "E19"
    description: "Error LED"
  - io: "PREADY"
    fpga_pin: "U16"
    description: "Ready indicator"
  note: "All defined in constraints/basys3_debug.xdc."

---

tools_used:
  - tool: "Vivado 2023.1"
    purpose: "Design, synthesis, implementation, simulation"
  - tool: "GTKWave"
    purpose: "Waveform analysis"
  - tool: "Basys3 Board"
    purpose: "FPGA testing platform"
  - tool: "Verilog HDL"
    purpose: "Hardware description language"

---

how_to_run:
  steps:
    - step: "Clone Repository"
      command: |
        git clone https://github.com/<your-username>/AMBA_APB_Protocol_v2.git
        cd AMBA_APB_Protocol_v2
    - step: "Open in Vivado"
      instructions: |
        Create a new project
        Add all .v files under /src
        Include basys3_debug.xdc from /constraints
    - step: "Run Simulation"
      instructions: |
        Open AMBA_APB_TB.v
        Run behavioral simulation
        Observe signals PADDR, PWDATA, PRDATA, PREADY, and PSLVERR
    - step: "Synthesize and Implement"
      instructions: |
        Generate bitstream
        Program the Basys3 board
        Observe LEDs and switches to test read/write responses

  hardware_demo:
    image: "images/fpga_demo_photo.jpg"

---

author:
  name: "Fares Wael Mohamed Mahmoud Hegazi"
  title: "Communication & Electronics Engineering Student – ECE 200"
  roles: "Digital IC Design | Verilog Developer | Hardware Instructor"
  contact: "[Add your email or GitHub link here]"

---

license:
  type: "MIT License"
  description: "Free to use and modify with credit."

---

future_enhancements:
  - "Support for multiple slave devices"
  - "Integration with AHB bridge for full SoC communication"
  - "Parameterized timing control"
  - "Graphical transaction visualizer"

---

quote: "Design efficiently. Simulate precisely. Debug intelligently. – Fares Hegazi"
