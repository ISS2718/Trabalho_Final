module tff(output reg q, qb, input clk, clrn, t);
	always @ (negedge clk or negedge clrn)
		if (~clrn)
			q = 1'b0;
		else
			q = t ^ q;
    assign qb = ~q;
endmodule

module counter10 (/*cnt_en,*/ q, clk, rstn, enb);
  	output [3:0] q;   
  	//output reg cnt_en;  
  	input clk, rstn, enb;
  
    wire [3:0] tv;
  	assign tv = {((q[3] & q[0])|(q[0] & q[1] & q[2]))& enb, (q[1] & q[0])& enb, (q[0] & ~q[3])& enb, (1'b1)& enb};

    genvar i;
    generate				//Verilog-2001
       for (i=0; i<4; i=i+1)
         tff u0 (.q(q[i]), .qb(), .clk(clk), .clrn(rstn), .t(tv[i]));
    endgenerate
  	

endmodule

module counter1000 (output [3:0] q1,q2,q3, input clk, rstn);
  reg [1:0] cnt_en;
  always @(posedge clk) begin
    if(q1 == 4'b1001)
      	cnt_en[0] = 1'b1;
      else
        cnt_en[0] = 1'b0;
    if(q1 == 4'b1001 && q2 == 4'b1001)
      cnt_en[1] = 1'b1;
      else
        cnt_en[1] = 1'b0;
  end
  counter10 u0 (.q(q1), .clk(clk), .rstn(rstn), .enb(clk));
  counter10 d0 (.q(q2), .clk(clk), .rstn(rstn), .enb(cnt_en[0]));
  counter10 c0 (.q(q3), .clk(clk), .rstn(rstn), .enb(cnt_en[1]));
endmodule