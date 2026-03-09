# UART Tx-Rx Design in Verilog

A robust, synthesizable **Universal Asynchronous Receiver/Transmitter (UART)** RTL implementation. This project features a modular architecture including a baud rate generator, 16× oversampling receiver, and a seven-segment display interface for real-time data visualization using **Xilinx Vivado**

---

## 📌 Overview

This project implements a complete UART communication system designed for FPGA-based digital design labs and RTL learning. It facilitates reliable 8-bit serial data transfer at **115200 baud** using a **50 MHz** system clock.



### Key Architecture Components:
* **Baud Rate Generator:** Precise clock division for Tx and Rx.
* **UART Transmitter:** FSM-based parallel-to-serial converter.
* **UART Receiver:** 16× oversampling serial-to-parallel converter.
* **Seven-Segment Decoder:** Binary-to-decimal visualization logic.
* **Top-Level Integration:** Modular structural Verilog connecting all blocks.

---

## 🚀 Features

* **Synthesizable RTL:** Written in standard Verilog, compatible with Vivado, Quartus, and Diamond.
* **High-Speed Communication:** Default 115200 baud rate.
* **High Reliability:** 16× oversampling receiver for improved timing margin and noise robustness.
* **FSM-Based Design:** Clear, modular Finite State Machines for both Tx and Rx.
* **Visual Debugging:** Integrated Seven-Segment display output for received data.
* **Verification Ready:** Includes a self-checking testbench for functional simulation.

---

## 📂 Project Structure

```text
UART-Verilog/
├── uart.v            # Core RTL design (Top, Tx, Rx, Baud, Seg-7)
├── uart_tb.v         # Self-checking simulation testbench
├── outputs           # output waveforms
└── README.md         # Project documentation
```
---

## 🛠 Module Descriptions

### 1. UART Top Module (`uart`)
The top-level entity that structuraly integrates the transmitter, receiver, baud rate generator, and the seven-segment display logic. It acts as the primary interface for FPGA pins (Clock, Reset, Tx, Rx, and Display Seven-Segments).

### 2. Baud Rate Generator (`baudrate`)
A frequency divider that generates the precise timing pulses required for synchronized communication.
* **System Clock:** 50 MHz
* **UART Baud Rate:** 115200
* **Receiver Sampling:** 16× oversampling (provides a sampling pulse at 1.8432 MHz).

### 3. UART Transmitter (`transmitter`)
A Finite State Machine (FSM) that converts 8-bit parallel data into a serial bitstream.
* **States:** `IDLE` → `START` → `DATA` → `STOP`
* **Frame Format:**

    > `0 (Start) | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | 1 (Stop)`

### 4. UART Receiver (`receiver`)
The receiver uses **16× oversampling** to sample the incoming `Rx` signal. By counting 8 clock pulses after a falling edge is detected, it samples the bit at its theoretical center to ensure maximum timing margin and noise immunity.
* **States:** `IDLE` → `START` → `DATA` → `STOP`
* **Output:** Asserts a `data_ready` flag once a full byte is reconstructed.

### 5. Seven Segment Decoder (`seven_segment_decoder`)
To make the hardware implementation interactive, this module converts the 8-bit binary received data into a format compatible with common-anode or common-cathode 7-segment displays, showing the decimal value (0-255).

---

## 💻 Simulation & Verification

The project includes a self-checking testbench (`uart_tb.v`) that performs a **loopback test**. It connects the Transmitter output (`Tx`) directly to the Receiver input (`Rx`) to verify data integrity.



## Tools used

* Xilinx Vivado
* Icarus verilog
* GTKWave

## 👤 Author

**Nagendra Kudva** Electronics and Communication Engineering  
Manipal Institute of Technology  

---

## 📄 License

This project is open-source and available under the **MIT License**.
