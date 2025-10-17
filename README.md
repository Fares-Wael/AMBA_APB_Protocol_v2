# 🧩 AMBA APB Protocol v2

Header_Banner: "images/header_banner.png"

Project_Info:
  Title: "📘 Advanced Microcontroller Bus Architecture – APB Version 2"
  Developed_By: "🧑‍💻 Fares Wael Mohamed Mahmoud Hegazi"
  Language: "💡 Verilog HDL"
  Toolchain: "🧰 Vivado 2023.1"
  Target_FPGA: "🖥️ Basys3 (Xilinx Artix-7)"

---

Project_Overview:
  Summary: >
    The **AMBA APB Protocol v2** offers a **lightweight and low-power communication bus**
    to connect peripherals like **UART**, **GPIO**, and **Timers** with a CPU through the **AHB–APB bridge**.
    This project focuses on modular Verilog design, testbench verification, and FPGA synthesis.
  Note: "🚀 Designed for efficiency, simplicity, and educational clarity."

---

Project_Specifications:
  Table:
    | 🔧 Parameter       | ⚙️ Value                                  |
    |--------------------|-------------------------------------------|
    | FPGA Board         | Basys3 (Xilinx Artix-7 XC7A35T)           |
    | Clock Frequency    | 50 MHz                                   |
    | Data Bus Width     | 32 bits                                  |
    | Address Bus Width  | 32 bits                                  |
    | Simulation Tool    | Vivado Simulator                         |
    | Protocol Version   | AMBA APB v2                              |
    | Target Device      | Embedded peripherals simulation           |
    | Reset Type         | Active Low                               |

---

System_Architecture:
  Overview: "🧭 CPU → AHB Bus → APB Bus → Peripherals (UART, GPIO, Timer…)"
  Explanation: >
    Instead of letting the CPU handle every peripheral,  
    the **APB** manages communication, minimizing **CPU load and power use**  
    while maintaining **smooth and efficient data transfers** ⚡

---

Implemented_Modules:
  Table:
    | 🧩 Module Name          | 🧠 Functionality Summary                              |
    |--------------------------|-------------------------------------------------------|
    | AMBA_APB_PROTOCOL_BUS.v  | Core logic for state transitions and control signals. |
    | AMBA_APB_SLAVE.v         | Simulates peripheral memory and responses.            |
    | AMBA_APB_TOP.v           | Integrates BUS and SLAVE into one functional unit.    |
    | AMBA_APB_TB.v            | Testbench for verification and waveform capture.      |

---

Main_Signals:
  Description: "🧠 Core APB bus signals used in the design:"
  Table:
    | Signal   | Dir. | Width  | Description                  |
    |-----------|------|--------|------------------------------|
    | PCLK     | In   | 1 bit  | APB clock                    |
    | PRESETn  | In   | 1 bit  | Active-low reset             |
    | PSEL     | Out  | 1 bit  | Slave select signal          |
    | PENABLE  | Out  | 1 bit  | Indicates access phase       |
    | PWRITE   | Out  | 1 bit  | 1 = Write, 0 = Read          |
    | PADDR    | Out  | 32 bit | Address line                 |
    | PWDATA   | Out  | 32 bit | Write data line              |
    | PRDATA   | In   | 32 bit | Read data line               |
    | PREADY   | In   | 1 bit  | Slave ready signal           |
    | PSLVERR  | In   | 1 bit  | Error indicator              |

---

Block_Diagram:
  Description: "🧱 Visualizing how each module connects in the system:"
  ASCII: |
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
  Tree: |
    📁 src/
      ├── AMBA_APB_PROTOCOL_BUS.v
      ├── AMBA_APB_SLAVE.v
      ├── AMBA_APB_TOP.v
      └── AMBA_APB_TB.v
    📁 constraints/
      └── basys3_debug.xdc
    📁 simulation/
      ├── waveform_results.vcd
      └── test_logs.txt
    📁 images/
      ├── header_banner.png
      ├── apb_block_diagram.png
      ├── synthesis_design.png
      ├── implementation_design.png
      ├── write_waveform_full.png
      ├── read_waveform_full.png
      ├── error_waveform_full.png
      └── fpga_demo_photo.jpg
    📄 README.md

---

Design_Flow:
  🔹 Elaboration:
    Description: "Checks module hierarchy and signal connectivity."
    Screenshot: "images/elaboration_design.png"
  🔹 Synthesis:
    Description: "Converts RTL to gate-level logic and estimates timing."
    Screenshot: "images/synthesis_design.png"
  🔹 Implementation:
    Description: "Handles placement, routing, and timing closure for FPGA."
    Screenshot: "images/implementation_design.png"

---

Simulation_Results:
  🧪 Write_Transaction:
    - "PWRITE = 1, PSEL active"
    - "Data sent via PWDATA"
    - "PREADY = 1 confirms success ✅"
  🧪 Read_Transaction:
    - "PWRITE = 0, slave provides PRDATA"
    - "PREADY = 1 indicates valid read"
  ⚠️ Error_Case:
    - "Invalid address → PSLVERR = 1"

---

Waveform_Outputs:
  Full_Waveforms:
    - "images/write_waveform_full.png"
    - "images/read_waveform_full.png"
    - "images/error_waveform_full.png"
  Key_Snippets:
    - "images/waveform_snippet1.png"
    - "images/waveform_snippet2.png"
    - "images/waveform_snippet3.png"

---

FPGA_Setup:
  Description: "🔌 Pin mapping for Basys3 board:"
  Table:
    | I/O Signal  | FPGA Pin | Description           |
    |--------------|-----------|----------------------|
    | PCLK         | W5        | 50 MHz system clock  |
    | PRESETn      | U18       | Active-low reset     |
    | PSEL         | V17       | Slave select switch  |
    | PENABLE      | V16       | Transfer enable      |
    | PWRITE       | W16       | Write/Read control   |
    | PRDATA[3:0]  | LEDs [3:0]| Display read data    |
    | PSLVERR      | E19       | Error LED            |
    | PREADY       | U16       | Ready indicator      |

---

Tools_Used:
  🧰:
    - "Vivado 2023.1 → Design, synthesis, simulation"
    - "GTKWave → Waveform analysis"
    - "Basys3 Board → FPGA testing platform"
    - "Verilog HDL → Hardware description language"

---

How_To_Run:
  🪜 Steps:
    1️⃣: "Clone the repository"
    Command: |
      git clone https://github.com/<your-username>/AMBA_APB_Protocol_v2.git
      cd AMBA_APB_Protocol_v2
    2️⃣: "Open in Vivado → Add src/ files and constraints/basys3_debug.xdc"
    3️⃣: "Run simulation on AMBA_APB_TB.v and observe signals"
    4️⃣: "Generate bitstream → Program Basys3 → Verify read/write LEDs"
  📸 Hardware_Demo: "images/fpga_demo_photo.jpg"

---

Author_Info:
  👤 Name: "Fares Wael Mohamed Mahmoud Hegazi"
  🎓 Education: "Communication & Electronics Engineering Student – ECE 200"
  💼 Roles: "Digital IC Design | Verilog Developer | Hardware Instructor"
  🌐 Contact: "[Add your email or GitHub link here]"

---

License:
  📜 Type: "MIT License"
  Description: "Free to use and modify with proper credit."

---

Future_Enhancements:
  🌟:
    - "Support multiple slave devices"
    - "Integrate AHB bridge for SoC communication"
    - "Add timing parameterization"
    - "Develop graphical transaction visualizer"

---

Quote: "💬 'Design efficiently. Simulate precisely. Debug intelligently.' – Fares Hegazi"
