module tff(output reg q, qb, input clk, clrn, t);
	always @ (negedge clk or negedge clrn)
		if (~clrn)
			q = 1'b0;
		else
			q = t ^ q;
    assign qb = ~q;
endmodule

module counter10 (cnt_en, q, clk, rstn, enb, q_ant);
  	output [3:0] q;   
  	output reg cnt_en;  
  	input clk, rstn, enb;
  	input [3:0] q_ant;
  
    wire [3:0] tv;
  	assign tv = {((q[3] & q[0])|(q[0] & q[1] & q[2]))& enb, (q[1] & q[0])& enb, (q[0] & ~q[3])& enb, (1'b1)& enb};

    genvar i;
    generate				//Verilog-2001
       for (i=0; i<4; i=i+1)
         tff u0 (.q(q[i]), .qb(), .clk(clk), .clrn(rstn), .t(tv[i]));
    endgenerate
  	always @(posedge clk) begin
      if(q == 4'b1001 && q_ant == 4'b1001)
      	cnt_en = 1'b1;
      else
        cnt_en = 1'b0;
  end

endmodule

module counter1000 (output [3:0] q1,q2,q3, input clk, rstn);
  reg [2:0] cnt_en;
  counter10 u0 (.q(q1), .cnt_en(cnt_en[0]), .clk(clk), .rstn(rstn), .enb(clk), .q_ant(4'b1001));
  counter10 d0 (.q(q2), .cnt_en(cnt_en[1]), .clk(clk), .rstn(rstn), .enb(cnt_en[0]), .q_ant(q1));
  counter10 c0 (.q(q3), .cnt_en(cnt_en[2]), .clk(clk), .rstn(rstn), .enb(cnt_en[1]), .q_ant(q2));
endmodule