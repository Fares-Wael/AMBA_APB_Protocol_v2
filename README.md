# 🧩 AMBA APB Protocol v2

Header_Banner: "images/header_banner.png"

Project_Info:
  Title: "Advanced Microcontroller Bus Architecture – APB Version 2"
  Developed_By: "Fares Wael Mohamed Mahmoud Hegazi"
  Language: "Verilog HDL"
  Toolchain: "Vivado 2023.1"
  Target_FPGA: "Basys3 (Xilinx Artix-7)"

---

Project_Overview:
  Summary: "Lightweight, low-power bus interface for connecting peripherals (UART, GPIO, Timers, etc.) with a CPU via the AHB–APB bridge."
  Focus: "Modular Verilog design, testbench verification, and FPGA synthesis."

---

Project_Specifications:
  | Parameter           | Value                                  |
  |---------------------|----------------------------------------|
  | FPGA Board          | Basys3 (Xilinx Artix-7 XC7A35T)        |
  | Clock Frequency     | 50 MHz                                 |
  | Data Bus Width      | 32 bits                                |
  | Address Bus Width   | 32 bits                                |
  | Simulation Tool     | Vivado Simulator                       |
  | Target Device       | Embedded peripherals simulation         |
  | Protocol Version    | AMBA APB v2                            |
  | Reset Type          | Active Low                             |

---

System_Architecture:
  Description: "CPU → AHB Bus → APB Bus → Peripherals (UART, GPIO, Timer…)"
  Function: "Reduces CPU load and power consumption while maintaining efficient data transfer."

---

Implemented_Modules:
  | Module Name             | Functionality Summary                                       |
  |--------------------------|-------------------------------------------------------------|
  | AMBA_APB_PROTOCOL_BUS.v  | Implements protocol logic, state transitions, and controls. |
  | AMBA_APB_SLAVE.v         | Simulates peripheral behavior and response generation.      |
  | AMBA_APB_TOP.v           | Integrates master and slave into a single system.           |
  | AMBA_APB_TB.v            | Testbench for verification and waveform generation.         |

---

Main_Signals:
  | Signal    | Direction | Width    | Description             |
  |------------|------------|----------|--------------------------|
  | PCLK      | Input     | 1 bit    | APB clock               |
  | PRESETn   | Input     | 1 bit    | Active-low reset        |
  | PSEL      | Output    | 1 bit    | Slave select signal     |
  | PENABLE   | Output    | 1 bit    | Indicates access phase  |
  | PWRITE    | Output    | 1 bit    | 1 = Write, 0 = Read     |
  | PADDR     | Output    | 32 bits  | Address line            |
  | PWDATA    | Output    | 32 bits  | Write data line         |
  | PRDATA    | Input     | 32 bits  | Read data line          |
  | PREADY    | Input     | 1 bit    | Slave ready signal      |
  | PSLVERR   | Input     | 1 bit    | Slave error indicator   |

---

Block_Diagram:
  Diagram: |
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
  Image: "images/apb_block_diagram.png"

---

File_Structure:
  | Folder         | Contents                                       |
  |----------------|------------------------------------------------|
  | src/           | AMBA_APB_PROTOCOL_BUS.v, SLAVE.v, TOP.v, TB.v  |
  | constraints/   | basys3_debug.xdc                               |
  | simulation/    | waveform_results.vcd, test_logs.txt            |
  | images/        | All waveform and diagram PNG files             |
  | README.md      | Main documentation file                        |

---

Design_Flow:
  | Stage         | Description                                                     | Screenshot                      |
  |----------------|-----------------------------------------------------------------|----------------------------------|
  | Elaboration   | Checks hierarchy and module connectivity.                       | images/elaboration_design.png    |
  | Synthesis     | Converts RTL to gate-level representation and timing.           | images/synthesis_design.png      |
  | Implementation| Placement, routing, and timing optimization for FPGA deployment.| images/implementation_design.png |

---

Simulation_Results:
  | Test Type       | Behavior Description                                            |
  |------------------|----------------------------------------------------------------|
  | Write Transaction| PWRITE=1, PSEL active, PREADY=1 indicates success.             |
  | Read Transaction | PWRITE=0, PRDATA valid, PREADY high indicates valid read.      |
  | Error Case       | Invalid address triggers PSLVERR=1.                            |

---

Waveform_Outputs:
  | Type          | Image Files                                      |
  |----------------|--------------------------------------------------|
  | Full Waveforms | write_waveform_full.png, read_waveform_full.png, error_waveform_full.png |
  | Snippets       | waveform_snippet1.png, waveform_snippet2.png, waveform_snippet3.png     |

---

FPGA_Setup:
  | I/O Signal    | FPGA Pin | Description             |
  |----------------|-----------|--------------------------|
  | PCLK          | W5        | 50 MHz system clock     |
  | PRESETn       | U18       | Active-low reset        |
  | PSEL          | V17       | Slave select switch     |
  | PENABLE       | V16       | Transfer enable         |
  | PWRITE        | W16       | Write/Read control      |
  | PRDATA[3:0]   | LEDs [3:0]| Display read data       |
  | PSLVERR       | E19       | Error LED               |
  | PREADY        | U16       | Ready indicator         |

---

Tools_Used:
  | Tool             | Purpose                                    |
  |------------------|---------------------------------------------|
  | Vivado 2023.1    | Design, synthesis, implementation, simulation |
  | GTKWave          | Waveform analysis                          |
  | Basys3 Board     | FPGA testing platform                      |
  | Verilog HDL      | Hardware description language              |

---

How_To_Run:
  | Step | Description / Command                                                                                   |
  |-------|---------------------------------------------------------------------------------------------------------|
  | 1️⃣ Clone Repository | `git clone https://github.com/<your-username>/AMBA_APB_Protocol_v2.git` and `cd AMBA_APB_Protocol_v2` |
  | 2️⃣ Open in Vivado   | Create a new project → Add `/src` files → Add `/constraints/basys3_debug.xdc`              |
  | 3️⃣ Run Simulation   | Open `AMBA_APB_TB.v`, run behavioral simulation, observe PADDR, PWDATA, PRDATA, PREADY, PSLVERR |
  | 4️⃣ Implement & Test | Generate bitstream, program Basys3 board, observe LEDs and switches for read/write test.     |
  | 📸 Hardware Demo     | "images/fpga_demo_photo.jpg"                                                              |

---

Author_Info:
  | Field     | Details                                                                          |
  |------------|----------------------------------------------------------------------------------|
  | Name       | Fares Wael Mohamed Mahmoud Hegazi                                               |
  | Education  | Communication & Electronics Engineering Student – ECE 200                        |
  | Roles      | Digital IC Design, Verilog Developer, Hardware Instructor                        |
  | Contact    | [Add your email or GitHub link here]                                             |

---

License:
  | Type | Description                                  |
  |-------|----------------------------------------------|
  | MIT  | Free to use and modify with credit            |

---

Future_Enhancements:
  | Planned Feature                          |
  |------------------------------------------|
  | Support for multiple slave devices       |
  | Integration with AHB bridge              |
  | Parameterized timing control             |
  | Graphical transaction visualizer         |

---

Quote:
  "Design efficiently. Simulate precisely. Debug intelligently. – Fares Hegazi"
