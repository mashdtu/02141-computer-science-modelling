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

#let title = "Practice Exam 2025"
#let subtitle = "Set from Exam Period S25"
#let subject = "02141 Computer Science Modelling"
#let date = "May 23rd, 2025"

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


#outline()
#pagebreak()

#counter(page).update(1)
#show: chic.with(
    chic-footer(
        right-side: "Page " + context str(counter(page).get().first()) + " of " + str(counter(page).final().first()),
    ),
)

= Formal Languages
== Question A
== Question B
== Question C
== Question D
== Question E


= Programming Language Semantics
== Question A
== Question B
== Question C
== Question D
== Question E


= Verification & Analysis
== Question A
== Question B
== Question C
== Question D
== Question E


= Model Checking & Sign Analysis
== Question A
== Question B
== Question C
== Question D
== Question E



