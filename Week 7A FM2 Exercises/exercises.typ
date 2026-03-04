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

#let title = "Formal Methods 2"
#let subtitle = "Guarded Commands"
#let subject = "02141 Computer Science Modelling"
#let date = "February 10th, 2026"

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

#align(center)[
    #date
]


#v(16pt)
#grid(columns: (1cm, 1fr, 1cm),
    column-gutter: 2pt,
    [],
    [- The number of #sym.star.filled's gives a rough indicator of the task's difficulty. You should aim to solve at least all tasks with at most three #sym.star.filled's. Tasks with more stars can be hard or require mathematical background that you should have from previous courses.

    - You can always ask us for feedback or help during the exercise class.

    - We recommend that you first read all tasks during class. Make sure that you have a rough approach for every task in mind before you start working on the details. Ask for help if a task is unclear such that you do not get stuck when we are not there to help.],
    []
)

//#pagebreak()
#outline()
#pagebreak()


= From GCL to Program Graphs (#((sym.star.filled,) * 1).join())
Consider the GCL program
```
do m != 0 -> t := m;
            m := n;
            do m >= t -> m := m - t od;
            n := t
od;
out := n
```

We write `m != 0` instead of $not (m = 0)$ and `m >= t` instead of $m >= t$, and `!b` instead of $not b$.

== Construct an abstract syntax tree (AST) corresponding to the program.

There are multiple ways to construct an abstract syntax tree for this program, one of which is illustrated below:
#raw-render(width: 100%, ```
    digraph {
        rankdir=LR
        node [shape = circle]
        g [shape=point, width=0]
    
        s1[label=";"]
        s2[label=";"]
        s3[label=";"]
        s4[label=";"]

        a0[label="↑"]
        a1[label="↑"]

        c0[label="do, od"]
        c1[label="m != 0"]
        c2[label="t := m"]
        c3[label="m := n"]
        c4[label="do, od"]
        c6[label="m := m - t"]
        c5[label="m >= t"]
        c7[label="n := t"]
        c8[label="out := n"]

        g -> s1
        s1 -> c0
        s1 -> c8
        c0 -> a0
        a0 -> c1
        a0 -> s2
        s2 -> c2
        s2 -> s3
        s3 -> c3
        s3 -> s4
        s4 -> c4
        s4 -> c7
        c4 -> a1
        a1 -> c5
        a1 -> c6 
    }
```)


The #sym.arrow.t symbol is used to represent the #sym.arrow operator, pointing upwards to indicate the direction of the operation.

== Construct the corresponding program graph as described in the lecture.
#raw-render(width: 100%, ```
    digraph {
        rankdir=LR
        node [shape = circle]
        //g [shape=point, width=0]
    
        s[label="q_triangle.r", math=true]
        s1[label="q_1"]
        s2[label="q_2"]
        s3[label="q_3"]
        s4[label="q_4"]
        s5[label="q_5"]
        s6[label="q_6"]
        sf[label="q_triangle.l.filled", math=true, shape=doublecircle]

        s -> s1[label="m != 0"]
        s1 -> s2[label="t := m"]
        s2 -> s3[label="m := n"]
        s3 -> s4[label="m >= t"]
        s4 -> s3[label="m := m - t"]
        s3 -> s5[label="m < t"]
        s5 -> s[label="n := t"]
        s -> s6[label="m = 0"]
        s6 -> sf[label="out := n"]
    }
```)



= More Expressions (#((sym.star.filled,) * 2).join())

== Our arithmetic expressions `a` and Boolean expressions `b` are quite limited. Extend the syntax and semantics of expressions to also incorporate `false`, $a_1 != a_2$, $b_1 or b_2$, $a_1 <= a_2$, $b_1 || b_2$, where $b_1 || b_2$ is a short-circuiting version of disjunction that does not evaluate `b2` if `b1` evaluates to true.
The existing syntax is highlighted in blue, the new expressions are highlighted in red.
$
    C quad ::= quad
    &x #text(fill: blue)[$:=$] a
    | #text(fill: blue)[`skip`]
    | C_1 #text(fill: blue)[;] C_2
    | #text(fill: blue)[`if`] G C #text(fill: blue)[`fi`]
    | #text(fill: blue)[`do`] G C #text(fill: blue)[`od`]
    \
    G C quad ::= quad
    &b #text(fill: blue)[$->$] C
    | G C_1 #text(fill: blue)[[]] G C_2
    \
    a quad ::= quad
    &n
    | x
    | a_1 #text(fill: blue)[$+$] a_2
    | a_1 #text(fill: blue)[$-$] a_2
    | a_1 #text(fill: blue)[$*$] a_2
    | a_1 #text(fill: blue)[^] a_2
    \
    b quad ::= quad
    &#text(fill: blue)[`true`]
    | a_1 #text(fill: blue)[$=$] a_2
    | a_1 #text(fill: blue)[$>$] a_2
    | a_1 #text(fill: blue)[$>=$] a_2
    | b_1 #text(fill: blue)[$and$] b_2
    | b_1 thick #text(fill: blue)[\&\&] thick b_2
    | #text(fill: blue)[$not$] b_0
    \
    &
    | #text(fill: red)[`false`]
    | a_1 #text(fill: red)[$!=$] a_2
    | b_1 #text(fill: red)[$or$] b_2
    | a_1 #text(fill: red)[$<=$] a_2
    | b_1 #text(fill: red)[$||$] b_2
$

The evanluation function $cal(B)$ is updated to include the added expressions.

#v(12pt)

#align(center, [
    #grid(columns: (25%, 75%), align: left, row-gutter: 14pt,
        [$b$], [$cal(B) bracket.l.stroked b bracket.r.stroked (sigma)$],
        line(length:100%), line(length:100%),
        [#text(fill: red)[`false`]],
        [`false`],
        //
        [#text(fill: red)[$a_1 != a_2$]],
        [$cases(
                "true" &quad "if" z_1 = cal(A) bracket.l.stroked a_1 bracket.r.stroked (sigma)"," z_2 = cal(A) bracket.l.stroked a_2 bracket.r.stroked (sigma)"," z_1 != z_2,
                "false" &quad "if" z_1 = cal(A) bracket.l.stroked a_1 bracket.r.stroked (sigma)"," z_2 = cal(A) bracket.l.stroked a_2 bracket.r.stroked (sigma)"," z_1 = z_2,
                "undefined" &quad "otherwise"
        )$],
        //
        [#text(fill: red)[$b_1 or b_2$]],
        [$cases(
                "true" &quad "if" z_1 = cal(B) bracket.l.stroked b_1 bracket.r.stroked (sigma)"," z_2 = cal(B) bracket.l.stroked b_2 bracket.r.stroked (sigma)"," z_1 or z_2,
                "false" &quad "if" z_1 = cal(B) bracket.l.stroked b_1 bracket.r.stroked (sigma)"," z_2 = cal(B) bracket.l.stroked b_2 bracket.r.stroked (sigma)"," not z_1 and not z_2,
                "undefined" &quad "otherwise"
        )$],
        //
        [#text(fill: red)[$a_1 <= a_2$]],
        [$cases(
                "true" &quad "if" z_1 = cal(A) bracket.l.stroked a_1 bracket.r.stroked (sigma)"," z_2 = cal(A) bracket.l.stroked a_2 bracket.r.stroked (sigma)"," z_1 <= z_2,
                "false" &quad "if" z_1 = cal(A) bracket.l.stroked a_1 bracket.r.stroked (sigma)"," z_2 = cal(A) bracket.l.stroked a_2 bracket.r.stroked (sigma)"," z_1 > z_2,
                "undefined" &quad "otherwise"
        )$],
        //
        [#text(fill: red)[$b_1 || b_2$]],
        [$cases(
                "true" &quad "if" cal(B) bracket.l.stroked b_1 bracket.r.stroked (sigma) = "true",
                cal(B) bracket.l.stroked b_2 bracket.r.stroked (sigma) &quad "if" cal(B) bracket.l.stroked b_1 bracket.r.stroked (sigma) = "false",
                "undefined" &quad "otherwise"
        )$]
    )
])


== Do any of the added expressions increase the expressive power of the boolean expressions, or could we have managed without them? For example, $a_1 != a_2$ can be encoded as $not (a_1 = a_2)$. Can you encode the rest of the operations?
The operations can be encoded as follows:
$
    #text(fill: red)[`false`]
    quad &=^triangle.small quad
    #text(fill: blue)[$not$] (#text(fill: blue)[`true`])
    \
    a_1 #text(fill: red)[$!=$] a_2
    quad &=^triangle.small quad
    #text(fill: blue)[$not$] (a_1 #text(fill: blue)[$=$] a_2)
    \
    b_1 #text(fill: red)[$or$] b_2
    quad &=^triangle.small quad
    #text(fill: blue)[$not$] (b_1 #text(fill: blue)[$and$] b_2)
    \
    a_1 #text(fill: red)[$<=$] a_2
    quad &=^triangle.small quad
    #text(fill: blue)[$not$] (a_1 #text(fill: blue)[$>$] a_2)
    \
    b_1 #text(fill: red)[$||$] b_2
    quad &=^triangle.small quad
    #text(fill: blue)[$not$] (#text(fill: blue)[$not$] b_1 thick #text(fill: blue)[\&\&] thick #text(fill: blue)[$not$] b_2)
$


= Arrays (#((sym.star.filled,) * 3).join())

== Incorporate operations for arrays into the Guarded Command Language. That is, extend the syntax and semantics of the Guarded Command language such that it supports assignment commands `A[a1] := a2` for writing to an array element and arithmetic expressions `A[a]` for reading the value of an array element. _Hint_: To define the semantics of commands and expressions involving arrays, you also have to extend the definition of memories $sigma$, such that they can assign values to array elements.

The previously defined syntax of GCL is extended, with extensions highlighted in red.
$
    C quad ::= quad
    &x #text(fill: blue)[`:=`] a
    | #text(fill: blue)[`skip`]
    | C_1 #text(fill: blue)[;] C_2
    | #text(fill: blue)[`if`] G C #text(fill: blue)[`fi`]
    | #text(fill: blue)[`do`] G C #text(fill: blue)[`od`]
    | A[a_1] #text(fill: red)[`:=`] a_2
    \
    G C quad ::= quad
    &b #text(fill: blue)[$->$] C
    | G C_1 #text(fill: blue)[[]] G C_2
    \
    a quad ::= quad
    &n
    | x
    | a_1 #text(fill: blue)[$+$] a_2
    | a_1 #text(fill: blue)[$-$] a_2
    | a_1 #text(fill: blue)[$*$] a_2
    | a_1 #text(fill: blue)[^] a_2
    | A#text(fill: red)[`[`]i#text(fill: red)[`]`]
    \
    b quad ::= quad
    &#text(fill: blue)[`true`]
    | a_1 #text(fill: blue)[$=$] a_2
    | a_1 #text(fill: blue)[$>$] a_2
    | a_1 #text(fill: blue)[$>=$] a_2
    | b_1 #text(fill: blue)[$and$] b_2
    | b_1 thick #text(fill: blue)[\&\&] thick b_2
    | #text(fill: blue)[$not$] b_0
    \
    &
    | #text(fill: blue)[`false`]
    | a_1 #text(fill: blue)[$!=$] a_2
    | b_1 #text(fill: blue)[$or$] b_2
    | a_1 #text(fill: blue)[$<=$] a_2
    | b_1 #text(fill: blue)[$||$] b_2
$

The memory function is extended to account for arrays.
$
    #text([*Mem*]) = { sigma | sigma : #text([*Var*]) union { A[i] | A in #text([*Arr*]), 0 <= i < "size"(A)} -> #text([*Int*])}
$

The semantic functions for the newly incorporated arrays are defined.
$
    cal(S) bracket.l.stroked A[a_1] #text(fill: red)[`:=`] a_2 bracket.r.stroked (sigma)
    &= cases(
        sigma(A[u] mapsto v)","
            u = cal(A) bracket.l.stroked a_1 bracket.r.stroked (sigma)","
            v = cal(A) bracket.l.stroked a_2 bracket.r.stroked (sigma)
            &quad quad "if" A[u] in "dom"(sigma),
        "undefined" &quad quad "otherwise"
    )
    \
    cal(A) bracket.l.stroked A#text(fill: red)[`[`]i#text(fill: red)[`]`] bracket.r.stroked (sigma)
    &= cases(
        sigma(A[u])","
            u = cal(A) bracket.l.stroked i bracket.r.stroked (sigma)
            &quad quad "if" A[u] in "dom"(sigma),
        "undefined" &quad quad "otherwise"
    )
$

As such, the operations for arrays are incorporated into GCL.

