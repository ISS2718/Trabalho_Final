---

# Controlador

O [módulo do controlador](/Contador999 - Parte3/contador_comentado_v2.v) é uma máquina de estados finitos para controlar um conversor analógico digital de rampa dupla. Este modulo é definido da seguinte forma:

```module controlador (inicio, clk, ch_vm, ch_ref, ch_zr, rst_s, Vint_z,desc_u,desc_d,desc_c);```

## Entradas

As entradas são: 

```inicio, clk, Vint_z e rst_s``` 
    
Elas representam o sinal de enable do controlador, o clock, a tensão de saída no circuito integrador e o sinal de reset síncrono.

## Saidas

As saídas são: 

```ch_vm, ch_ref, ch_zr, desc_u, desc_d e desc_c``` 
    
Que são os sinais de controle das chaves vm, ref e zr e a unidade, dezena e centena do tempo de descarga medido pelo contador.

## Maquina de Estados

Foram definidos 3 estados: carregar, descarregar e zerar. 

### Carregar

No estado carregar a máquina aciona a chave vm e aguarda o contador chegar em 999, quando isso ocorre ela liga o sinal enb_3 e muda para o estado descarregar. 

### Descarregar

Esse segundo estado começa a contar novamente, liga a chave vm e aguarda a tensão de saída do integrador ser 0, medindo o tempo de descarga; quando isso acontece o tempo de descarga é registrado nos sinais de saída definidos anteriormente e a máquina muda para o estado zerar. 

### Zerar

O último estado liga a chave zr e aguarda a tensão de saída do integrador ser 0, quando isso acontece a máquina volta para o estado carregar e começa outra medição.

## Utilização

Para iniciar a medição usa-se o sinal de início. Deve-se colocar este sinal valendo 1 para que o circuito vá para o estado padrão (zerar). Em seguida deve-se desativar o sinal de início e aguardar a tensão de saída do circuito integrador ser 0, ou seja, Vint_z = 1, para que o circuito mude para o estado carregar e inicie a medição.

## Cicuito RTL

![Ciruito RTL do Modulo Controlador](/imgs/RTL_Circuit_Controlador_Module.png)

---