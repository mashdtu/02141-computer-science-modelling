#import "@preview/diagraph:0.3.6": *

#show heading: set block(above: 2em)
#show heading: set block(below: 1em)
#show link: it => underline(text(fill: blue)[#it])
#show heading.where(level: 3): set heading(outlined: false)

#set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 2.5cm),
    numbering: "1 of 1",
    number-align: right,
    header: none
)

#set par(
    justify: true,
)

#set text(
    font: "New Computer Modern",
    size: 12pt
)

#set heading(
    numbering: "1.1 ",
)

#let ansline = line(
    start: (0%, 0%),
    end: (100%, 0%),
    stroke: (thickness: 1pt, dash: "dashed")
)

#let title = "Formal Methods 1"
#let subtitle = "February 3rd, 2026"
#let subject = "02141 Computer Science Modelling"

#let author = (if read("../.secret").trim() == "" { "name" } else { read("../.secret").trim() },)

#align(center)[
    #text(32pt)[#smallcaps(title)] \ #text(18pt)[#subtitle] \ #text(fill:black.lighten(25%), [#subject])
]

#{
    grid(columns: (1fr,) * author.len(),
        column-gutter: 2pt,
        ..author.map(a => align(center)[#a])
    )
}


//#pagebreak()
#outline()

#v(16pt)
#grid(columns: (1cm, 1fr, 1cm),
    column-gutter: 2pt,
    [],
    [- The number of #sym.star.filled's gives a rough indicator of the task's difficulty. You should aim to solve at least all tasks with at most three #sym.star.filled's. Tasks with more stars can be hard or require mathematical background that you should have from previous courses.

    - You can always ask us for feedback or help during the exercise class.

    - We recommend that you first read all tasks during class. Make sure that you have a rough approach for every task in mind before you start working on the details. Ask for help if a task is unclear such that you do not get stuck when we are not there to help.],
    []
)

    

#pagebreak()


