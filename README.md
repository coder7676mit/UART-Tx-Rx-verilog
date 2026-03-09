UART Tx-Rx Design in Verilog

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
    0          LSB→MSB       1

4. UART Receiver ("receiver")

Receives serial data using 16× oversampling to improve timing robustness.

States:

- "START"
- "DATA"
- "STOP"

The receiver asserts a ready flag when valid data is captured.

5. Seven Segment Decoder ("seven_segment_decoder")

Converts received binary data into decimal digits (hundreds, tens, units) for seven-segment display output.

---

Simulation

The testbench performs a UART loopback test:

Tx → Rx

Steps executed:

1. Generate 50 MHz clock
2. Apply reset
3. Transmit a byte
4. Loop transmitter output to receiver
5. Verify received data

Expected Console Output

Received Data = 123
UART TEST PASSED

---


Applications

This project can be used for:

- FPGA serial communication
- Embedded system debugging
- Digital design coursework
- RTL verification practice
- UART interface learning

---

Tools Used:

- Xilinx Vivado
- Icarus Verilog
- GTKWave

---

Author

Nagendra Kudva
Electronics and Communication Engineering
Manipal Institute of Technology

---

License

This project is open source and available under the MIT License.
