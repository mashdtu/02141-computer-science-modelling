#import "@preview/diagraph:0.3.6": *
#import "@preview/chic-hdr:0.5.0": *
#import "@preview/rexllent:0.4.0": *

#show heading: set block(above: 2em)
#show heading: set block(below: 1em)
#show link: it => underline(text(fill: blue)[#it])
#show selector(<nonumber>): set heading(numbering: none)

#let first-heading = state("first-heading", true)
#show heading.where(level: 1): it => {
    context if first-heading.get() {
        first-heading.update(false)
        it
    } else {
        pagebreak(weak: true) + it
    }
}

#let numberingH(c) = {
    if c.numbering != none {
        return numbering(c.numbering, ..counter(heading).at(c.location()))
    }
    return ""
}

#let currentH(level) = {
    let elems = query(selector(heading.where(level: level)).after(here()))

    if elems.len() != 0 and elems.first().location().page() == here().page() {
        return [#numberingH(elems.first()) #elems.first().body]
    } else {
        elems = query(selector(heading.where(level: level)).before(here()))
        if elems.len() != 0 {
            return [#numberingH(elems.last()) #elems.last().body]
        }
    }
    return ""
}

#set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 2.5cm),
    number-align: right,
)

#set par(
    justify: true,
)

#set text(
    font: "New Computer Modern",
    size: 12pt,
)

#set heading(
    numbering: "1.1 ",
)

#let ansline = line(
    start: (0%, 0%),
    end: (100%, 0%),
    stroke: (thickness: 1pt, dash: "dashed"),
)

#let title = "Formal Methods 3"
#let subtitle = "Program Graphs -- Guarded Commands"
#let subject = "0241 Computer Science Modelling"
#let date = "February 17th, 2026"

#let author = (if read("../.secret").trim() == "" { "name" } else { read("../.secret").trim() },)

#align(center)[
    #text(32pt)[#smallcaps(title)] \ #text(18pt)[#subtitle] \ #text(fill: black.lighten(25%), [#subject])
]

#{
    grid(
        columns: (1fr,) * author.len(),
        column-gutter: -120pt,
        ..author.map(a => align(center)[#a])
    )
}

#align(center)[
    #date
]

#v(16pt)
#grid(
    columns: (1cm, 1fr, 1cm),
    column-gutter: 2pt,
    [],
    [
        - The number of #sym.star.filled's gives a rough indicator of the task's difficulty. You should aim to solve at least all tasks with at most three #sym.star.filled's. Tasks with more stars can be hard or require mathematical background that you should have from previous courses.

        - You can always ask us for feedback or help during the exercise class.

        - We recommend that you first read all tasks during class. Make sure that you have a rough approach for every task in mind before you start working on the details. Ask for help if a task is unclear such that you do not get stuck when we are not there to help.
    ],
    [],
)

#pagebreak()
#outline()
#pagebreak()

