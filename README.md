# FIFO_Async_and_Sync

# Overview
- This project implements both Synchronous and Asynchronous FIFO (First-In-First-Out) designs using Verilog. FIFOs are essential components in digital systems for buffering data between two subsystems operating at different clock domains (asynchronous FIFO) or within the same clock domain (synchronous FIFO).

# Features
# Synchronous FIFO
- Single Clock Domain: Both read and write operations occur under the same clock.
- Configurable Depth and Width: The FIFO depth and data width can be adjusted as needed.
- Full and Empty Flags: Status signals indicate when the FIFO is full or empty.
- Overflow and Underflow Protection: The design prevents overflow and underflow conditions.
# Asynchronous FIFO
- Dual Clock Domains: Write and read operations are managed by separate clocks.
- Gray Code Pointers: Gray code is used for pointer management to ensure reliable multi-clock domain operation.
- Empty and Full Flags: Indicate when the FIFO can no longer accept new data or when it's empty.
- Metastability Management: Includes mechanisms to handle clock domain crossing and mitigate metastability.

# Design Details
# Synchronous FIFO
- Write Operation: Data is written into the FIFO on the rising edge of the write clock when the FIFO is not full.
- Read Operation: Data is read from the FIFO on the rising edge of the read clock when the FIFO is not empty.
- Pointers: Read and write pointers are used to manage the position of data in the FIFO.
# Asynchronous FIFO
- Clock Domain Crossing: Uses Gray code for the write and read pointers to prevent glitches during clock domain crossing.
- Synchronization: Dual flip-flop synchronizers are used to manage metastability issues.
- Read and Write: Separate clocks control the read and write operations, making it suitable for bridging different clock domains.