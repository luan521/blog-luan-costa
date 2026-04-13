---
title: "Generative QAOA and Its Application to Portfolio Optimization"
date: 2025-04-01
description: "An overview of how decoder-only Transformer architectures can be used to optimize QAOA circuit parameters for portfolio optimization problems."
authors:
  - name: Luan Costa
---

## Introduction

{{< img src="images/scs.png" alt="SCS circuit" style="float: right; width: 220px; border-radius: 12px; margin: 2rem 0 1.5rem 2rem;" >}}

Portfolio optimization is a classical combinatorial problem: given a set of assets, find the allocation that maximizes expected return for a given level of risk. As the number of assets grows, the problem becomes computationally intractable for classical solvers.

The Quantum Approximate Optimization Algorithm (QAOA) is a hybrid quantum-classical approach that encodes the problem as a parameterized quantum circuit. The quality of the solution depends heavily on finding good circuit parameters $\boldsymbol{\gamma}$ and $\boldsymbol{\beta}$.

## The Generative QAOA Approach

Instead of optimizing parameters from scratch for each problem instance, we train a decoder-only Transformer to **generate** near-optimal QAOA parameters directly.

Given a problem graph $G = (V, E)$, the model learns the conditional distribution:

$$
p(\boldsymbol{\gamma}, \boldsymbol{\beta} \mid G)
$$

The Transformer is trained on a dataset of solved QAOA instances, learning to produce parameters that yield high approximation ratios without iterative classical optimization at inference time.

## Results

On portfolio instances with up to 20 assets, the generative model achieves approximation ratios competitive with standard QAOA optimizers, at a fraction of the wall-clock time — since parameter generation requires a single forward pass through the model.
