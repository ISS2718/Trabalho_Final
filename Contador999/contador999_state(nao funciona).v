module tff(output reg q, qb, input clk, clrn, t);
	always @ (negedge clk or negedge clrn)
		if (~clrn)
			q = 1'b0;
		else
			q = t ^ q;
    assign qb = ~q;
endmodule

module counter10 (output [3:0] q, input clk, rstn, enb);

    wire [3:0] tv;
  assign tv = {((q[3] & q[0])|(q[0] & q[1] & q[2]))& enb, (q[1] & q[0])& enb, (q[0] & ~q[3])& enb, (1'b1)& enb};

    genvar i;
    generate				//Verilog-2001
       for (i=0; i<4; i=i+1)
         tff u0 (.q(q[i]), .qb(), .clk(clk), .clrn(rstn), .t(tv[i]));
    endgenerate

endmodule

module counter1000 (output [3:0] q1,q2,q3, input clk, rstn);
  localparam A=2'b01, B=2'b10, C=2'b11;
  reg [1:0] state, nextState;
  assign  enb = {1'b0, 1'b0, 1'b0};
  always @(posedge clk) begin
    if(~rstn)
      state <= A;
  	else begin
    	state <= nextState;
    end
  end
  always @(*) begin
    nextState = state; 
    case (state)
      A: begin
        if(q1 == 9)
          nextState = B;
      end
      B: begin
        if(q2 == 9)
          nextState = C;
      end
      C: begin 
        if(q3 == 9)
          nextState = A;
      end
    endcase
  end
  counter10 u0 (.q(q1), .clk(clk), .rstn(rstn), .enb(state == A));
  counter10 d0 (.q(q2), .clk(clk), .rstn(rstn), .enb(state == B));
  counter10 c0 (.q(q3), .clk(clk), .rstn(rstn), .enb(state == C));
endmodule