#counter(page).update(1)
#show: chic.with(
    chic-footer(
        right-side: "Page " + context str(counter(page).get().first()) + " of " + str(counter(page).final().first()),
    ),
)
= More Loops (#((sym.star.filled,) * 1).join())
In this task our goal is to extend the Guarded Command Language with a `break` and `continue` by a new command `repeat C until b` where `C` is a command and `b` is a boolean expression. Intuitively, the command `repeat C until b` first executes `C`. After that it checks whether `b` golds or not. If yes, it stops execution. Otherwise it keeps executing `C` and checking `b` again.

== Give a formal definition of the edge relation for `repeat C until b`, i.e. define $#text([*edges*]) _(b c) (q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle.filled) bracket.l.stroked #text([`repeat C until b`]) bracket.r.stroked (q_b, q_c)$.
The BNF grammar is extended.
$
    C ::= ...
    | #text([`break`])
    | #text([`continue`])
    | #text([`repeat`]) C #text([`until`]) b
$
The edge relation for `repeat C until b` is related to the edge definition for `do C od`.
#text(size: 11pt)[
    $
        bold("edges")_(b c) (q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle.filled) bracket.l.stroked #text([`repeat C until b`]) bracket.r.stroked (q_b, q_c)
        &=
        bold("edges")_(b c) (q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle.filled) bracket.l.stroked #text([`C ; do`]) not#text([`b`]) -> #text([`C od`]) bracket.r.stroked (q_b, q_c)
    $
]
Applying this relation gives the following formal definition of the edge relation.
#text(size: 11pt)[
    $
        bold("edges")_(b c) (q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle.filled) bracket.l.stroked #text([`repeat C until b`]) bracket.r.stroked (q_b, q_c)
        quad = quad
        #text([`let`]) &q #text([`be fresh`])
        \
        &E_1 = bold("edges")(q_#sym.circle #sym.arrow.r.squiggly q) bracket.l.stroked #text([`C`]) bracket.r.stroked (q_circle.filled, q)
        \
        &E_2 = bold("edges")(q #sym.arrow.r.squiggly q) bracket.l.stroked not#text([`b`]) -> #text([`C`]) bracket.r.stroked (q_#sym.circle.filled, q)
        \
        &E_3 = {(q, b, q_#sym.circle.filled)}
        \
        #text([`in`]) #h(5pt)
        &E_1 union E_2 union E_3
    $
]





= Even More Loops (#((sym.star.filled,) * 2).join())
We extend the Guarded Command Language with a `break` and `continue` by a new command `loop GC pool` for which we generate edges as follows:
$
    #text([*edges*]) _(b c)(q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle.filled) bracket.l.stroked #text([`loop GC pool`]) bracket.r.stroked (q_b, q_c)
    =
    #text([*edges*]) _(b c)(q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle) bracket.l.stroked #text([`GC`]) bracket.r.stroked (q_#sym.circle.filled, q_#sym.circle)
$

_Hint_: A program _simulates_ another one if it can always reach the same final configurations from the same initial configurations, possibly by performing different actions. That is, $C_1$ _simulates_ $C_2$ if, for all $sigma in #text([*Mem*])$, we have $chevron.l q_triangle.r ; sigma chevron.r arrow.r.double.long^* chevron.l q_triangle.l.filled ; sigma' chevron.r$ holds for the program graph of $C_1$ if and only if $chevron.l q_triangle.r ; sigma chevron.r arrow.r.double.long^* chevron.l q_triangle.l.filled ; sigma' chevron.r$ holds for the program graph of $C_2$.


== Explain informally how the above command differs from the command `do GC od`.
The command `do GC od` requires a boolean value $b$ acting as an entry/exit condition for the loop. I.e. before any commends are executed, the program evaluates whether or not $b$ is true.
- If $b$ evaluates to `true`, the program executes `GC`.
- If $b$ evaluates to `false`, the program breaks/exits the loop.

On the contrary, the `loop GC pool` command repeats `GC` indefinitely with no entry/exit condition. Instead, `loop GC pool` requires an explicit `break` command within `GC` to be executed in order to break/exit the loop. In terms of edge relation, no *edge*$(q_circle, "done"bracket.stroked #text([`GC`]) bracket.stroked.r, q_circle.filled)$ is defined for `loop GC pool`, which instead relies solely on a `break` command eventually being executed.


== Is there a way to _simulate_ `do GC od` using `loop GC pool` and `break`?
Expanding `GC` to `b` $->$ `C` for `do GC od` and expanding `GC` to `GC`$#h(0pt) _#text(`1`)$` [] GC`$#h(0pt) _#text(`2`)$ we get the following.

`do b -> C od ` and ` loop GC`$#h(0pt) _#text(`1`)$` [] GC`$#h(0pt) _#text(`2`)$` pool`.

Further expanding `GC`$#h(0pt) _#text(`1`)$ to `¬b -> break` we get the following.
```
loop ¬b -> break [] GC pool
```

This simulates the boolean value $b$ acting as a repetition condition. The value $not b$ may often be expressed as "done$bracket.stroked #text([`GC`]) bracket.stroked.r$". To prove that these _simulate_ eachother, the edge relation for each construct is defined.

For `loop` done$bracket.stroked #text([`GC`]) bracket.stroked.r$ `-> break [] GC pool`, the edge relation is defined as follows.
$
            & #text([*edges*]) _(b c)
              (
                  q_circle
                  arrow.r.squiggly
                  q_circle.filled
              )
              bracket.stroked
              #text([`loop` done$bracket.stroked #text([`GC`]) bracket.stroked.r$ `-> break [] GC pool`])
              bracket.stroked.r
              (q_b, q_c) \
    = space & #text([*edges*]) _(b c)
              (
                  q_circle
                  arrow.r.squiggly
                  q_circle
              )
              bracket.stroked
              #text([done$bracket.stroked #text([`GC`]) bracket.stroked.r$ `-> break [] GC`])
              bracket.stroked.r
              (q_circle.filled, q_circle) \
    = space & #text([*edges*]) _(b c)
              (
                  q_circle
                  arrow.r.squiggly
                  q_circle
              )
              bracket.stroked
              #text([`GC`])
              bracket.stroked.r
              (q_circle.filled, q_circle)
              union
              {
                  (
                      q_circle,
                      "done"bracket.stroked #text([`GC`]) bracket.stroked.r,
                      q_circle.filled
                  )
              }
$
For `do GC od`, the edge relation is defined as follows.
$
            & #text([*edges*]) _(b c)
              (
                  q_circle
                  arrow.r.squiggly
                  q_circle
              )
              bracket.stroked
              #text([`do GC od`])
              bracket.stroked.r
              (q_b, q_c) \
    = space & #text([*edges*]) _(b c)
              (
                  q_circle
                  arrow.r.squiggly
                  q_circle
              )
              bracket.stroked
              #text([`GC`])
              bracket.stroked.r
              (
                  q_circle.filled,
                  q_circle
              )
              union
              {
                  (
                      q_circle,
                      "done"bracket.stroked #text([`GC`]) bracket.stroked.r,
                      q_circle.filled
                  )
              }
$
As the edge relations are the same, the constructs are functionally equivalent. Thus, yes -- there is a way to simulate `do GC od` using `loop GC pool` and `break`.



== Is there a way to _simulate_ `loop GC pool` using `do GC od`?
*Naive approach*

In order to make `do GC od` repeat indefinitely, `GC` is expanded to `true -> C`. The edge relation for both `loop GC pool` and `do true -> C` are defined.

For `do true -> C` the edge relation is defined as follows.
$
            & #text([*edges*]) _(b c)
              (
                  q_circle
                  arrow.r.squiggly
                  q_circle.filled
              )
              bracket.stroked
              #text([`do true -> C od`])
              bracket.stroked.r
              (q_b, q_c) \
    = space & #text([*edges*]) _(b c)
              (
                  q_circle
                  arrow.r.squiggly
                  q_circle
              )
              bracket.stroked
              #text([`C`])
              bracket.stroked.r
              (
                  q_circle.filled,
                  q_circle
              )
              union
              {
                  (
                      q_circle,
                      not#text([`true`]),
                      q_circle.filled
                  )
              } \
    = space & #text([*edges*]) _(b c)
              (
                  q_circle
                  arrow.r.squiggly
                  q_circle
              )
              bracket.stroked
              #text([`C`])
              bracket.stroked.r
              (
                  q_circle.filled,
                  q_circle
              )
$

For `loop GC pool` the edge relation is predefined by the assignment.
$
    &#text([*edges*]) _(b c)(q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle.filled) bracket.l.stroked #text([`loop GC pool`]) bracket.r.stroked (q_b, q_c) \
    = space & #text([*edges*]) _(b c)(q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle) bracket.l.stroked #text([`GC`]) bracket.r.stroked (q_#sym.circle.filled, q_#sym.circle)
$
The edge relation for these are not equivalent, as one loops across a command `C` while another loops across a guarded command `GC`.

*Correct approach*

Instead of expanding `do GC od` to `do true -> C od`, the construct is expanded to `do` done$bracket.stroked #text([`GC`]) bracket.stroked.r$ `-> skip [] GC od`. This differs from the original construct, as done$bracket.stroked #text([`GC`]) bracket.stroked.r$ is defined to be the exit point of the `GC` conditional statement. I.e. if `GC` is expanded to `b -> C`, then done$bracket.stroked #text([`GC`]) bracket.stroked.r$ is equivalent to $not$`b`. The edge relations are defined.

For `do` done$bracket.stroked #text([`GC`]) bracket.stroked.r$ `-> skip [] GC od` the edge relation is defined as follows.
#text(size: 10pt, [
    $
                & #text([*edges*]) _(b c)
                  (
                      q_circle
                      arrow.r.squiggly
                      q_circle.filled
                  )
                  bracket.stroked
                  #text([`do` done$bracket.stroked #text([`GC`]) bracket.stroked.r$ `-> skip [] GC od`])
                  bracket.stroked.r
                  (q_b, q_c) \
        = space & #text([*edges*]) _(b c)
                  (
                      q_circle
                      arrow.r.squiggly
                      q_circle
                  )
                  bracket.stroked
                  #text([done$bracket.stroked #text([`GC`]) bracket.stroked.r$ `-> skip`])
                  bracket.stroked.r
                  (
                      q_circle.filled,
                      q_circle
                  )
                  union
                  #text([*edges*]) _(b c)
                  (
                      q_circle
                      arrow.r.squiggly
                      q_circle
                  )
                  bracket.stroked
                  #text([`GC`])
                  bracket.stroked.r
                  (
                      q_circle.filled,
                      q_circle
                  )
                  union
                  {
                      (
                          q_circle,
                          #text([done$bracket.stroked$`GC`$bracket.stroked.r$]),
                          q_circle.filled
                      )
                  } \
        = space & #text([*edges*]) _(b c)
                  (
                      q_circle
                      arrow.r.squiggly
                      q_circle
                  )
                  bracket.stroked
                  #text([`GC`])
                  bracket.stroked.r
                  (
                      q_circle.filled,
                      q_circle
                  )
                  union
                  {
                      (
                          q_circle,
                          #text([done$bracket.stroked$`GC`$bracket.stroked.r$]),
                          q_circle
                      )
                  } \
        = space & #text([*edges*]) _(b c)
                  (
                      q_circle
                      arrow.r.squiggly
                      q_circle
                  )
                  bracket.stroked
                  #text([`GC`])
                  bracket.stroked.r
                  (
                      q_circle.filled,
                      q_circle
                  )
    $
])

For `loop GC pool` the edge relation is again predefined by the assignment.
#text(size: 10pt, [
    $
        &#text([*edges*]) _(b c)(q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle.filled) bracket.l.stroked #text([`loop GC pool`]) bracket.r.stroked (q_b, q_c) \
        = space & #text([*edges*]) _(b c)(q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle) bracket.l.stroked #text([`GC`]) bracket.r.stroked (q_#sym.circle.filled, q_#sym.circle)
    $
])
These two constructs simulate eachother as the same edge relation can be defined for both of them. Thus, yes -- there is a way to simulate `loop GC pool` using `do GC od`.



= Deterministic Semantics (#((sym.star.filled,) * 3).join())
Let $(#text([*E*]), d) = #text([*edges*]) _("det") (q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle.filled) bracket.l.stroked #text([`GC`]) bracket.r.stroked (#text[`false`])$ for some guarded command `GC`.

== Show that $not d$ is logically equivalent to `done`$bracket.l.stroked #text([`GC`]) bracket.r.stroked$, i.e. for all memories $sigma$, $cal(B)bracket.l.stroked not d bracket.r.stroked (sigma) = cal(B) bracket.l.stroked #text([`done`])bracket.l.stroked #text([`GC`]) bracket.r.stroked bracket.r.stroked (sigma)$. _Hint_: You may want to prove the slightly more general statement $cal(B) bracket.l.stroked not d bracket.r.stroked = cal(B) bracket.l.stroked #text([`done`])bracket.l.stroked #text([`GC`]) bracket.r.stroked and not d' bracket.r.stroked$, where $(#text([*E*]), d) = #text([*edges*]) _"det" (q_#sym.circle #sym.arrow.r.squiggly q_#sym.circle.filled) bracket.l.stroked #text([`GC`]) bracket.r.stroked (d')$ for all guarded commands `GC` and boolean expressions $d'$.




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


