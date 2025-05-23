package FIFO_rand_seq_pkg;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_rand_seq extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_rand_seq);
FIFO_seq_item seq_item;

function new(string name = "FIFO_rand_seq");
    super.new(name);
endfunction

task body;
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    start_item(seq_item);
    assert(seq_item.randomize())
    finish_item(seq_item);
endtask 
endclass
endpackage