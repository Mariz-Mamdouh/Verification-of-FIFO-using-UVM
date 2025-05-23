package FIFO_read_write_seq_pkg;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_read_write_seq extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_read_write_seq);
FIFO_seq_item seq_item;

function new(string name = "FIFO_read_write_seq");
    super.new(name);
endfunction

task body;
    repeat(9) begin
        seq_item = FIFO_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.rst_n = 1;
        seq_item.wr_en = 1;
        seq_item.rd_en = 1;
        seq_item.data_in = $random;
        finish_item(seq_item);
    end
endtask 
endclass
endpackage