package FIFO_covg_collector_pkg;
import uvm_pkg::*;
import FIFO_seq_item_pkg::*;
`include "uvm_macros.svh"

class FIFO_covg_collector extends uvm_component;
    `uvm_component_utils(FIFO_covg_collector)
    uvm_analysis_export #(FIFO_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
    FIFO_seq_item seq_item_cov;

    covergroup FIFO_cg;
        wr_en_cp:       coverpoint seq_item_cov.wr_en iff(seq_item_cov.rst_n);
        rd_en_cp:       coverpoint seq_item_cov.rd_en iff(seq_item_cov.rst_n);
        full_cp:        coverpoint seq_item_cov.full iff(seq_item_cov.rst_n);
        empty_cp:       coverpoint seq_item_cov.empty iff(seq_item_cov.rst_n);
        almostfull_cp:  coverpoint seq_item_cov.almostfull iff(seq_item_cov.rst_n);
        almostempty_cp: coverpoint seq_item_cov.almostempty iff(seq_item_cov.rst_n);
        underflow_cp:   coverpoint seq_item_cov.underflow iff(seq_item_cov.rst_n);
        overflow_cp:    coverpoint seq_item_cov.overflow iff(seq_item_cov.rst_n);
        wr_ack_cp:      coverpoint seq_item_cov.wr_ack iff(seq_item_cov.rst_n);

        wr_full_cross: cross wr_en_cp,full_cp {
            option.cross_auto_bin_max = 0;
            bins wr_on_full_on = binsof(wr_en_cp) intersect {1} && binsof(full_cp) intersect {1};
            bins wr_on_full_off = binsof(wr_en_cp) intersect {1} && binsof(full_cp) intersect {0};
            bins wr_off_full_off = binsof(wr_en_cp) intersect {0} && binsof(full_cp) intersect {0};
        }
        wr_almosfull_cross: cross wr_en_cp,almostfull_cp;
        wr_overflow_cross: cross wr_en_cp,overflow_cp {
            option.cross_auto_bin_max = 0;
            bins wr_on_overflow_on = binsof(wr_en_cp) intersect {1} && binsof(overflow_cp) intersect {1};
            bins wr_on_overflow_off = binsof(wr_en_cp) intersect {1} && binsof(overflow_cp) intersect {0};
            bins wr_off_overflow_off = binsof(wr_en_cp) intersect {0} && binsof(overflow_cp) intersect {0};
        }
        wr_with_wr_ack_cross: cross wr_en_cp,wr_ack_cp {
            option.cross_auto_bin_max = 0;
            bins wr_on_wr_ack_on = binsof(wr_en_cp) intersect {1} && binsof(wr_ack_cp) intersect {1};
            bins wr_on_wr_ack_off = binsof(wr_en_cp) intersect {1} && binsof(wr_ack_cp) intersect {0};
            bins wr_off_wr_ack_off = binsof(wr_en_cp) intersect {0} && binsof(wr_ack_cp) intersect {0};
        }
        rd_empty_cross: cross rd_en_cp,empty_cp;
        rd_almostempty_cross: cross rd_en_cp,almostempty_cp {
            option.cross_auto_bin_max = 0;
            bins rd_on_almostempty_on = binsof(rd_en_cp) intersect {1} && binsof(almostempty_cp) intersect {1};
            bins rd_on_almostempty_off = binsof(rd_en_cp) intersect {1} && binsof(almostempty_cp) intersect {0};
            bins rd_off_almostempty_off = binsof(rd_en_cp) intersect {0} && binsof(almostempty_cp) intersect {0};
        }
        rd_underflow_cross: cross rd_en_cp,underflow_cp {
            option.cross_auto_bin_max = 0;
            bins rd_on_underflow_on = binsof(rd_en_cp) intersect {1} && binsof(underflow_cp) intersect {1};
            bins rd_on_underflow_off = binsof(rd_en_cp) intersect {1} && binsof(underflow_cp) intersect {0};
            bins rd_off_underflow_off = binsof(rd_en_cp) intersect {0} && binsof(underflow_cp) intersect {0};
        }
    endgroup


    function new(string name = "FIFO_covg_collector",uvm_component parent = null);
        super.new(name,parent);
        FIFO_cg = new();
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_export = new("cov_export",this);
        cov_fifo = new("cov_fifo",this);
    endfunction
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            cov_fifo.get(seq_item_cov);
            FIFO_cg.sample();
        end
    endtask
endclass //FIFO_covg_collector 
endpackage