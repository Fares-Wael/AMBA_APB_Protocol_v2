# 🧩 AMBA APB Protocol v2

![Header](images/header_banner.png)

### 📘 Advanced Microcontroller Bus Architecture – APB Version 2  
**Developed by:** *Fares Wael Mohamed Mahmoud Hegazi*  
**Language:** Verilog HDL  
**Target Board:** Basys3 (Xilinx Artix-7 FPGA)  
**Toolchain:** Vivado 2023.1  

---

## 🧠 Project Overview

The **AMBA APB Protocol v2** is a simplified, low-power communication interface used to connect peripherals (like UART, GPIO, Timers) to a CPU through the **AHB–APB bridge**.  

This project implements a **Verilog-based APB Bus System**, featuring:
- Master–Slave communication  
- Bus control and timing logic  
- Error handling  
- Read/Write operations  
- Simulation and FPGA testing  

---

## 🚀 Motivation

Instead of having the **CPU handle all peripheral communications** (which wastes power and increases complexity),  
the **APB** takes over these tasks — allowing peripherals to interact via a **lightweight bus interface**.  

🧩 **Result:** Lower power consumption and a modular SoC structure.

---

## 🧭 System Overview

CPU ──► AHB Bus ──► APB Bus ──► Peripherals (UART, GPIO, Timer…)

yaml
Copy code

✅ **Simplified Design:**  
The CPU only talks to the APB bus, while APB handles all peripheral communication internally.

---

## ⚙️ Implemented Modules

| Module Name | Description |
|--------------|-------------|
| `AMBA_APB_PROTOCOL_BUS` | Manages APB signal timing, transfers, and state transitions. |
| `AMBA_APB_SLAVE` | Simulates a slave peripheral that responds to APB commands. |
| `AMBA_APB_TOP` | Integrates bus and slave modules into a unified top-level system. |
| `AMBA_APB_TB` | Testbench for simulation, verification, and waveform generation. |

---

## 🧩 Block Diagram

vbnet
Copy code
            ┌──────────────────────────────┐
            │      AMBA_APB_TB (Testbench) │
            │   • Simulates & verifies     │
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
 │ • Manages control timing │    │ • Responds to operations │
 │   and data transfers     │    │ • Implements memory map  │
 └──────────────────────────┘    └──────────────────────────┘
yaml
Copy code

🖼️ *(Replace with your diagram)*  
`![Block Diagram](images/apb_block_diagram.png)`

---

## 📦 File Structure

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
│ ├── write_waveform.png
│ ├── read_waveform.png
│ ├── error_waveform.png
│ └── fpga_demo.jpg
│
└── README.md

yaml
Copy code

---

## 🔌 FPGA Constraints (Basys3)

| Signal | Pin | Description |
|---------|-----|-------------|
| `PCLK` | W5 | Clock (100 MHz) |
| `PRESETn` | U18 | Active-low reset button |
| `PSEL` | V17 | Slave select switch |
| `PENABLE` | V16 | Enable control |
| `PWRITE` | W16 | Write/Read control |
| `PRDATA[3:0]` | LEDs [3:0] | Show read data |
| `PSLVERR` | E19 | Error indicator |
| `PREADY` | U16 | Ready signal |

🧠 *Defined in `constraints/basys3_debug.xdc`.*

---

## 🧪 Simulation Results

### ✅ **Write Cycle**
- Master sets `PWRITE = 1`, selects the slave (`PSEL`), and asserts `PENABLE`.
- Data on `PWDATA` is written to the slave.
- `PREADY` indicates successful transfer.

### ✅ **Read Cycle**
- Master sets `PWRITE = 0`.
- Slave drives `PRDATA` onto the bus.
- `PREADY` signals completion.

---

### 📈 Waveform Outputs

- Write Transaction  
  `![Write Waveform](images/write_waveform.png)`

- Read Transaction  
  `![Read Waveform](images/read_waveform.png)`

- Error Example  
  `![Error Waveform](images/error_waveform.png)`

---

## 🧰 Tools Used

| Tool | Purpose |
|------|----------|
| **Vivado 2023.1** | Synthesis, simulation, and implementation |
| **GTKWave** | Waveform analysis |
| **Basys3 Board** | FPGA testing |
| **Verilog HDL** | Hardware description and simulation |

---

## 🧱 Basys3 Debug Setup

| Input/Output | Mapped To | Function |
|---------------|------------|-----------|
| `SW0` | PSEL | Select Slave |
| `SW1` | PENABLE | Enable Transfer |
| `SW2` | PWRITE | Write/Read Toggle |
| `LED0` | PREADY | Transfer Ready |
| `LED1` | PSLVERR | Error Signal |
| `LED[3:0]` | PRDATA[3:0] | Read Data Display |

---

## 🧩 How to Run the Project

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/Fares-Wael/AMBA_APB_Protocol_v2.git
cd AMBA_APB_Protocol_v2
