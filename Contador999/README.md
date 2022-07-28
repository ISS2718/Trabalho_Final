# Contador 
---

O módulo do controlador é uma máquina de estados finitos para controlar um conversor analógico digital de rampa dupla. Este modulo é definido da seguinte forma:

```module controlador (inicio, clk, ch_vm, ch_ref, ch_zr, rst_s, Vint_z,desc_u,desc_d,desc_c);```

## Entradas

    As entradas são: 
        ```inicio, clk, Vint_z e rst_s``` 
    Elas representam o sinal de enable do controlador, o clock, a tensão de saída no circuito integrador e o sinal de reset síncrono.

## Saidas

    As saídas são: 
        ```ch_vm, ch_ref, ch_zr, desc_u, desc_d e desc_c``` 
    Que são os sinais de controle das chaves vm, ref e zr e a unidade, dezena e centena do tempo de descarga medido pelo contador.