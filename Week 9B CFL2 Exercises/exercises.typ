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

#let title = "Context Free Languages 2"
#let subtitle = "Grammars & Data -- Ambiguities -- Associativity & Precedence"
#let subject = "02141 Computer Science Modelling"
#let date = "February 27th, 2026"

#let author = (if read("../.secret").trim() == "" { "name" } else { read("../.secret").trim() },)

#align(center)[
    #text(32pt)[#smallcaps(title)] \ #text(16pt)[#subtitle] \ #text(fill:black.lighten(25%), [#subject])
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


= More HTML
Consider the following grammar for HTML.
#table(columns: 3, 
    [1.], [#text([`Char`])],       [$a | A | ...$],
    [2.], [#text([`Text`])],       [$epsilon | #text([`Char`]) #text([`Text`])$],
    [3.], [#text([`Doc`])],        [$epsilon | #text([`Element`]) #text([`Doc`])$],
    [4.], [#text([`Element`])],    [$#text([`Text`]) | "<EM>"#text([`Doc`])"</EM>" | "<P>"#text([`Doc`]) | "<OL>"#text([`List`])"</OL>" | ...$],
    [5.], [#text([`ListItem`])],   [$"<LI>"#text([`Doc`])$],
    [6.], [#text([`List`])],       [$epsilon | #text([`ListItem`]) #text([`List`])$],
)

Add the following forms to the HTML grammar.

== \* A list item must be ended by a closing tag #text("</LI>").
The table is adjusted accordingly, with changes highlighted in #text(fill: blue, "blue").
#table(columns: 3, 
    [1.], [#text([`Char`])],       [$a | A | ...$],
    [2.], [#text([`Text`])],       [$epsilon | #text([`Char`]) #text([`Text`])$],
    [3.], [#text([`Doc`])],        [$epsilon | #text([`Element`]) #text([`Doc`])$],
    [4.], [#text([`Element`])],    [$#text([`Text`]) | "<EM>"#text([`Doc`])"</EM>" | "<P>"#text([`Doc`]) | "<OL>"#text([`List`])"</OL>" | ...$],
    [5.], [#text([`ListItem`])],   [$"<LI>"#text([`Doc`])#text(fill: blue, "</LI>")$],
    [6.], [#text([`List`])],       [$epsilon | #text([`ListItem`]) #text([`List`])$],
)



== An element can be an unordered list, as well as an ordered list. Unordered lists are surrounded by the tag #text("<UL>") and its closing #text("</UL>").
The table is adjusted accordingly, with changes highlighted in #text(fill: red, "red").
#table(columns: 3,
    [1.], [#text([`Char`])],       [$a | A | ...$],
    [2.], [#text([`Text`])],       [$epsilon | #text([`Char`]) #text([`Text`])$],
    [3.], [#text([`Doc`])],        [$epsilon | #text([`Element`]) #text([`Doc`])$],
    [4.], [#text([`Element`])],    [$#text([`Text`]) | $$"<EM>"#text([`Doc`])"</EM>" | $$"<P>"#text([`Doc`]) | $$"<OL>"#text([`List`])"</OL>" | $$#text(fill: red, "<UL>")#text(fill: red, [`List`])#text(fill: red, "</UL>") | ...$],
    [5.], [#text([`ListItem`])],   [$"<LI>"#text([`Doc`])#text(fill: blue, "</LI>")$],
    [6.], [#text([`List`])],       [$epsilon | #text([`ListItem`]) #text([`List`])$],
)


== \! An element can be a table. Tables are surrounded by #text("<TABLE>") and its closer #text("</TABLE>"). Inside these tags are one or more rows, each of which is surrounded by #text("<TR>") and #text("</TR>"). The first row is the header, with one or more fields, each introduced by the #text("<TH>") tag (we'll assume these are not close, althought they should be). Subsequent rows have their fields introduced by the #text("<TD>") tag.
The table is adjusted accordingly, with changes highlighted in #text(fill: green, "green").
#table(columns: 3,
    [1.],   [#text([`Char`])],                                  [$a | A | ...$],
    [2.],   [#text([`Text`])],                                  [$epsilon | #text([`Char`]) #text([`Text`])$],
    [3.],   [#text([`Doc`])],                                   [$epsilon | #text([`Element`]) #text([`Doc`])$],
    [4.],   [#text([`Element`])],                               [$#text([`Text`]) | $$"<EM>"#text([`Doc`])"</EM>" | $$"<P>"#text([`Doc`]) | $$"<OL>"#text([`List`])"</OL>" | $$#text(fill: red, "<UL>")#text(fill: red, [`List`])#text(fill: red, "</UL>") | $$ #text(fill: green, " <TABLE>")#text(fill: green, [`Table`$#h(0pt)_H$])#text(fill: green, "</TABLE>") | ...$],
    [5.],   [#text([`ListItem`])],                              [$"<LI>"#text([`Doc`])#text(fill: blue, "</LI>")$],
    [6.],   [#text([`List`])],                                  [$epsilon | #text([`ListItem`]) #text([`List`])$],
    [7.],   [#text(fill: green, [`Table`$#h(0pt)_I$])],         [$#text(fill: green, [$epsilon$]) | $ #text(fill: green, "<TR>")#text(fill: green, [`TableItem`$#h(0pt)_I$])#text(fill: green, "</TR>") #text(fill: green, [`Table`$#h(0pt)_I$])],
    [8.],   [#text(fill: green, [`Table`$#h(0pt)_H$])],         [#text(fill: green, "<TR>")#text(fill: green, [`TableItem`$#h(0pt)_H$])#text(fill: green, "</TR>") #text(fill: green, [`Table`$#h(0pt)_I$]) $|$#text(fill: green, " <TR>")#text(fill: green, [`TableItem`$#h(0pt)_H$])#text(fill: green, "</TR>")],
    [9.],   [#text(fill: green, [`TableItem`$#h(0pt)_I$])],     [$#text(fill: green, [$epsilon$]) | $ #text(fill: green, "<TD>")#text(fill: green, [`Element`])#text(fill: green, "</TD>") #text(fill: green, [`TableItem`$#h(0pt)_I$])],
    [10.],  [#text(fill: green, [`TableItem`$#h(0pt)_H$])],     [#text(fill: green, "<TH>")#text(fill: green, [`Element`])#text(fill: green, "</TH>") #text(fill: green, [`TableItem`$#h(0pt)_H$]) $|$ #text(fill: green, "<TH>")#text(fill: green, [`Element`])#text(fill: green, "</TH>")]
)





= From DTD to CFG
```xml
<!DOCTYPE CourseSpecs [
    <!ELEMENT COURSES (COURSE+)>
    <!ELEMENT COURSE (CNAME, PROF, STUDENT*, TA?)>
    <!ELEMENT CNAME (#PCDATA)>
    <!ELEMENT PROF (#PCDATA)>
    <!ELEMENT STUDENT (#PCDATA)>
    <!ELEMENT TA (#PCDATA)> ]>
```

== Convert the DTD to a context free grammar. You don't need to specify the `#PCDATA`.





= A Simple Smbiguous Grammar
Consider the grammar
$
    S -> a S | a S b S | epsilon
$
This grammar is ambiguous.

== Show that the string `aab` has two parse trees.



== Show that the string `aab` has two leftmost derivations.


== Show that the string `aab` has two rightmost derivations.


== Can you see similarities with `if-then-else` constructs with optional `else`? How would you interpret `if P then if Q then X else Y`?


== Find an unambiguous grammar for the language.



= Polish Expressions
The following grammar generates prefix expressions with operands $x$ and $y$ and binary operators +, - and \*:
$
    E -> + E E | * E E | - E E | x | y
$


== Find leftmost and rightmost derivations, and a derivation tree for the string `+*-xyxy`.
The leftmost derivation is as follows.
$
    #text([`E`])
    thick thick -> thick thick #text([`+EE`])
    thick thick -> thick thick #text([`+*EEE`])
    thick thick -> thick thick #text([`+*-EEEE`])
    thick thick -> thick thick #text([`+*-xEEE`])
    thick thick -> thick thick #text([`+*-xyEE`])
    thick thick -> thick thick #text([`+*-xyxE`])
    thick thick -> thick thick #text([`+*-xyxy`])
$

The rightmost derivation is as follows.
$
    #text([`E`])
    thick thick -> thick thick #text([`+EE`])
    thick thick -> thick thick #text([`+Ey`])
    thick thick -> thick thick #text([`+*EEy`])
    thick thick -> thick thick #text([`+*Exy`])
    thick thick -> thick thick #text([`+*-EExy`])
    thick thick -> thick thick #text([`+*-Eyxy`])
    thick thick -> thick thick #text([`+*-xyxy`])
$


Producing the following derivation tree.
#raw-render(width: 40%,
    ```
    digraph {
        rankdir=TB
        node [shape = square]
        edge [arrowhead=none]
        //g [shape=point, width=0]
        
        e[label="E", math=on]
        e1[label="E", math=on]
        e2[label="E", math=on]
        e3[label="E"]
        e4[label="E"]
        e5[label="E"]
        e6[label="E"]
    
        s[label="+", math=on]
        s1[label="*", math=on]
        s2[label="-", math=on]
        s3[label="x", math=on]
        s4[label="y", math=on]
        s5[label="x", math=on]
        s6[label="y", math=on]

        {
            rank=same
            edge[dir=none color=invis]
            s -> s1
            s1 -> s2
            s2 -> s3
            s3 -> s4
            s4 -> s5
            s5 -> s6
        }

        e -> s
        e -> e1
        e -> e6
        e6 -> s6
        e1 -> s1
        e1 -> e2
        e1 -> e5
        e5 -> s5
        e2 -> s2
        e2 -> e3
        e3 -> s3
        e2 -> e4
        e4 -> s4

    }
```)




== Give a parse tree for `+*-xyxy`.
Essentially the exact same thing as a derivation tree.
#raw-render(width: 40%,
    ```
    digraph {
        rankdir=TB
        node [shape = circle]
        edge [arrowhead=none]
        //g [shape=point, width=0]

        
        s[label="+", math=on]    
        s1[label="*", math=on]
        s2[label="-", math=on]
        
        e[label="E", math=on]
        e1[label="E", math=on]
        e2[label="E", math=on]
        e3[label="E"]
        e4[label="E"]
        e5[label="E"]
        e6[label="E"]

        s3[label="x", math=on]
        s4[label="y", math=on]
        s5[label="x", math=on]
        s6[label="y", math=on]

        e -> s
        e -> e1
        e -> e6
        e6 -> s6
        e1 -> s1
        e1 -> e2
        e1 -> e5
        e5 -> s5
        e2 -> s2
        e2 -> e3
        e3 -> s3
        e2 -> e4
        e4 -> s4
    }
```)




== Is this grammar ambiguous? If yes, provide an example. Otherwise, provide an informal argument or a formal proof.





#pagebreak()
= Bonus Exercise
For simplicity, let us consider the case where the original grammar $G$ has two productions
$
    A -> A circle.filled.small A, quad A -> gamma
$
and we transform the grammar $G$ into $G'$ by replacing the former two productions by
$
    A -> A circle.filled.small gamma.
$

To see that any word in $L(G')$ is also in $L(G)$, we observe that any deriviation in $G'$ can be mimicked by $G$. The only interesting points in a deriviation is when we use the new production:
#align(center, [
    #image("assets/image.png", width: 50%)
])

where #text(fill: red, [$=>$]) is the challenge by $G'$, and #text(fill: blue, [$=>$]) is how $G$ mimicks the challenge. This observation can be used in a proof by induction on deriviations. The opposite direction (any word in $L(G)$ is also in $L(G')$) is a bit more tricky. We observe that any deriviation from $A$ in $G$ can be mimicked by $G'$:
#align(center, [
    #image("assets/image-1.png", width: 50%)
])
The left deriviation in $G$ (red) can be mimicked by the right deriviation in $G$ (green), which in turn can be mimicked by $G'$ (blue). We can prove that both *Enforce Assoc -- Method 1* and *Enforce Assoc -- Method 2* yield the same language by proving that a specific transformation of grammars preserves the language.

Let $G$ and $G'$ be grammars, where $G'$ is like $G$ with a difference:

1. One production $A -> gamma$ has been replaced by two productions in $G'$, namely $A -> B$ and $B -> gamma$, where $B$ is a fresh non-terminal (i.e. it does not appear in $G$).

We can prove that $G$ and $G'$ are equivalent. We can prove that for any symbol $X$ in $G$, $L(X)$ and $L(X')$ is the same. The key observation is that any deriviation in $G$ can be mimicked by an equivalent deriviation in $G$, and vice versa, as suggested in the following diagram:'
#align(center, [
    #image("assets/image-2.png", width: 50%)
])

A detailed proof would use induction on the length of the deriviations, with the above observation as the key instrument in the proof. To prove that *Enforce Assoc -- Method 1* and *Enforce Assoc -- Method 2* are equivalent, we observe that the grammar resulting from the latter is obtained by applying the grammar transformation from the former a number of times.
\

Let $G$ be a CFG which has at least a non-terminal symbol $A$ with two productions $A -> gamma_1 gamma_2$ and $A -> gamma_1 gamma_3$. CFG $G$ may have additional non-terminals and productions.

We now construct $G'$ by making the following changes: $A -> gamma_1 gamma_2$ and $A -> gamma_1 gamma_3$ are replaced by productions $A -> gamma_1 B$
, $B -> gamma_2$ and $B -> gamma_3$, where $B$ is fresh (i.e. not appearing in $G$).

== Show that $G$ and $G'$ define the same language.


