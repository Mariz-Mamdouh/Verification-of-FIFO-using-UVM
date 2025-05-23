module FIFO_sva(FIFO_if.DUT fifo_if);
    localparam max_fifo_addr = $clog2(fifo_if.FIFO_DEPTH);

    // Reset Behavior
	always_comb begin
		if (!fifo_if.rst_n) begin
			a_reset: assert final ((FIFO.count == {(max_fifo_addr+1){1'b0}}) && (FIFO.wr_ptr == {max_fifo_addr{1'b0}}) 
																			&& (FIFO.rd_ptr == {max_fifo_addr{1'b0}}));
		end
	end

	// Write Acknowledge (wr_ack)
	property p_wr_ack;
		@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
		(fifo_if.wr_en) && !(fifo_if.full) |=> (fifo_if.wr_ack==1'b1);
	endproperty
	wr_ack_assertion: assert property(p_wr_ack);
	wr_ack_coverage: cover property(p_wr_ack);

	// Overflow Detection
	property p_overflow;
		@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
		(fifo_if.wr_en) && (fifo_if.full) |=> (fifo_if.overflow==1'b1);
	endproperty
	overflow_assertion: assert property(p_overflow);
	overflow_coverage: cover property(p_overflow);

	// Underflow Detection
	property p_underflow;
		@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
		(fifo_if.rd_en) && (fifo_if.empty) |=> (fifo_if.underflow==1'b1);
	endproperty
	underflow_assertion: assert property(p_underflow);
	underflow_coverage: cover property(p_underflow);

	// Empty Flag Assertion
	property p_empty;
		@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
		(FIFO.count == {(max_fifo_addr+1){1'b0}}) |-> (fifo_if.empty==1'b1);
	endproperty
	empty_assertion: assert property(p_empty);
	empty_coverage: cover property(p_empty);

	// Full Flag Assertion
	property p_full;
		@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
		(FIFO.count == fifo_if.FIFO_DEPTH) |-> (fifo_if.full==1'b1);
	endproperty
	full_assertion: assert property(p_full);
	full_coverage: cover property(p_full);

	// Almost Full Condition
	property p_almostfull;
		@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
		(FIFO.count == ((fifo_if.FIFO_DEPTH)-1'b1)) |-> (fifo_if.almostfull==1'b1);
	endproperty
	almostfull_assertion: assert property(p_almostfull);
	almostfull_coverage: cover property(p_almostfull);

	// Almost Empty Condition
	property p_almostempty;
		@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
		(FIFO.count == 1'b1) |-> (fifo_if.almostempty==1'b1);
	endproperty
	almostempty_assertion: assert property(p_almostempty);
	almostempty_coverage: cover property(p_almostempty);

	// Pointer Wraparound & threshold
	property p_wr_ptr;
		@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
		(fifo_if.wr_en) && (FIFO.count < fifo_if.FIFO_DEPTH) |=> (FIFO.wr_ptr == $past(FIFO.wr_ptr) + 1'b1);
	endproperty
	wr_ptr_assertion: assert property(p_wr_ptr);
	wr_ptr_coverage: cover property(p_wr_ptr);

	property p_rd_ptr;
		@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
		(fifo_if.rd_en) && (FIFO.count != 1'b0) |=> (FIFO.rd_ptr == $past(FIFO.rd_ptr) + 1'b1);
	endproperty
	rd_ptr_assertion: assert property(p_rd_ptr);
	rd_ptr_coverage: cover property(p_rd_ptr);


	// Counter Wraparound & threshold
	property p_counter_up;
		@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
		(fifo_if.wr_en) && !(fifo_if.full) && !(fifo_if.rd_en) |=> (FIFO.count == $past(FIFO.count) + 1'b1);
	endproperty
	counter_up_assertion: assert property(p_counter_up);
	counter_up_coverage: cover property(p_counter_up);

	property p_counter_down;
		@(posedge fifo_if.clk) disable iff (!fifo_if.rst_n)
		!(fifo_if.wr_en) && !(fifo_if.empty) && (fifo_if.rd_en) |=> (FIFO.count == $past(FIFO.count) - 1'b1);
	endproperty
	counter_down_assertion: assert property(p_counter_down);
	counter_down_coverage: cover property(p_counter_down);
endmodule