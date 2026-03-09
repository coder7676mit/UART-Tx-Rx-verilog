# UART-Tx-Rx-verilog

UART Transceiver Design in Verilog

A synthesizable UART (Universal Asynchronous Receiver/Transmitter) RTL implementation written in Verilog.
The design includes a configurable baud rate generator, transmitter, receiver with 16× oversampling, and a seven-segment display interface for received data visualization. A simulation testbench is also provided for functional verification.

---

Overview

This project implements a full UART communication system suitable for FPGA-based digital design labs and RTL learning. The design supports serial transmission and reception of 8-bit data at 115200 baud using a 50 MHz system clock.

The architecture consists of modular RTL components for clarity and reuse:

- Baud rate generator
- UART transmitter
- UART receiver
- Seven-segment display decoder
- Top-level integration module
- Testbench for simulation

The transmitter sends 8-bit data serially, while the receiver reconstructs the data using 16× oversampling for improved reliability.

---

Features

- Fully synthesizable Verilog RTL
- 115200 baud UART communication
- 16× oversampling receiver
- Modular design structure
- FSM-based transmitter and receiver
- Seven-segment display output for received data
- Self-checking simulation testbench
- Compatible with FPGA workflows (Vivado / ModelSim / Icarus Verilog)

---

Project Structure

UART-Verilog/
│
├── uart.v            # Complete UART RTL design
├── uart_tb.v         # Simulation testbench
├── README.md         # Project documentation

---

Module Description

1. UART Top Module ("uart")

Integrates all functional blocks including transmitter, receiver, baud generator, and seven-segment display logic.

2. Baud Rate Generator ("baudrate")

Generates clock enable signals for both transmitter and receiver based on the system clock.

- System clock: 50 MHz
- UART baud rate: 115200
- Receiver oversampling: 16×

3. UART Transmitter ("transmitter")

Finite State Machine (FSM) controlling serial data transmission.

States:

- "IDLE"
- "START"
- "DATA"
- "STOP"

Frame format:

Start Bit | 8 Data Bits | Stop Bit
    0          LSB→MSB
