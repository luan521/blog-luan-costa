---
title: "QAOA Generativo e sua Aplicação à Otimização de Portfólio"
date: 2025-04-01
description: "Uma visão geral de como arquiteturas Transformer decoder-only podem ser usadas para otimizar os parâmetros de circuitos QAOA em problemas de otimização de portfólio."
authors:
  - name: Luan Costa
---

## Introdução

A otimização de portfólio é um problema combinatório clássico: dado um conjunto de ativos, encontrar a alocação que maximiza o retorno esperado para um dado nível de risco. À medida que o número de ativos cresce, o problema se torna computacionalmente intratável para solvers clássicos.

O Quantum Approximate Optimization Algorithm (QAOA) é uma abordagem híbrida quântico-clássica que codifica o problema como um circuito quântico parametrizado. A qualidade da solução depende fortemente de encontrar bons parâmetros de circuito $\boldsymbol{\gamma}$ e $\boldsymbol{\beta}$.

## A Abordagem do QAOA Generativo

Em vez de otimizar os parâmetros do zero para cada instância do problema, treinamos um Transformer decoder-only para **gerar** parâmetros QAOA próximos do ótimo diretamente.

Dado um grafo de problema $G = (V, E)$, o modelo aprende a distribuição condicional:

$$
p(\boldsymbol{\gamma}, \boldsymbol{\beta} \mid G)
$$

O Transformer é treinado em um conjunto de dados de instâncias QAOA resolvidas, aprendendo a produzir parâmetros que geram altas razões de aproximação sem otimização clássica iterativa no momento da inferência.

## Resultados

Em instâncias de portfólio com até 20 ativos, o modelo generativo alcança razões de aproximação competitivas com otimizadores QAOA padrão, em uma fração do tempo de relógio — já que a geração de parâmetros requer apenas uma passagem direta pelo modelo.
