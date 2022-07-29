# Contador 999

Para o modulo contador de 0 a 999 foram feitas duas variações do circuito: a primeira apresenta os resultados BCD e a segunda converte a contagem para sinais 7 segmentos, de forma que é possível rearranjar os sinais de saída para simular displays de 7 segmentos.

Em ambas implementações, o funcionamento do contador999 baseia-se no uso de 3 contadores de década adaptados para receber e emitir um sinal de enable que permite que um contador ative ou desative outro. Assim, implementamos o circuito de forma que o contador da dezena conta quando o contador da unidade está em “9” e o contador da centena quando os contadores da unidade e da dezena estão em “9”.

## Entradas
Em ambos os circuitos ```clk, rstn``` são as entradas: o clock e o reset com borda negativa, respectivamente. 

## [Módulo BCD](/Contador999/contador999_BCD.v)
O contador com saída BCD é definido da seguinte forma:

```module counter999BCD (q1, q2, q3, clk, rstn);```

### Saídas

As saídas ```q1, q2 e q3``` são barramentos com os valores BCD da contagem sendo q1 a unidade, q2 a dezena e q3 a centena.

### Circuito RTL

![Ciruito RTL do Modulo Contador999_BCD](/imgs/RTL_Circuit_Contador999_BCD_Module.png)

## [Módulo 7 Seg](/Contador999/contador999_7seg.v)

O contador com saída 7 segmentos é definido da seguinte forma:

```module counter9997seg (u0,u1,u2,u3,u4,u5,u6,d0,d1,d2,d3,d4,d5,d6,c0,c1,c2,c3,c4,c5,c6, clk, rstn);```

### Saídas

As saídas ```u_, d_, c_``` são os fios dos displays 7 segmentos da unidade, dezena e centena, respectivamente. O fio ```u0``` representa o segmento “a” do display da unidade e o fio ```u6``` o segmento “g”, o mesmo padrão ocorre de forma análoga com os outros fios.

### Circuito RTL

![Ciruito RTL do Modulo Contador999_7seg](/imgs/RTL_Circuit_Contador999_7seg_Module.png)