# FIFO Verification Environment using UVM
## Description
A FIFO (First-In, First-Out) is a memory-based data structure used in digital designs to manage data transfer between systems operating at different speeds or in different clock domains. FIFO behaves like a queue where the first data written in is the first to be read out.
It is widely used in communication interfaces, data buffering, and asynchronous data transfer scenarios.
## Key Characteristics of FIFO
1. Sequential Access: Data is read in the same order it was written — no random access.
2. Producer-Consumer Decoupling: Write and read operations are independent, often using separate clocks in asynchronous FIFOs.
3. Flow Control Signals: FIFO generates flags like:
    - full: No more space to write
    - empty: No data to read
    - almost_full, almost_empty: Warn about nearing limits
4. Backpressure Support: Prevents data loss when the receiver can't process data as quickly as the sender provides it.
## Basic FIFO Components
1. Memory Array:	Stores data entries of fixed width and depth.
2. Write Pointer:	Indicates the next location for write operations.
3. Read Pointer:	Indicates the next location for read operations.
4. Counter:	Tracks the number of valid entries stored.
5. Control Logic:	Manages write/read access, overflow/underflow detection, and flag generation.
## Typical FIFO Interface
1. Write Side:
    - wr_clk : Write clock
    - wr_en : Write enable
    - wr_data: Data input to FIFO
    - full : FIFO is full (write not allowed)
2. Read Side:
    - rd_clk : Read clock
    - rd_en : Read enable
    - rd_data: Data output from FIFO
    - empty : FIFO is empty (read not allowed)
## Verification Plan
![image](https://github.com/user-attachments/assets/9e9b003c-f5e2-49ba-98c1-f970b7443c10)
## UVM Structure
![image](https://github.com/user-attachments/assets/baecbc5e-0caf-4639-bbc7-4841d58b88b8)
