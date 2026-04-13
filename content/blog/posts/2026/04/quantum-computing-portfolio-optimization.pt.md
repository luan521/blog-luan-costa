---
title: "Computação Quântica para Otimização de Portfólio: Uma Visão Prática"
date: 2026-04-01
description: "Uma visão prática de como algoritmos quânticos abordam a otimização de portfólio, desde formulações QUBO até fluxos de trabalho quântico-clássicos híbridos."
authors:
  - name: Luan Costa
---

## O Problema

A otimização de portfólio busca o vetor de pesos $\mathbf{w} \in \mathbb{R}^n$ que maximiza o índice de Sharpe:

$$
\max_{\mathbf{w}} \; \frac{\mathbf{w}^\top \boldsymbol{\mu} - r_f}{\sqrt{\mathbf{w}^\top \boldsymbol{\Sigma} \mathbf{w}}}
$$

sujeito a $\sum_i w_i = 1$ e $w_i \geq 0$, onde $\boldsymbol{\mu}$ é o vetor de retornos esperados e $\boldsymbol{\Sigma}$ é a matriz de covariância dos retornos dos ativos.

Para universos de ativos grandes, isso se torna um programa quadrático de alta dimensão. Quando restrições binárias de seleção de ativos são adicionadas (incluir ou excluir cada ativo), o problema se torna NP-difícil.

## Formulação QUBO

Algoritmos quânticos como o QAOA operam sobre variáveis binárias. O problema de portfólio é reformulado como uma Otimização Binária Quadrática Irrestrita (QUBO):

$$
\min_{\mathbf{x} \in \{0,1\}^n} \; \mathbf{x}^\top Q \mathbf{x}
$$

onde a matriz $Q$ codifica tanto o objetivo de retorno quanto a penalidade de risco. O QUBO é então mapeado para um Hamiltoniano de Ising $H_C$ via a substituição $x_i = \frac{1 - \sigma_i^z}{2}$.

## Fluxo de Trabalho Híbrido

Executar o QAOA em hardware NISQ atual requer um laço híbrido:

1. Preparar o estado parametrizado $|\psi(\boldsymbol{\gamma}, \boldsymbol{\beta})\rangle$ no processador quântico
2. Medir o valor esperado $\langle H_C \rangle$
3. Atualizar $(\boldsymbol{\gamma}, \boldsymbol{\beta})$ via um otimizador clássico (e.g. COBYLA, L-BFGS-B)
4. Repetir até a convergência

A razão de aproximação $r = \langle H_C \rangle / H_C^*$ — onde $H_C^*$ é o ótimo verdadeiro — mede a qualidade da solução. Circuitos mais profundos (maior $p$) produzem melhores razões ao custo de maior sensibilidade ao ruído.

## Perspectivas

Computadores quânticos tolerantes a falhas permitirão a avaliação exata de $\langle H_C \rangle$ sem ruído de medição, tornando a otimização quântica de portfólio genuinamente competitiva. Até lá, abordagens híbridas combinadas com inicialização generativa de parâmetros (ver post anterior) representam o caminho mais promissor no curto prazo.
