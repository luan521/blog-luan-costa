---
title: "The Math of Betting"
date: 2022-03-31
description: "Using probability theory and information theory to derive the optimal long-term betting strategy — from the doubling rate and entropy to the injustice factor and Kuhn-Tucker conditions."
authors:
  - name: Luan Costa
---

{{< img src="images/the-math-of-betting-cover.png" alt="cover" style="float: right; width: 220px; border-radius: 12px; margin: 2rem 0 1.5rem 2rem;" >}}

Probability has its origin in the study of gambling and insurance in the 17th century. In this text, I will apply probability theory and other mathematical concepts (following [Thomas M.Cover](https://books.google.com.br/books?id=VWq5GG6ycxMC&printsec=frontcover&hl=pt-BR&source=gbs_ge_summary_r&cad=0#v=onepage&q&f=false)) to get the optimal strategy for a gambler who frequently bets on sites like bet365. We will use the two matches, represents in figures 1 and 2, as examples in some discussions.

{{< img src="images/the-math-of-betting-odds1.png" alt="Odds example 1" caption="Figure 1: Match odds example 1." style="float: right; width: 220px; border-radius: 12px; margin: 2rem 0 1.5rem 2rem;" >}}

{{< img src="images/the-math-of-betting-odds2.png" alt="Odds example 2" caption="Figure 2: Match odds example 2." style="float: right; width: 220px; border-radius: 12px; margin: 2rem 0 1.5rem 2rem;" >}}

Take $B$ as the gambler's bankroll in bet365, if he bets a fraction $b$ of $B$ on Barcelona, then in case Barcelona wins, the fraction bet is multiplied by $o = 2.25$ (the odds associated to this event), in such a way that the bankroll becomes $[(1-b) + o \cdot b] \cdot B$, if Barcelona don't win, the bankroll becomes $(1-b) \cdot B$, where $(1-b)$ is the fraction of $B$ that was not bet.

In general, the gambler doesn't need to concentrate all his bet on just one result, he can bet $b_1$ in $r_1$, $b_2$ in $r_2$, $b_3$ in $r_3$ and save a fraction $b_0$ (following the definitions 1 and 2). Following the previous argument, we can conclude that the gambler's bankroll becomes $[b_0 + o(X) \cdot b(X)] \cdot B$, where $X$ is the result of the game (a random variable) and $o(X)$, $b(X)$ are, respectively, the odds and the fraction of the bankroll bet in $X$. Setting $S(X) = b_0 + o(X) \cdot b(X)$, we have $B \to S(X) \cdot B$, that is, $B$ becomes $S(X) \cdot B$.

Now since the gambler will reinvest his money in another game after some time, a good abstraction here (to get the best strategy to the gambler in game1) is to consider that game1 will occur infinite times, independently and with the results having the same probabilities. After $n$ games1 (Barcelona vs Atlético de Madrid), let $X_1, X_2, \ldots, X_n$ be the results of each game (a sequence of random variables i.i.d), one can conclude by induction that the bankroll becomes:

$$B \to S_n \cdot B$$
$$S_n = \prod_{i=1}^{n} S(X_i)$$
$$S(X_i) = b_0 + o(X_i) \cdot b(X_i)$$

Therefore, given the probability values $(p_1, p_2, p_3)$ of the game1 results, and the odds values $(o_1=2.25, o_2=3.60, o_3=2.87)$ (Figure 1), the best strategy for the gambler, the values $b=(b_0, b_1, b_2, b_3)$, is the one that maximizes $S_n$, for large values of $n$, when thinking long term.

Here is the text from the image, formatted with LaTeX for the mathematical variables and expressions:

**Definition 1: Possible game results**
- $r_1$: home team wins
- $r_2$: tie
- $r_3$: away team wins

**Definition 2: Parameters of possible game results**
- $p_i$: probability of result $i$
- $o_i$: odds of result $i$
- $b_0$: fraction of $B$ that was not invested
- $b_i, i = 1, 2, 3$: fraction of $B$ invested in event $i$
- $b_0 + b_1 + b_2 + b_3 = 1$

In a realistic case, the factor $F = 1/o_1 + 1/o_2 + 1/o_3$ of the odds, will always satisfy the property $F > 1$. This happens because in the case when $F \leq 1$, it is possible for the gambler to follow a strategy in which he never loses, regardless of the outcome of the game. He can take $(b_0=0,\, b_1=1/o_1 F,\, b_2=1/o_2 F,\, b_3=1/o_3 F)$, in such a way that $S(X) = 1/F \geq 1$, for all results. However, as $F$ increases, the game becomes more "unfair" to the gambler, as it will be explored further.

**Definition 3: Injustice factor**
- $F = \dfrac{1}{o_1} + \dfrac{1}{o_2} + \dfrac{1}{o_3}$

As you can see, in game1 one has $F=1/2.25+1/3.60+1/2.87=1.07$, and for game2 we have $F=1/1.50+1/3.60+1/5.75=1.12$. Therefore, game2 is more "unfair" to the gambler than game1, this happens because Barcelona and Atlético de Madrid are world-renowned teams, unlike Náutico and Campinense, so game2 moves less money and so the bet365 needs to "make" the game more "unfair".
A simple case
For simplicity, we will first assume that the gambler distributes all of his wealth across the three possibilities, that is $b_0=0$, which implies $S(X)=o(X)\cdot b(X)$. This will lead us to a simple analytical solution, which will provide us some interesting insights.

**Definition 4:** The doubling rate of the gambler's bankroll is

$$W(b) = E(\log S(X)) = \sum_{i=1}^{3} p_i \log (b_i \cdot o_i),$$ 
$\log$ defined in base 2.

The definition of doubling rate is justified by the following theorem, which is a consequence of the weak law of large numbers.

**Theorem 1:** Let the game outcomes $X_1, X_2, \dots$ be i.i.d $\sim p(x)$. Then the wealth of the gambler using betting strategy $b$ grows exponentially at rate $W(b)$; that is:

$$S_n \to 2^{nW(b)}$$

The theorem 1 is telling us that $W(b)$ is the fundamental function for our analysis. When $W<0$ the bankroll exponentially decreases to zero, when $W=0$ the bankroll remains constant and finally when $W>0$ the bankroll grows exponentially. Furthermore, our task to find the best strategy comes down down to finding $b$ that maximizes $W$, which is provided by the next theorem.

**Theorem 2:** The optimum doubling rate is given by

$$W^* = \sum_{i=1}^{3} p_i \log o_i - H(p)$$

and is achieved by $(b_1^* = p_1, b_2^* = p_2, b_3^* = p_3)$

$$H(p) = -\sum_{i=1}^{3} p_i \log p_i$$

The function $H$ is the entropy of $p$, an important concept of information theory.
Therefore, if we take $b_0=0$ (all the bankroll is invested), and we have an estimate for the values of the probabilities $(p_1, p_2, p_3)$, then the best strategy for the gambler is betting on all possible results, with fractions of the bankroll $(b_1,b_2,b_3)$ equal to the probabilities $(p_1,p_2,p_3)$. This part of the theorem, which says what the best strategy is, will be proven, providing some interesting insights and we will further explore the concept of the injustice factor $F$, introduced in the definition 3.

Proof:

$$W(b) = \sum_{i=1}^{3} p_i \log (b_i \cdot o_i)$$

Let's replace $b$ by a variable $q$, such that the sum of $q$ is equal to 1 and we can manipulate it as a probability.

$$q_i = \frac{1}{o_i F} \to q_i \geq 0 \text{ and } \sum q_i = 1$$

$$W(b) = \sum_{i=1}^{3} p_i \log \left( \frac{b_i}{q_i} \frac{1}{F} \right)$$

With an algebraic manipulation:

$$W(b) = \sum_{i=1}^{3} p_i \log \left( \frac{p_i}{q_i} \frac{b_i}{p_i} \right) - \log F$$

$$W(b) = \sum_{i=1}^{3} p_i \log \left( \frac{p_i}{q_i} \right) - \sum_{i=1}^{3} p_i \log \left( \frac{p_i}{b_i} \right) - \log F$$

$$W(b) = [D(p||q) - D(p||b)] - \log F$$

Here, $D(x\|y)$ is the relative entropy between the two probability distributions $x$, $y$. Although it doesn't satisfy all the properties of a metric ($D(x\|y)$ is not equal to $D(y\|x)$ in general), the relative entropy is a good measure of the difference between two distributions, and it satisfies the property

$$
D(p||b) \geq 0
$$

with equality if and only if $b=p$. By the expression that we get to $W$, this concludes the proof of the condition of optimization.

We can go even further, the term $d=[D(p\|q)-D(p\|b)]$ shows a dispute between $q$ and $b$, to see who comes closest to the real distribution $p$. If the gambler wins this battle, $d$ is greater than zero, what contributes to the increase of the doubling rate $W$. However, the gambler also needs to overcome the injustice factor that appears in the expression. In the case for example that $d=0$ (the strategy $b$ is as close to the real distribution $p$ as $q$), we have

$$W(b) = [D(p||q) - D(p||b)] - \log F = -\log F \to$$

$$S_n \to 2^{-n \log F} = \frac{1}{F^n}$$

These results justify the definition of $F$ as a factor of injustice. The distribution $q = (1/o_1 F, 1/o_2 F, 1/o_3 F)$ is an estimate of the real distribution of results $p=(p_1,p_2,p_3)$. If many people believe that result $r_1$ will happen and bet money on it, bet365 needs to decrease $o_1 \cdot F$ which increases $q_1$, so $q$ is an estimate of what the average of people believe. The challenge for the gambler is to measure $p$ better than most people ($d=D(p\|q)-D(p\|b)>0$) and surpass the injustice factor ($d > \log F$).

## General case

As we see, the hypothesis that the gambler distributes all of his wealth across the three possibilities ($b_0=0$) implies a simple analytical solution to the gambler's optimal strategy. But in practice, in most matches, it is not worth betting, and in some cases it is worth betting on only a few results.
For these possibilities to appear in a mathematical solution, we must remove the condition $b_0=0$. In this general case, the theorem 1 continues to be true if we change the definition of the doubling rate to the following:

**Definition 5:** The doubling rate of the gambler's bankroll, in the general case, is

$$W(b) = \sum_{i=1}^{3} p_i \log (b_0 + b_i \cdot o_i)$$

This simple change makes the problem of maximizing $W$ considerably more complicated. If we apply the Lagrange multipliers over the restriction ($b_0+b_1+b_2+b_3=1$), we get

$$\mathcal{L}(b, \lambda) = \sum_{i=1}^{3} p_i \log (b_0 + b_i \cdot o_i) + \lambda \sum_{i=0}^{3} b_i - \lambda$$

To include restrictions $b_i \geq 0 \; \forall i$, we have to use the Kuhn-Tucker conditions. The conditions describe the behavior of the derivative at the maximum of a concave function over a convex region. For any coordinate which is in the interior of the region, the derivative should be 0. For any coordinate on the boundary, the derivative should be negative in the direction towards the interior of the region. The application of the Kuhn-Tucker method to the present maximization results in the three conditions below. If we find $(b_0, b_1, b_2, b_3)$ that satisfies the three conditions for some $\lambda$, then this is the best strategy for the gambler, thinking long therm.

1. $$i = 1, 2, 3 \to \frac{\partial \mathcal{L}}{\partial b_i} = \frac{p_i o_i}{b_0 + b_i o_i} + \lambda (\leq 0 \text{ if } b_i = 0; = 0 \text{ if } b_i > 0)$$

2. $$\frac{\partial \mathcal{L}}{\partial b_0} = \sum_{i=0}^{3} \frac{p_i}{b_0 + b_i o_i} + \lambda ( \leq 0 \text{ if } b_0 = 0; = 0 \text{ if } b_0 > 0)$$

3. $$\sum_{i=0}^{3} b_i = 1$$

Let's use this result to answer some natural questions.

**When should the gambler bet all his bankroll on the match ($b_0=0$, the simple case discussed above)?**

We already know that in this case the best strategy is $(b_1=p_1, b_2=p_2, b_3=p_3)$. 

Replacing this in condition 1:

$$\sum_{i=0}^{3} \frac{p_i}{b_0} + \lambda = 0 \to -\lambda = \frac{1}{b_0}$$

Now using condition 2:

$$\sum_{i=0}^{3} \frac{p_i}{p_i o_i} + \lambda \leq 0 \to F = \sum_{i=0}^{3} \frac{1}{o_i} \leq 1$$

Therefore, the optimal strategy for the gambler is bet all his bankroll on the match if and only if the injustice factor $F$ is less than or equal to 1. As it has been emphasized before, this never happens in practice, but the true optimal solution tends to $(b_1=p_1, b_2=p_2, b_3=p_3)$ as $F$ decreases.

**When should the gambler not bet any money on the match ($b_0=1$)?**

Condition 3 implies that $b_i=0$ for $i=1,2,3$. Replacing this in condition 2:

$$\sum_{i=0}^{3} \frac{p_i}{b_0} + \lambda = 0 \to -\lambda = \frac{1}{b_0}$$

Now using condition 1:

$$\frac{p_i o_i}{b_0} + \lambda \leq 0 \to \frac{p_i o_i}{b_0} \leq \frac{1}{b_0}$$

$$p_i o_i \leq 1 \quad \forall i = 1, 2, 3$$

Therefore, the optimal strategy for the gambler is not to bet any money if and only if the product of the probability of the result times the odds is less than or equal to 1 for all possible results, which is quite intuitive.

In the case when $p_i \cdot o_i > 1$ for some $i$, the conditions are no longer satisfied by $b_0 = 1$. The gambler should then invest some money in the match, however, since the denominator of the expressions in conditions 1 and 2 also changes, more than one possible result may now violate the conditions. Hence, the optimal solution may involve investing in some possible result with $p_i \cdot o_i \leq 1$, which is counterintuitive.

There is no analytical form for the solution in this case. The conditions 1, 2 and 3 for this case do not give rise to an explicit solution. Instead, we can formulate an algorithm for finding the optimal strategy.
The general optimal strategy

1. Order the possible results, in such a way that $p_1 o_1 \geq p_2 o_2 \geq p_3 o_3$

2. Define

$$C_k = \frac{1 - \sum_{i=1}^{k} p_i}{1 - \sum_{i=1}^{k} 1/o_i} (\text{ if } k \geq 1)$$
$$C_k = 1 (\text{if } k = 0)$$

3. Define

$$t = \min n \mid p_{n+1}o_{n+1} \leq C_n$$

4. The optimal strategy for the gambler in the general case, thinking long term, is given by

$$b_0 = C_t$$

$$i = 1, 2, \dots, t \to b_i = p_i - \frac{C_t}{o_i}$$

$$i = t + 1, \dots, 3 \to b_i = 0$$

The values $(b_0, b_1, b_2, b_3)$ generated by the algorithm satisfy the three conditions and so it is the optimal strategy for the gambler. This text takes into account a bet type that has only three possible results, but the reasonings can be extended for any type of bet with $N$ mutually exclusive possible results.