import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_test_pkg::*;

module top();
  bit clk;
  initial begin
    forever begin
      #1 clk = ~clk;
    end
  end 
  FIFO_if FIFOif (clk);
  FIFO DUT (FIFOif);
  bind FIFO FIFO_sva FIFO_sva_inst(FIFOif.DUT);
  initial begin
    uvm_config_db#(virtual FIFO_if)::set(null,"uvm_test_top","FIFO_IF",FIFOif);
    run_test("FIFO_test");
  end
endmodule