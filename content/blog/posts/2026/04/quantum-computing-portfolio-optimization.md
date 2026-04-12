---
title: "Quantum Computing for Portfolio Optimization: A Practical Overview"
date: 2026-04-01
description: "A practical look at how quantum algorithms tackle portfolio optimization, from QUBO formulations to hybrid quantum-classical workflows."
authors:
  - name: Luan Costa
---

## The Problem

Portfolio optimization seeks the weight vector $\mathbf{w} \in \mathbb{R}^n$ that maximizes the Sharpe ratio:

$$
\max_{\mathbf{w}} \; \frac{\mathbf{w}^\top \boldsymbol{\mu} - r_f}{\sqrt{\mathbf{w}^\top \boldsymbol{\Sigma} \mathbf{w}}}
$$

subject to $\sum_i w_i = 1$ and $w_i \geq 0$, where $\boldsymbol{\mu}$ is the vector of expected returns and $\boldsymbol{\Sigma}$ is the covariance matrix of asset returns.

For large asset universes, this becomes a high-dimensional quadratic program. When binary asset selection constraints are added (include or exclude each asset), the problem becomes NP-hard.

## QUBO Formulation

Quantum algorithms such as QAOA operate on binary variables. The portfolio problem is reformulated as a Quadratic Unconstrained Binary Optimization (QUBO):

$$
\min_{\mathbf{x} \in \{0,1\}^n} \; \mathbf{x}^\top Q \mathbf{x}
$$

where the matrix $Q$ encodes both the return objective and the risk penalty. The QUBO is then mapped to an Ising Hamiltonian $H_C$ via the substitution $x_i = \frac{1 - \sigma_i^z}{2}$.

## Hybrid Workflow

Running QAOA on current NISQ hardware requires a hybrid loop:

1. Prepare the parameterized state $|\psi(\boldsymbol{\gamma}, \boldsymbol{\beta})\rangle$ on the quantum processor
2. Measure the expectation value $\langle H_C \rangle$
3. Update $(\boldsymbol{\gamma}, \boldsymbol{\beta})$ via a classical optimizer (e.g. COBYLA, L-BFGS-B)
4. Repeat until convergence

The approximation ratio $r = \langle H_C \rangle / H_C^*$ — where $H_C^*$ is the true optimum — measures solution quality. Deeper circuits (higher $p$) yield better ratios at the cost of increased noise sensitivity.

## Outlook

Fault-tolerant quantum computers will enable exact evaluation of $\langle H_C \rangle$ without shot noise, making quantum portfolio optimization genuinely competitive. Until then, hybrid approaches combined with generative parameter initialization (see previous post) represent the most promising near-term path.
