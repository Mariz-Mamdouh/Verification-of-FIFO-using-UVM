package FIFO_test_pkg;
import FIFO_env_pkg::*;
import FIFO_read_only_seq_pkg::*;
import FIFO_write_only_seq_pkg::*;
import FIFO_read_write_seq_pkg::*;
import FIFO_reset_seq_pkg::*;
import FIFO_rand_seq_pkg::*;
import FIFO_config_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_test extends uvm_test;
  `uvm_component_utils(FIFO_test)
  FIFO_env env;
  FIFO_config FIFO_cfg;
  virtual FIFO_if FIFO_vif;
  FIFO_read_only_seq read_only_seq;
  FIFO_write_only_seq write_only_seq;
  FIFO_read_write_seq read_write_seq;
  FIFO_rand_seq rand_seq;
  FIFO_reset_seq reset_seq;

  function new(string name = "FIFO_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = FIFO_env::type_id::create("env",this);
    FIFO_cfg = FIFO_config::type_id::create("FIFO_cfg",this);
    read_only_seq = FIFO_read_only_seq::type_id::create("read_only_seq",this);
    write_only_seq = FIFO_write_only_seq::type_id::create("write_only_seq",this);
    read_write_seq = FIFO_read_write_seq::type_id::create("read_write_seq",this);
    rand_seq = FIFO_rand_seq::type_id::create("rand_seq",this);
    reset_seq = FIFO_reset_seq::type_id::create("reset_seq",this);

    if (!uvm_config_db #(virtual FIFO_if)::get(this,"","FIFO_IF",FIFO_cfg.FIFO_vif)) begin
            `uvm_fatal("build_phase","Test - unable to get the virtual interface of the FIFO frm the uvm_config_db");
        end
    uvm_config_db #(FIFO_config)::set(this,"*","CFG",FIFO_cfg);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info("run_phase","Reset Asserted",UVM_LOW)
    reset_seq.start(env.agt.sqr);
    `uvm_info("run_phase","Reset Deasserted",UVM_LOW)
    `uvm_info("run_phase","Stimulus Generation Started",UVM_LOW)
    // Fill the FIFO
    write_only_seq.start(env.agt.sqr);
    // Try to write when FIFO full
    write_only_seq.start(env.agt.sqr);
    // Read the FIFO
    read_only_seq.start(env.agt.sqr);
    // Try to read when empty
    read_only_seq.start(env.agt.sqr);
    // Fill the FIFO completely and then read it
    write_only_seq.start(env.agt.sqr);
    read_only_seq.start(env.agt.sqr);
    // Both read & write are asserted when FIFO is empty → should write only
    read_write_seq.start(env.agt.sqr);
    // Read the FIFO completely and then fill it
    read_only_seq.start(env.agt.sqr);
    write_only_seq.start(env.agt.sqr);
    // Both read & write are asserted when FIFO is full → should read only
    read_write_seq.start(env.agt.sqr);
    // Fill the FIFO
    write_only_seq.start(env.agt.sqr);
    // Read the FIFO
    read_only_seq.start(env.agt.sqr);
    // Random Stimulus
    repeat(1000) rand_seq.start(env.agt.sqr);
    `uvm_info("run_phase","Stimulus Generation Ended",UVM_LOW)
    phase.drop_objection(this);
  endtask 
endclass: FIFO_test
endpackage