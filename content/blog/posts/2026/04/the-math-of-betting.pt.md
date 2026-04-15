---
title: "A Matemática das Apostas"
date: 2026-04-14
description: "Usando teoria das probabilidades e teoria da informação para derivar a estratégia ótima de apostas a longo prazo — da taxa de duplicação e entropia ao fator de injustiça e condições de Kuhn-Tucker."
authors:
  - name: Luan Costa
---

{{< img src="images/the-math-of-betting-cover.png" alt="cover" style="float: right; width: 220px; border-radius: 12px; margin: 2rem 0 1.5rem 2rem;" >}}

A probabilidade tem sua origem no estudo do jogo e dos seguros no século XVII. Neste texto, aplicarei a teoria das probabilidades e outros conceitos matemáticos (seguindo [Thomas M. Cover](https://books.google.com.br/books?id=VWq5GG6ycxMC&printsec=frontcover&hl=pt-BR&source=gbs_ge_summary_r&cad=0#v=onepage&q&f=false)) para obter a estratégia ótima de um apostador que frequentemente aposta em sites como a bet365. Usaremos as duas partidas, representadas nas figuras 1 e 2, como exemplos em algumas discussões.

{{< img src="images/the-math-of-betting-odds1.png" alt="Exemplo de odds 1" caption="Figura 1: Exemplo de odds da partida 1." style="float: right; width: 220px; border-radius: 12px; margin: 2rem 0 1.5rem 2rem;" >}}

{{< img src="images/the-math-of-betting-odds2.png" alt="Exemplo de odds 2" caption="Figura 2: Exemplo de odds da partida 2." style="float: right; width: 220px; border-radius: 12px; margin: 2rem 0 1.5rem 2rem;" >}}

Tome $B$ como o bankroll do apostador na bet365. Se ele apostar uma fração $b$ de $B$ no Barcelona, então, caso o Barcelona vença, a fração apostada é multiplicada por $o = 2.25$ (as odds associadas a este evento), de modo que o bankroll se torna $[(1-b) + o \cdot b] \cdot B$. Se o Barcelona não vencer, o bankroll se torna $(1-b) \cdot B$, onde $(1-b)$ é a fração de $B$ que não foi apostada.

Em geral, o apostador não precisa concentrar toda a sua aposta em um único resultado — ele pode apostar $b_1$ em $r_1$, $b_2$ em $r_2$, $b_3$ em $r_3$ e guardar uma fração $b_0$ (seguindo as definições 1 e 2). Pelo argumento anterior, concluímos que o bankroll do apostador se torna $[b_0 + o(X) \cdot b(X)] \cdot B$, onde $X$ é o resultado do jogo (uma variável aleatória) e $o(X)$, $b(X)$ são, respectivamente, as odds e a fração do bankroll apostada em $X$. Definindo $S(X) = b_0 + o(X) \cdot b(X)$, temos $B \to S(X) \cdot B$, ou seja, $B$ se torna $S(X) \cdot B$.

Como o apostador reinvestirá seu dinheiro em outro jogo após algum tempo, uma boa abstração (para obter a melhor estratégia no jogo1) é considerar que o jogo1 ocorrerá infinitas vezes, de forma independente e com os resultados tendo as mesmas probabilidades. Após $n$ jogos1 (Barcelona vs Atlético de Madrid), seja $X_1, X_2, \ldots, X_n$ os resultados de cada jogo (uma sequência de variáveis aleatórias i.i.d), pode-se concluir por indução que o bankroll se torna:

$$B \to S_n \cdot B$$
$$S_n = \prod_{i=1}^{n} S(X_i)$$
$$S(X_i) = b_0 + o(X_i) \cdot b(X_i)$$

Portanto, dados os valores de probabilidade $(p_1, p_2, p_3)$ dos resultados do jogo1 e os valores de odds $(o_1=2.25, o_2=3.60, o_3=2.87)$ (Figura 1), a melhor estratégia para o apostador, os valores $b=(b_0, b_1, b_2, b_3)$, é aquela que maximiza $S_n$ para grandes valores de $n$, pensando a longo prazo.

**Definição 1: Possíveis resultados do jogo**
- $r_1$: time da casa vence
- $r_2$: empate
- $r_3$: time visitante vence

**Definição 2: Parâmetros dos possíveis resultados**
- $p_i$: probabilidade do resultado $i$
- $o_i$: odds do resultado $i$
- $b_0$: fração de $B$ não investida
- $b_i, i = 1, 2, 3$: fração de $B$ investida no evento $i$
- $b_0 + b_1 + b_2 + b_3 = 1$

Em um caso realista, o fator $F = 1/o_1 + 1/o_2 + 1/o_3$ das odds sempre satisfará a propriedade $F > 1$. Isso ocorre porque, no caso em que $F \leq 1$, é possível ao apostador seguir uma estratégia em que nunca perde, independentemente do resultado do jogo. Ele pode tomar $(b_0=0,\, b_1=1/o_1 F,\, b_2=1/o_2 F,\, b_3=1/o_3 F)$, de tal forma que $S(X) = 1/F \geq 1$ para todos os resultados. Contudo, à medida que $F$ aumenta, o jogo se torna mais "injusto" para o apostador, como será explorado adiante.

**Definição 3: Fator de injustiça**
- $F = \dfrac{1}{o_1} + \dfrac{1}{o_2} + \dfrac{1}{o_3}$

Como se pode ver, no jogo1 tem-se $F=1/2.25+1/3.60+1/2.87=1.07$, e para o jogo2 temos $F=1/1.50+1/3.60+1/5.75=1.12$. Portanto, o jogo2 é mais "injusto" para o apostador do que o jogo1 — isso ocorre porque Barcelona e Atlético de Madrid são times de renome mundial, ao contrário de Náutico e Campinense, de modo que o jogo2 movimenta menos dinheiro e a bet365 precisa tornar o jogo mais "injusto".

## Um caso simples

Para simplificar, assumiremos primeiro que o apostador distribui toda a sua riqueza entre as três possibilidades, ou seja, $b_0=0$, o que implica $S(X)=o(X)\cdot b(X)$. Isso nos levará a uma solução analítica simples, que fornecerá insights interessantes.

**Definição 4:** A taxa de duplicação do bankroll do apostador é

$$W(b) = E(\log S(X)) = \sum_{i=1}^{3} p_i \log (b_i \cdot o_i),$$
$\log$ definido na base 2.

A definição da taxa de duplicação é justificada pelo seguinte teorema, que é uma consequência da lei fraca dos grandes números.

**Teorema 1:** Seja os resultados do jogo $X_1, X_2, \dots$ i.i.d $\sim p(x)$. Então a riqueza do apostador usando a estratégia de aposta $b$ cresce exponencialmente à taxa $W(b)$; ou seja:

$$S_n \to 2^{nW(b)}$$

O teorema 1 nos diz que $W(b)$ é a função fundamental para nossa análise. Quando $W<0$, o bankroll diminui exponencialmente para zero; quando $W=0$, o bankroll permanece constante; e quando $W>0$, o bankroll cresce exponencialmente. Além disso, nossa tarefa de encontrar a melhor estratégia se resume a encontrar $b$ que maximiza $W$, o que é dado pelo próximo teorema.

**Teorema 2:** A taxa de duplicação ótima é dada por

$$W^* = \sum_{i=1}^{3} p_i \log o_i - H(p)$$

e é alcançada por $(b_1^* = p_1, b_2^* = p_2, b_3^* = p_3)$

$$H(p) = -\sum_{i=1}^{3} p_i \log p_i$$

A função $H$ é a entropia de $p$, um conceito importante da teoria da informação.
Portanto, se tomarmos $b_0=0$ (todo o bankroll é investido) e tivermos uma estimativa para os valores das probabilidades $(p_1, p_2, p_3)$, então a melhor estratégia para o apostador é apostar em todos os resultados possíveis, com frações do bankroll $(b_1,b_2,b_3)$ iguais às probabilidades $(p_1,p_2,p_3)$. Esta parte do teorema, que diz qual é a melhor estratégia, será provada a seguir, trazendo insights interessantes, e exploraremos mais o conceito do fator de injustiça $F$, introduzido na definição 3.

Prova:

$$W(b) = \sum_{i=1}^{3} p_i \log (b_i \cdot o_i)$$

Vamos substituir $b$ por uma variável $q$, tal que a soma de $q$ seja igual a 1 e possamos manipulá-la como uma probabilidade.

$$q_i = \frac{1}{o_i F} \to q_i \geq 0 \text{ e } \sum q_i = 1$$

$$W(b) = \sum_{i=1}^{3} p_i \log \left( \frac{b_i}{q_i} \frac{1}{F} \right)$$

Com uma manipulação algébrica:

$$W(b) = \sum_{i=1}^{3} p_i \log \left( \frac{p_i}{q_i} \frac{b_i}{p_i} \right) - \log F$$

$$W(b) = \sum_{i=1}^{3} p_i \log \left( \frac{p_i}{q_i} \right) - \sum_{i=1}^{3} p_i \log \left( \frac{p_i}{b_i} \right) - \log F$$

$$W(b) = [D(p||q) - D(p||b)] - \log F$$

Aqui, $D(x\|y)$ é a entropia relativa entre as duas distribuições de probabilidade $x$, $y$. Embora não satisfaça todas as propriedades de uma métrica ($D(x\|y)$ não é igual a $D(y\|x)$ em geral), a entropia relativa é uma boa medida da diferença entre duas distribuições e satisfaz a propriedade

$$D(p||b) \geq 0$$

com igualdade se e somente se $b=p$. Pela expressão que chegamos para $W$, isso conclui a prova da condição de otimização.

Podemos ir ainda mais longe: o termo $d=[D(p\|q)-D(p\|b)]$ mostra uma disputa entre $q$ e $b$ para ver quem se aproxima mais da distribuição real $p$. Se o apostador vence essa batalha, $d$ é maior que zero, o que contribui para o aumento da taxa de duplicação $W$. No entanto, o apostador também precisa superar o fator de injustiça que aparece na expressão. No caso em que $d=0$ (a estratégia $b$ está tão próxima da distribuição real $p$ quanto $q$), temos

$$W(b) = [D(p||q) - D(p||b)] - \log F = -\log F \to$$

$$S_n \to 2^{-n \log F} = \frac{1}{F^n}$$

Esses resultados justificam a definição de $F$ como fator de injustiça. A distribuição $q = (1/o_1 F, 1/o_2 F, 1/o_3 F)$ é uma estimativa da distribuição real dos resultados $p=(p_1,p_2,p_3)$. Se muitas pessoas acreditam que o resultado $r_1$ acontecerá e apostam dinheiro nisso, a bet365 precisa diminuir $o_1 \cdot F$, o que aumenta $q_1$; portanto, $q$ é uma estimativa do que a média das pessoas acredita. O desafio para o apostador é medir $p$ melhor do que a maioria ($d=D(p\|q)-D(p\|b)>0$) e superar o fator de injustiça ($d > \log F$).

## Caso geral

Como vimos, a hipótese de que o apostador distribui toda a sua riqueza entre as três possibilidades ($b_0=0$) implica uma solução analítica simples para a estratégia ótima. Mas na prática, na maioria das partidas, não vale a pena apostar, e em alguns casos vale a pena apostar em apenas alguns resultados.
Para que essas possibilidades apareçam na solução matemática, devemos remover a condição $b_0=0$. Neste caso geral, o teorema 1 continua válido se alterarmos a definição da taxa de duplicação para:

**Definição 5:** A taxa de duplicação do bankroll do apostador, no caso geral, é

$$W(b) = \sum_{i=1}^{3} p_i \log (b_0 + b_i \cdot o_i)$$

Essa simples mudança torna o problema de maximizar $W$ consideravelmente mais complicado. Se aplicarmos os multiplicadores de Lagrange sobre a restrição ($b_0+b_1+b_2+b_3=1$), obtemos

$$\mathcal{L}(b, \lambda) = \sum_{i=1}^{3} p_i \log (b_0 + b_i \cdot o_i) + \lambda \sum_{i=0}^{3} b_i - \lambda$$

Para incluir as restrições $b_i \geq 0 \; \forall i$, precisamos usar as condições de Kuhn-Tucker. As condições descrevem o comportamento da derivada no máximo de uma função côncava sobre uma região convexa. Para qualquer coordenada no interior da região, a derivada deve ser 0. Para qualquer coordenada na fronteira, a derivada deve ser negativa na direção do interior. A aplicação do método de Kuhn-Tucker à presente maximização resulta nas três condições abaixo. Se encontrarmos $(b_0, b_1, b_2, b_3)$ que satisfaça as três condições para algum $\lambda$, essa é a melhor estratégia para o apostador a longo prazo.

1. $$i = 1, 2, 3 \to \frac{\partial \mathcal{L}}{\partial b_i} = \frac{p_i o_i}{b_0 + b_i o_i} + \lambda (\leq 0 \text{ se } b_i = 0; = 0 \text{ se } b_i > 0)$$

2. $$\frac{\partial \mathcal{L}}{\partial b_0} = \sum_{i=0}^{3} \frac{p_i}{b_0 + b_i o_i} + \lambda ( \leq 0 \text{ se } b_0 = 0; = 0 \text{ se } b_0 > 0)$$

3. $$\sum_{i=0}^{3} b_i = 1$$

Vamos usar esse resultado para responder algumas perguntas naturais.

**Quando o apostador deve apostar todo o seu bankroll na partida ($b_0=0$, o caso simples discutido acima)?**

Já sabemos que nesse caso a melhor estratégia é $(b_1=p_1, b_2=p_2, b_3=p_3)$.

Substituindo na condição 1:

$$\sum_{i=0}^{3} \frac{p_i}{b_0} + \lambda = 0 \to -\lambda = \frac{1}{b_0}$$

Agora usando a condição 2:

$$\sum_{i=0}^{3} \frac{p_i}{p_i o_i} + \lambda \leq 0 \to F = \sum_{i=0}^{3} \frac{1}{o_i} \leq 1$$

Portanto, a estratégia ótima para o apostador é apostar todo o bankroll na partida se e somente se o fator de injustiça $F$ for menor ou igual a 1. Como enfatizado anteriormente, isso nunca ocorre na prática, mas a solução ótima real tende a $(b_1=p_1, b_2=p_2, b_3=p_3)$ à medida que $F$ diminui.

**Quando o apostador não deve apostar nenhum dinheiro na partida ($b_0=1$)?**

A condição 3 implica que $b_i=0$ para $i=1,2,3$. Substituindo na condição 2:

$$\sum_{i=0}^{3} \frac{p_i}{b_0} + \lambda = 0 \to -\lambda = \frac{1}{b_0}$$

Agora usando a condição 1:

$$\frac{p_i o_i}{b_0} + \lambda \leq 0 \to \frac{p_i o_i}{b_0} \leq \frac{1}{b_0}$$

$$p_i o_i \leq 1 \quad \forall i = 1, 2, 3$$

Portanto, a estratégia ótima para o apostador é não apostar nenhum dinheiro se e somente se o produto da probabilidade do resultado pelas odds for menor ou igual a 1 para todos os resultados possíveis, o que é bastante intuitivo.

No caso em que $p_i \cdot o_i > 1$ para algum $i$, as condições não são mais satisfeitas por $b_0 = 1$. O apostador deve então investir algum dinheiro na partida; no entanto, como o denominador das expressões nas condições 1 e 2 também muda, mais de um resultado possível pode agora violar as condições. Portanto, a solução ótima pode envolver investir em algum resultado possível com $p_i \cdot o_i \leq 1$, o que é contraintuitivo.

Não há forma analítica para a solução neste caso. As condições 1, 2 e 3 não dão origem a uma solução explícita. Em vez disso, podemos formular um algoritmo para encontrar a estratégia ótima.

### A estratégia ótima geral

1. Ordene os resultados possíveis de forma que $p_1 o_1 \geq p_2 o_2 \geq p_3 o_3$

2. Defina

$$C_k = \frac{1 - \sum_{i=1}^{k} p_i}{1 - \sum_{i=1}^{k} 1/o_i} (\text{ se } k \geq 1)$$
$$C_k = 1 (\text{se } k = 0)$$

3. Defina

$$t = \min n \mid p_{n+1}o_{n+1} \leq C_n$$

4. A estratégia ótima para o apostador no caso geral, pensando a longo prazo, é dada por

$$b_0 = C_t$$

$$i = 1, 2, \dots, t \to b_i = p_i - \frac{C_t}{o_i}$$

$$i = t + 1, \dots, 3 \to b_i = 0$$

Os valores $(b_0, b_1, b_2, b_3)$ gerados pelo algoritmo satisfazem as três condições e constituem a estratégia ótima para o apostador. Este texto considera um tipo de aposta com apenas três resultados possíveis, mas o raciocínio pode ser estendido para qualquer tipo de aposta com $N$ resultados mutuamente exclusivos.
