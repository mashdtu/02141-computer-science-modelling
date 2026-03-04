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

#let title = "Regular Languages 3"
#let subtitle = "Regular Expressions"
#let subject = "02141 Computer Science Modelling"
#let date = "February 20th, 2026"

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

#pagebreak()
#outline()

//#v(16pt)
//#grid(columns: (1cm, 1fr, 1cm),
//    column-gutter: 2pt,
//    [],
//    [],
//    []
//)

    

#pagebreak()


= From NFAs to Regular Expressions (#((sym.star.filled,) * 1).join())
#raw-render(width: 100%, ```
    digraph {
        rankdir=LR
        node [shape = circle]
        g [shape=point, width=0]
        s[label="q_0", shape=doublecircle]
        s1[label="q_1"]
        s2[label="q_2"]
        s3[label="q_3"]
        s4[label="q_4"]
        s5[label="q_5"]
        g -> s
        s -> s1
        s -> s2
        s -> s4
        s1 -> s2
        s2 -> s3
        s3 -> s4
        s4 -> s5
        s5 -> s
    }
```)

== Construct a regular expression describing the language of the above NFA.


= True or False? (#((sym.star.filled,) * 2).join())
Determine for each of the statements below, whether it is true or false. Briefly justify your answer.

== There is a regular language $L_1$ such that $L_1$ is accepted by an NFA with 10 states, but not accepted by any DFA with 100 states.


== There is a regular language $L_2$ such that $L_2$ is accepted by an NFA with 10 states, but not accepted by any DFA with 1217 states.


== For every regular expression $E$ over $Sigma$, there exists a regular expression $E'$ over $Sigma$ such that $L(E') = Sigma^* \\ L(E)$.



= Homework: Read the Formula Manual (#((sym.star.filled,) * 2).join())
A machine has two valves, which can be opened for one second using the commands $a$ and $b$. The machine's manufacturer provides no warranty if one does no adhere to the opening sequences specified in the manual by the following NFA.

#raw-render(```
    digraph {
        rankdir=LR
        node [shape = circle]
        g [shape=point, width=0]
        s[label="0"]
        s1[label="1", shape=doublecircle]
        s2[label="2"]
        g -> s
        s -> s[label="a"]
        s -> s1[label="a"]
        s -> s2[label="b"]
        s1 -> s1[label="b"]
        s1 -> s2[label="a"]
        s2 -> s[label="a"]
    }
```)

To be precise : After the machine has been switched on, we are allowed to open the valves according to a permitted opening sequenve and then switch the machine off again. For example, it is _not_ permitted to switch the machine on and off again immediately, as there is no saf eopening sequence according to the manual, i.e. the word $epsilon$ is not accepted by the NFA.

== Is the opening sequence `aaabaabaa` safe or unsafe?


== Construct a DFA and a regular expression that describes all unsafe opening sequences, i.e. precisely those words that are _not_ accepted by the NFA. Explain which constructions you use.




= Commutating Words (#((sym.star.filled,) * 2).join())
Let $v, w in Sigma^*$ such that $v w = w v$.

== Prove that there exists a word $u in Sigma^*$ and natural numbers $i, j in Z_(>= 0)$ such that $v = u^i$ and $w = u^j$. _Hints_: Proceed by inducting over the length of the word $|v w|$. Recall that $u^i$ is given by $u^0 = epsilon$ and $u^(n+1) = u u^n$.


= Walking Through a Museum (#((sym.star.filled,) * 3).join())
The following illustration depicts a plan of a museum with three rooms $A$, $B$ and $C$ and connections between those rooms.
#image("assets/image.png", width: 35%)
A valid path through the museum is a non-empty word over $Sigma = {A, B, C}$ that starts and ends at the museum's entry ($A$). Moreover, paths do not allow "staying" in a room. For example, `ABCABABCA` is a valid path through the museum, whereas `ABBA` or $epsilon$ are not.

== Provide a regular expression over the alphabet $Sigma = {A, B, C}$ that describes all valid paths through the museum.


== Construct a deterministic finite automaton that accepts all valid paths through the museum.



= Modulo Counting (#((sym.star.filled,) * 3).join())

== Contruct a regular expression over the alphabet $Sigma = {a, b}$ whose language consists of all words, which contain an even number of $a$'s _if and only if_ they also contain an even number of $b$'s.



