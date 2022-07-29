//Contador de 0 a 999 em BCD

//Beatriz Cardoso de Oliveira - 12566400
//Fernando Lucas Vieira Souza - 12703069
//Isaac Santos Soares - 12751713
//Joao Pedro Gonçalves Ferreira - 12731314
//Nicholas Estevao Pereira de Oliveira Rodrigues Bragança - 12689616
//Pedro Antonio Bruno Grando - 12547166

module tff(output reg q, qb, input clk, clrn, t);
	//Flip-flop do tipo T
	always @ (negedge clk or negedge clrn)
		if (~clrn)
			q = 1'b0;
		else
			q = t ^ q;
    assign qb = ~q;
endmodule

module counter10 (cnt_en, q, clk, rstn, enb, q_ant);
  	//Contador de Década (0 a 9)
	output [3:0] q; //Saída: Valor da contagem em BCD com 4 bits
  	output reg cnt_en; //Saída: Sinal de enable do próximo contador
  
  	input clk, rstn, enb; //Entrada: clock e reset síncrono, sinal de enable do contador atual
	input [3:0] q_ant; //Entrada: Sinal com o valor atual do contador anterior
  	
  	//Contador de décadas tradicional:
    wire [3:0] tv;
  	assign tv = {((q[3] & q[0])|(q[0] & q[1] & q[2]))& enb, (q[1] & q[0])& enb, (q[0] & ~q[3])& enb, (1'b1)& enb};
	
    genvar i;
    generate
       for (i=0; i<4; i=i+1)
         tff u0 (.q(q[i]), .qb(), .clk(clk), .clrn(rstn), .t(tv[i]));
    endgenerate
  	
  	//Controle do próximo contador: (sinal de enable)
  	always @(posedge clk) begin
      if(q == 4'b1001 && q_ant == 4'b1001) // Se a contagem do contador atual 
        //e do contador anterior valem 9 => ativa o próximo contador
      	cnt_en = 1'b1;
      else
        cnt_en = 1'b0; // Caso contrário, não ativa o próximo contador
  	end

endmodule

module counter999BCD (q1, q2, q3, clk, rstn);
  output [3:0] q1, q2, q3;//Saída: Valores BCD da contagem
  input clk, rstn; //Entrada: Sinal de clock e reset
   
  reg [2:0] cnt_en; // Sinais de enable dos contadores
  
  counter10 u0 (.q(q1), .cnt_en(cnt_en[0]), .clk(clk), .rstn(rstn), .enb(clk), .q_ant(4'b1001)); //Contador de Unidade
  counter10 d0 (.q(q2), .cnt_en(cnt_en[1]), .clk(clk), .rstn(rstn), .enb(cnt_en[0]), .q_ant(q1));//Contador de Dezena
  counter10 c0 (.q(q3), .cnt_en(cnt_en[2]), .clk(clk), .rstn(rstn), .enb(cnt_en[1]), .q_ant(q2));//Contador de Centena
  // Todos controlados pelos mesmo clock com reset síncrono
  
endmodule