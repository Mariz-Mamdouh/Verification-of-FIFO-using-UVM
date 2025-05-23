package FIFO_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_seq_item extends uvm_sequence_item;
    `uvm_object_utils(FIFO_seq_item);
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    rand bit [FIFO_WIDTH-1:0] data_in;
    rand bit rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;
    int RD_EN_ON_DIST;
    int WR_EN_ON_DIST;

    function new(string name = "FIFO_seq_item");
        super.new(name);
        RD_EN_ON_DIST = 30;
        WR_EN_ON_DIST = 70;
    endfunction

    function string convert2string();
        return $sformatf("%s rst_n=%0b, data_in=%0h, wr_en=%0b, rd_en=%0b, data_out=%0h, wr_ack=%0b, overflow=%0b, full=%0b, empty=%0b, almostfull=%0b, almostempty=%0b, underflow=%0b"
        ,super.convert2string(),rst_n, data_in, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
    endfunction
    function string convert2string_stimulus();
        return $sformatf("rst_n=%0b, data_in=%0h, wr_en=%0b, rd_en=%0b",rst_n, data_in, wr_en, rd_en);
    endfunction

    constraint rst_const {
        rst_n dist {0:=10, 1:=90};
    }
    constraint wr_en_const {
        wr_en dist {1:=WR_EN_ON_DIST, 0:=(100-WR_EN_ON_DIST)};
    }
    constraint rd_en_const {
        rd_en dist {1:=RD_EN_ON_DIST, 0:=(100-RD_EN_ON_DIST)};
    }
endclass //FIFO_seq_item
endpackage
    
    
    
    
    
    
    
    