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

#let title = "Formal Methods 3"
#let subtitle = "Program Graphs -- Guarded Commands"
#let subject = "02141 Computer Science Modelling"
#let date = "February 17th, 2026"

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

//#v(16pt)
//#grid(columns: (1cm, 1fr, 1cm),
//    column-gutter: 2pt,
//    [],
//    [],
//    []
//)

    

#pagebreak()


= More Loops (#((sym.star.filled,) * 1).join())
In this task our goal is to extend the Guarded Command Language with a `break` and `continue` by a new command `repeat C until b` where `C` is a command and `b` is a boolean expression. Intuitively, the command `repeat C until b` first executes `C`. After that it checks whether `b` golds or not. If yes, it stops execution. Otherwise it keeps executing `C` and checking `b` again.

== Give a formal definition of the edge relation for `repeat C until b`, i.e. define $#text([*edges*])_(b c) (q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle.filled) bracket.l.stroked #text([`repeat C until b`]) bracket.r.stroked (q_b, q_c)$


= Even More Loops (#((sym.star.filled,) * 2).join())

We extend the Guarded Command Language with a `break` and `continue` by a new command `loop GC pool` for which we generate edges as follows:
$
    #text([*edges*])_(b c)(q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle.filled) bracket.l.stroked #text([`loop GC pool`]) bracket.r.stroked (q_b, q_c)
    =
    #text([*edges*])_(b c)(q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle.filled) bracket.l.stroked #text([`GC`]) bracket.r.stroked (q_#sym.circle.filled, q_#sym.circle)
$

_Hint_: A program _simulates_ another one if it can always reach the same final configurations from the same initial configurations, possibly by performing different actions. That is, $C_1$ _simulates_ $C_2$ if, for all $sigma in #text([*Mem*])$, we have $chevron.l q_triangle.r ; sigma chevron.r arrow.r.double.long \ ^* chevron.l q_triangle.l.filled ; sigma' chevron.r$ holds for the program graph of $C_1$ if and only if $chevron.l q_triangle.r ; sigma chevron.r arrow.r.double.long \ ^* chevron.l q_triangle.l.filled ; sigma' chevron.r$ holds for the program graph of $C_2$.


== Explain informally how the above command differs from the command `do GC od`.


== Is there a way to _simulate_ `do GC od` using `loop GC pool` and `break`?


== Is there a way to _simulate_ `loop GC pool` using `do GC od`?




= Deterministic Semantics (#((sym.star.filled,) * 3).join())
Let $(#text([*E*]), d) = #text([*edges*])_("det") (q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle.filled) bracket.l.stroked #text([`GC`]) bracket.r.stroked (#text[`false`])$ for some guarded command `GC`.

== Show that $not d$ is logically equivalent to `done`$bracket.l.stroked #text([`GC`]) bracket.r.stroked$, i.e. for all memories $sigma$, $cal(B)bracket.l.stroked not d bracket.r.stroked (sigma) = cal(B) bracket.l.stroked #text([`done`])bracket.l.stroked #text([`GC`]) bracket.r.stroked bracket.r.stroked (sigma)$. _Hint_: You may want to prove the slightly more general statement $cal(B) bracket.l.stroked not d bracket.r.stroked = cal(B) bracket.l.stroked #text([`done`])bracket.l.stroked #text([`GC`]) bracket.r.stroked and not d' bracket.r.stroked$, where $(#text([*E*]), d) = #text([*edges*])_"det" (q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle.filled) bracket.l.stroked #text([`GC`]) bracket.r.stroked (d')$ for all guarded commands `GC` and boolean expressions $d'$.




= The Coincidence Property (#((sym.star.filled,) * 4).join())
If we want to define one set of memories for all programs in the Guarded Command Language, then we need to choose an infinite set *Var* of variables. However, so far we always assumed that *var* is the finite set of variables that actually appear in a program. In the lectures slides, there is a proof of the fact that, for (simplified) arithmetic expressions, the presence or absence of additional variables that do not actually appear in any expressions does not matter. This is sometimes referred to as the "coincidence property". The goal of this task is to check that the coincidence property also holds for (simplified) boolean expressions, given by the following EBNF grammar:
$
    b ::=
    #text([`true`])
    | a_1 = a_2
    | not b_1
    | b_1 and b_2
$


== Define a recursive function *Var*$(b)$, that takes a simplified boolean expression $b$ and returns the set of all variables that appear in $b$. _Hint_: You may re-use the function *Var*$(a)$ deﬁned in the lecture and assume that the corresponding result holds for all arithmetic expressions $a$ (see slides).


== Show that, for all simplified boolean expressions $b$ and all memories $sigma, sigma'$ with $sigma(x) = sigma'(x)$ for all variables $x in #text([*Var*]) (b)$, we have $cal(B) bracket.l.stroked b bracket.r.stroked (sigma) = cal(B) bracket.l.stroked b bracket.r.stroked (sigma')$.