= Programming with Program Graphs (#sym.star.filled)
Specify a program graph *PG* modelling a function that computes the greatest common divisor of two numbers (given by variables $n$ and $m$) and stores the result in a variable called `out`. You can only use assignments with simple arithmetic operations (summation, multiplication, subtraction), for example `x := x + y`, and simple Boolean tests, for example `x > 0`, as actions. In particular, computing the modulo or the factorial with an action is not allowed. _Hint_: You may use the following pseudo-code for computing the greatest common divisor as inspiration. However, notice that you are not allowed to use the remainder (_a_ mod _b_) in an action; you may want to write a program graph for the remainder first.
```fs
function gcd(a, b)
    while b != 0
        t := b
        b := a mod b
        a := t
    return a
```
_Hint 2_: Try to design your program with a PG first. You can then try fm4fun, by writing the program in GCL and inspecting the PG that that the tool provides. You can then use fm4fun to run your PG and test it. A possible GCL program that generates the same PG is as follows:
```
do m != 0 ->
    t := m ;
    m := n ;
    do
    m >= t -> m:=m-t
    od
    n := t
od;
out := n
```

#ansline

#raw-render(width: 100%,```
    digraph {
        node [shape = circle]
        rankdir=LR
        s[label="q_triangle.r", math=true]
        s1[label="q_1"]
        s2[label="q_2"]
        s3[label="q_3"]
        s4[label="q_4"]
        s5[label="q_5"]
        s6[label="q_6"]
        sf[label="q_triangle.l.filled", math=true, shape = doublecircle]
        s -> s6[label="m = 0"]
        s -> s1[label="m != 0"]
        s1 -> s2[label="t := m"]
        s2 -> s3[label="m := n"]
        s3 -> s4[label="m >= t"]
        s4 -> s3[label="m := m - t"]
        s3 -> s5[label="m < t"]
        s5 -> s[label="n := t"]
        s6 -> sf[label="out := n"]
    }
```)

The program graph `PG` can be specified as follows:
$
    "PG" &= (Q, q_triangle.r, q_triangle.l.filled, "Act", E)
    \
    &= (
        {q_triangle.r, q_1, q_2, q_3, q_4, q_5, q_6, q_triangle.l.filled},
        q_triangle.r,
        q_triangle.l.filled,
        \
        & #h(13pt) {
            m != 0, t := m, m:= n, m >= t, m := m-t, m < t, n := t, m = 0, "out" := n
        },
        \
        & #h(13pt) {
            (q_triangle.r, m != 0, q_1),
            (q_1, t := m, q_2),
            (q_2, m := n, q_3),
            (q_3, m >= t, q_4),
            (q_4, m := m - t, q_3),
            \
            & #h(13pt) 
            (q_3, m < t, q_5),
            (q_5, n := t, q_triangle.r),
            (q_triangle.r, m = 0, q_6),
            (q_6, "out" := n, q_triangle.l.filled)
        }
    )
$

Using the tool fm4fun on the GCL program given in hint 2, we get the exact same graph, though with slightly different notations:

#raw-render(width:100%, ```
    digraph program_graph {rankdir=LR;
        node [shape = circle]; q▷;
        node [shape = doublecircle]; q◀; 
        node [shape = circle]
        q▷ -> q2 [label = "m!=0"];
        q2 -> q3 [label = "t:=m"];
        q3 -> q4 [label = "m:=n"];
        q4 -> q6 [label = "m>=t"];
        q6 -> q4 [label = "m:=m-t"];
        q4 -> q5 [label = "!(m>=t)"];
        q5 -> q▷ [label = "n:=t"];
        q▷ -> q1 [label = "!(m!=0)"];
        q1 -> q◀ [label = "out:=n"];
    }
```)

#ansline





#pagebreak()
= Semantic Functions (#((sym.star.filled,) * 2).join())
Define the semantic function $S$ for all actions that you used in your program graph in task 1. For example, if your program includes as actions $m != n$ and $m := n$ you would need to define their semantic function as follows:

$
  S bracket.l.stroked m != n bracket.r.stroked (sigma) &= cases(
    sigma &"if" sigma(m) != sigma(n),
    "undefined" &"otherwise"
  )
  \
  S bracket.l.stroked m := n bracket.r.stroked (sigma) &= sigma [m mapsto sigma(n)]
$


#ansline

$
  S bracket.l.stroked m != 0 bracket.r.stroked (sigma) &= cases(
    sigma &"if" sigma(m) != 0,
    "undefined" &"otherwise"
  )
  \
  S bracket.l.stroked t := m bracket.r.stroked (sigma) &= sigma [t mapsto sigma(m)]
  \
  S bracket.l.stroked m := n bracket.r.stroked (sigma) &= sigma [m mapsto sigma(n)]
  \
  S bracket.l.stroked m >= t bracket.r.stroked (sigma) &= cases(
    sigma &"if" sigma(m) >= sigma(t),
    "undefined" &"otherwise"
  )
  \
  S bracket.l.stroked m := m - t bracket.r.stroked (sigma) &= sigma [m mapsto sigma(m) - sigma(t)]
  \
  S bracket.l.stroked m < t bracket.r.stroked (sigma) &= cases(
    sigma &"if" sigma(m) < sigma(t),
    "undefined" &"otherwise"
  )
  \
  S bracket.l.stroked n := t bracket.r.stroked (sigma) &= sigma [n mapsto sigma(t)]
  \
  S bracket.l.stroked m = 0 bracket.r.stroked (sigma) &= cases(
    sigma &"if" sigma(m) = 0,
    "undefined" &"otherwise"
  )
  \
  S bracket.l.stroked "out" := n bracket.r.stroked (sigma) &= sigma ["out" mapsto sigma(n)]
$

#ansline





#pagebreak()
= Operational Semantics (#((sym.star.filled,) * 2).join())
Test whether your program graph from task 1 indeed computes the greatest common divisor by computing a complete execution sequence
$
    chevron.l q_triangle.stroked.r ; sigma chevron.r ==>#h(0pt)^* chevron.l q_triangle.filled.l ; sigma' chevron.r
$
with $sigma(n) = 24$ and $sigma(m) = 8$. What is the sequence $omega$ of executed actions? What is $sigma'$? _Hint_: Try to first write the sequence using pen and paper. Once you are confident that you know how to construct the sequence, use fm4fun to generate the sequence for the GCL program that corresponds to your PG. Compare the results to verify your answer.


#ansline

The execution sequence is assumed to have the initial values of $sigma(n) = 24$, $sigma(m) = 8$, $sigma(t) = 0$ and $sigma("out") = 0$.

$
  &chevron.l q_triangle.stroked.r ; sigma[n mapsto 24][m mapsto 8][t mapsto 0]["out" mapsto 0] chevron.r
  \ ==>^(m != 0)
  &chevron.l q_1 ; sigma[n mapsto 24][m mapsto 8][t mapsto 0]["out" mapsto 0] chevron.r
  \ ==>^(t := m)
  &chevron.l q_2 ; sigma[n mapsto 24][m mapsto 8][t mapsto 8]["out" mapsto 0] chevron.r
  \ ==>^(m := n)
  &chevron.l q_3 ; sigma[n mapsto 24][m mapsto 24][t mapsto 8]["out" mapsto 0] chevron.r
  \ ==>^(m >= t)
  &chevron.l q_4 ; sigma[n mapsto 24][m mapsto 24][t mapsto 8]["out" mapsto 0] chevron.r
  \ ==>^(m := m-t)
  &chevron.l q_3 ; sigma[n mapsto 24][m mapsto 16][t mapsto 8]["out" mapsto 0] chevron.r
  \ ==>^(m >= t)
  &chevron.l q_4 ; sigma[n mapsto 24][m mapsto 16][t mapsto 8]["out" mapsto 0] chevron.r
  \ ==>^(m := m-t)
  &chevron.l q_3 ; sigma[n mapsto 24][m mapsto 8][t mapsto 8]["out" mapsto 0] chevron.r
  \ ==>^(m >= t)
  &chevron.l q_4 ; sigma[n mapsto 24][m mapsto 8][t mapsto 8]["out" mapsto 0] chevron.r
  \ ==>^(m := m-t)
  &chevron.l q_3 ; sigma[n mapsto 24][m mapsto 0][t mapsto 8]["out" mapsto 0] chevron.r
  \ ==>^(m < t)
  &chevron.l q_5 ; sigma[n mapsto 8][m mapsto 0][t mapsto 8]["out" mapsto 0] chevron.r
  \ ==>^(n := t)
  &chevron.l q_triangle.r ; sigma[n mapsto 8][m mapsto 0][t mapsto 8]["out" mapsto 0] chevron.r
  \ ==>^(m = 0)
  &chevron.l q_6 ; sigma[n mapsto 8][m mapsto 0][t mapsto 8]["out" mapsto 0] chevron.r
  \ ==>^("out" := n)
  &chevron.l q_triangle.l.filled ; sigma[n mapsto 8][m mapsto 0][t mapsto 8]["out" mapsto 8] chevron.r
$

Using the fm4fun tool, we get the same execution sequence:
#align(center)[#image("assets/image.png", width:75%)]

#ansline






#pagebreak()
= Properties of Program Graphs (#((sym.star.filled,) * 3).join())

1. Does your program graph from task 1 and its semantic function constitute a deterministic system? Justify your answer.

#ansline

The two nodes in the graph which have multiple conditional branches are $q_triangle.r$ and $q_3$. For a system to be deterministic, these conditional branches must be mutually exclusive, i.e.
$
  "dom"(S bracket.l.stroked alpha_1 bracket.r.stroked) inter "dom"(S bracket.l.stroked alpha_2 bracket.r.stroked) = emptyset
  " or "
  forall (q, alpha_1, q_1), (q, alpha_2, q_2) in bold(E) : (alpha_1, q_1) != (alpha_2, q_2)
$

The two conditional branches at $q_triangle.r$ are the following:
$
  S bracket.l.stroked m != 0 bracket.r.stroked
  " and "
  S bracket.l.stroked m = 0 bracket.r.stroked
$
Since the statement $m != 0$ is logically equaivalent to $not(m = 0)$ it must be true that
$
    {forall m in bb(Z) | m != 0} subset.not.eq {forall m in bb(Z) | m = 0},
$
thus the two are mutually exclusive. At $q_3$ we are met with $m >= t$ and $m < t$. Since, again the statement $m < t$ is logically equaivalent to $not(m >= t)$, the two must also be mutually exclusive. As such, the program is deterministic.

#ansline




2. Does your program graph from task 1 and its semantic function constitute an evolving system? Justify your answer.



#ansline

An evolving system can always perform execution steps unless it has reached a final configuration. A system is evolving if, for every
node and every memory $sigma$, there is an edge from
that node whose semantic function is defined for $sigma$.
\
\
The program graph and its semantic function constitute an evolving system if
$
    chevron.l q_triangle.r ; sigma chevron.r
    ==>^omega #h(0pt)^* chevron.l q' ; sigma' chevron.r
    "where" q' != q_triangle.l.filled
$
can always be extended by some $alpha in bold("Act")$ to
$
  chevron.l q_triangle.r ; sigma chevron.r ==>^omega #h(0pt)^* chevron.l q' ; sigma' chevron.r ==>^alpha #h(0pt)^* chevron.l q'' ; sigma'' chevron.r.
$
Mathematically expressed as:
$
  forall q in Q backslash {q_triangle.l.filled} forall sigma in bold("Mem") exists (q, alpha, q') in bold(E) : sigma in "dom"(S bracket.l.stroked alpha bracket.r.stroked).
$




#ansline






#pagebreak()
= More on Semantics and Memories (#((sym.star.filled,) * 3).join())
Let $A$ and $B$ be arrays corresponding to two vectors of length $n$ and $m$, respectively. Construct a program graph for calculating the result of:
$
  sum_(i=0)^(n-1) sum_(j=0)^(m-1) A[i] dot B[j]
$
Moreover, define the semantic function for the involved actions in your PG.

_Hint 1_: As in previous exercises, you may want to use fm4fun to write the program in GCL and compare it with your PG.
\
_Hint 2_: Section 1.3 of the FM book explains how to define memories for arrays.



#ansline

A GCL program can be written which applies the mathematical expression:
```
sA := 0;
i := 0;
do i < n ->
    sA := sA + A[i];
    i := i + 1
od;
sB := 0;
j := 0;
do j < m ->
    sB := sB + B[j];
    j := j + 1
od;
out := sA * sB
```

This generates the following program graph.

#raw-render(width: 100%,```
    digraph {
        node [shape = circle, math=true]
        edge [math=true]
        rankdir=LR
        s[label="q_triangle.r"]
        s1[label="q_1"]
        s2[label="q_2"]
        s3[label="q_5"]
        s4[label="q_3"]
        s5[label="q_4"]
        s6[label="q_6"]
        s7[label="q_7"]
        s8[label="q_10"]
        s9[label="q_8"]
        s10[label="q_9"]
        sf[label="q_triangle.l.filled", shape = doublecircle]
        s -> s1[label="sA := 0"]
        s1 -> s2[label="i := 0"]
        s2 -> s4[label="i < n"]
        s4 -> s5[label="sA := sA + A[i]"]
        s5 -> s2[label="i := i + 1"]
        s2 -> s3[label="i >= n"]
        s3 -> s6[label="sB := 0"]
        s6 -> s7[label="j := 0"]
        s7 -> s9[label="j < m"]
        s9 -> s10[label="sB := sB + B[j]"]
        s10 -> s7[label="j := j + 1"]
        s7 -> s8[label="j >= m"]
        s8 -> sf[label="out := sA·sB"]
    }
```)

#pagebreak()

The program graph can be described as using the expression
$
    "PG" = (Q, q_triangle.r, q_triangle.l.filled, bold("Act"), bold("E"))
$
where
$
    Q = &{
        q_triangle.r, q_1, q_2, q_3, q_4, q_5, q_6, q_7, q_8, q_9, q_10, q_triangle.l.filled
    },
    \
    q_triangle.r = &q_triangle.r,
    \
    q_triangle.l.filled = &q_triangle.l.filled,
    \
    bold("Act") = &{
        "sA" := 0,
        i := 0,
        i < n,
        "sA" := "sA" + A[i],
        i := i + 1,
        i >= n,
        "sB" := 0,
        j := 0,
        j < m,
        \
        & #h(6pt) "sB" := "sB" + B[j],
        j := j + 1,
        j >= m,
        "out" := "sA" dot "sB"
    },
    \
    bold("E") = &{
        (q_triangle.l, "sA" := 0, q_1),
        (q_1, i := 0, q_2),
        (q_2, i < n, q_3),
        (q_3, "sA" := "sA" + A[i], q_4),
        \
        & #h(6pt)
        (q_4, i := i + 1, q_2),
        (q_2, i >= n, q_5),
        (q_5, "sB" := 0, q_6),
        (q_6, j := 0, q_7),
        \
        & #h(6pt)
        (q_7, j < m, q_8),
        (q_8, "sB" := "sB" + B[j], q_9),
        (q_9, j := j + 1, q_7),
        (q_7, j >= m, q_10),
        \
        & #h(6pt)
        (q_10, "out" := "sA" dot "sB", q_triangle.r.filled)
    }.
$

The semantic functions can be defined as follows:
$
    S bracket.l.stroked "sA" := 0 bracket.r.stroked (sigma) &= sigma ["sA" mapsto 0]
    \
    S bracket.l.stroked i := 0 bracket.r.stroked (sigma) &= sigma [i mapsto 0]
    \
    S bracket.l.stroked i < n bracket.r.stroked (sigma) &= cases(
    sigma &"if" sigma(i) < sigma(n),
    "undefined" &"otherwise"
    )
    \
    S bracket.l.stroked "sA" := "sA" + A[i] bracket.r.stroked (sigma) &= sigma ["sA" mapsto "sA" + A[i]]
    \
    S bracket.l.stroked i := i + 1 bracket.r.stroked (sigma) &= sigma [i mapsto i + 1]
    \
    S bracket.l.stroked i >= n bracket.r.stroked (sigma) &= cases(
    sigma &"if" sigma(i) >= sigma(n),
    "undefined" &"otherwise"
    )
    \
    S bracket.l.stroked "sB" := 0 bracket.r.stroked (sigma) &= sigma ["sB" mapsto 0]
    \
    S bracket.l.stroked j := 0 bracket.r.stroked (sigma) &= sigma [j mapsto 0]
    \
    S bracket.l.stroked j < m bracket.r.stroked (sigma) &= cases(
    sigma &"if" sigma(j) < sigma(m),
    "undefined" &"otherwise"
    )
    \
    S bracket.l.stroked "sB" := "sB" + B[i] bracket.r.stroked (sigma) &= sigma ["sB" mapsto "sB" + B[j]]
    \
    S bracket.l.stroked j := j + 1 bracket.r.stroked (sigma) &= sigma [j mapsto j + 1]
    \
    S bracket.l.stroked j >= m bracket.r.stroked (sigma) &= cases(
    sigma &"if" sigma(j) >= sigma(m),
    "undefined" &"otherwise"
    )
    \
    S bracket.l.stroked "out":= "sA" dot "sB" bracket.r.stroked (sigma) &= sigma ["out" mapsto "sA" dot "sB"]
$







#ansline




