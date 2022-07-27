//Contador de 0 a 999 em 7 segmentos

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

module bin27seg (a, b, c, d, e, f, g, v);
  //Decodificador BCD para 7 segmentos
  output a, b, c, d, e, f, g; //Saída: 7 sinais para o display 7seg
  
  input [3:0] v; //Entrada: Sinal BCD 4 bits
  
  //Identifica o valor BCD de V e ativa os segmentos correspondentes:
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

module counter1000 (uni, dez, cen, clk, rstn);
  output [6:0] uni, dez, cen; //Saída: 3 barramentos com a contagem para display 7 seg
  
  input clk, rstn; //Entrada: Sinal de clock e reset
  
  reg [3:0] q1,q2,q3; //Sinais intermediários (valor BCD da contagem)
  // q1 -> unidade (em BCD)
  // q2 -> dezena (em BCD)
  // q3 -> centena (em BCD)  
  reg [2:0] cnt_en; // Sinais de enable dos contadores
  
  counter10 u0 (.q(q1), .cnt_en(cnt_en[0]), .clk(clk), .rstn(rstn), .enb(clk), .q_ant(4'b1001)); //Contador de Unidade
  counter10 d0 (.q(q2), .cnt_en(cnt_en[1]), .clk(clk), .rstn(rstn), .enb(cnt_en[0]), .q_ant(q1));//Contador de Dezena
  counter10 c0 (.q(q3), .cnt_en(cnt_en[2]), .clk(clk), .rstn(rstn), .enb(cnt_en[1]), .q_ant(q2));//Contador de Centena
  // Todos controlados pelos mesmo clock com reset síncrono
  
  //Decodificador BCD para 7 segmentos:
  bin27seg du (.a(uni[0]), .b(uni[1]), .c(uni[2]), .d(uni[3]), .e(uni[4]), .f(uni[5]), .g(uni[6]), .v(q1)); // Decodificador da Unidade
  bin27seg dd (.a(dez[0]), .b(dez[1]), .c(dez[2]), .d(dez[3]), .e(dez[4]), .f(dez[5]), .g(dez[6]), .v(q2)); // Decodificador da Dezena
  bin27seg dc (.a(cen[0]), .b(cen[1]), .c(cen[2]), .d(cen[3]), .e(cen[4]), .f(cen[5]), .g(cen[6]), .v(q3)); // Decodificador da Centena
  
  //uni -> saída unidade em 7 segmentos
  //dez -> saída dezena em 7 segmentos
  //cen -> saída centena em 7 segmentos
endmodule