package FIFO_scoreboard_pkg;
import uvm_pkg::*;
import FIFO_seq_item_pkg::*;
`include "uvm_macros.svh"

class FIFO_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(FIFO_scoreboard)
    uvm_analysis_export #(FIFO_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;
    FIFO_seq_item seq_item_sb;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic [FIFO_WIDTH-1:0] mem_ref [$];
    int error_count = 0;
    int correct_count = 0;

    function new(string name = "FIFO_scoreboard",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export",this);
        sb_fifo = new("sb_fifo",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(seq_item_sb);
            ref_model(seq_item_sb);
            if (seq_item_sb.data_out != data_out_ref) begin
                `uvm_error("run_phase", $sformatf("Comparison failed, Transaction received by the DUT:%s while the reference out:0h%0h"
                , seq_item_sb.convert2string(),data_out_ref));
            end else begin
                `uvm_info("run_phase",$sformatf("Correct FIFO out: %s",seq_item_sb.convert2string()),UVM_HIGH);
                correct_count++;
            end
        end
    endtask 

    task ref_model(FIFO_seq_item seq_item_chk);
        if (!seq_item_chk.rst_n) begin
            mem_ref.delete();
        end else begin
            case ({seq_item_chk.wr_en, seq_item_chk.rd_en})
            2'b00: begin
                // No operation
            end
            2'b10: begin // Write only
                if (mem_ref.size() < seq_item_chk.FIFO_DEPTH)
                    mem_ref.push_back(seq_item_chk.data_in);
            end
            2'b01: begin // Read only
                if (mem_ref.size() > 0)
                    data_out_ref = mem_ref.pop_front();
            end
            2'b11: begin // Both read and write
                if (mem_ref.size() == 0) begin
                    // Empty FIFO → only write
                    mem_ref.push_back(seq_item_chk.data_in);
                end
                else if (mem_ref.size() == seq_item_chk.FIFO_DEPTH) begin
                    // Full FIFO → only read
                    data_out_ref = mem_ref.pop_front();
                end
                else begin
                    // Both read and write can happen
                    data_out_ref = mem_ref.pop_front();
                    mem_ref.push_back(seq_item_chk.data_in);
                end
            end
        endcase
        end
    endtask 

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase",$sformatf("Total successful transactions: %0d",correct_count),UVM_MEDIUM);
        `uvm_info("report_phase",$sformatf("Total failed transactions: %0d",error_count),UVM_MEDIUM);
    endfunction
endclass //FIFO_scoreboard
endpackage