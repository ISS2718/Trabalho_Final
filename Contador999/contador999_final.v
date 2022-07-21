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

//12689616
module bin27seg (a, b, c, d, e, f, g, v);
  output a, b, c, d, e, f, g;
  input [3:0] v;
  assign {a, b, c, d, e, f, g} = ( v == 4'b0000 ) ? 7'b1111110 : //0
                                 ( v == 4'b0001 ) ? 7'b0110000 : //1
                                 ( v == 4'b0010 ) ? 7'b1101101 : //2
                                 ( v == 4'b0011 ) ? 7'b1111001 : //3
                                 ( v == 4'b0100 ) ? 7'b0110011 : //4
                                 ( v == 4'b0101 ) ? 7'b1011011 : //5
                                 ( v == 4'b0110 ) ? 7'b1011111 : //6
                                 ( v == 4'b0111 ) ? 7'b1110000 : //7
                                 ( v == 4'b1000 ) ? 7'b1111111 : //8
                                 ( v == 4'b1001 ) ? 7'b1111011 : //9
7'b1111001 ; //mostra E invertido
endmodule

module counter1000 (output [6:0] uni, dez, cen, input clk, rstn);
  reg [3:0] q1,q2,q3;
  reg [2:0] cnt_en;
  counter10 u0 (.q(q1), .cnt_en(cnt_en[0]), .clk(clk), .rstn(rstn), .enb(clk), .q_ant(4'b1001));
  counter10 d0 (.q(q2), .cnt_en(cnt_en[1]), .clk(clk), .rstn(rstn), .enb(cnt_en[0]), .q_ant(q1));
  counter10 c0 (.q(q3), .cnt_en(cnt_en[2]), .clk(clk), .rstn(rstn), .enb(cnt_en[1]), .q_ant(q2));
  bin27seg du (.a(uni[0]), .b(uni[1]), .c(uni[2]), .d(uni[3]), .e(uni[4]), .f(uni[5]), .g(uni[6]), .v(q1));
  bin27seg dd (.a(dez[0]), .b(dez[1]), .c(dez[2]), .d(dez[3]), .e(dez[4]), .f(dez[5]), .g(dez[6]), .v(q2));
  bin27seg dc (.a(cen[0]), .b(cen[1]), .c(cen[2]), .d(cen[3]), .e(cen[4]), .f(cen[5]), .g(cen[6]), .v(q3));


endmodule