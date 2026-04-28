// TU Dresden thesis template for Typst
// Targeted at Typst 0.14.x, but intentionally avoids uncommon packages.
// Author-facing metadata is configurable; translations are only used for fixed labels.

#let labels = (
  de: (
    abstract: "Zusammenfassung",
    abstract_en: "Abstract",
    acknowledgements: "Danksagung",
    appendix: "Anhang",
    bibliography: "Literaturverzeichnis",
    contents: "Inhaltsverzeichnis",
    declaration: "Selbstständigkeitserklärung",
    examiners: "Prüfende",
    keywords: "Schlagwörter",
    list_of_figures: "Abbildungsverzeichnis",
    list_of_tables: "Tabellenverzeichnis",
    matriculation_number: "Matrikelnummer",
    supervisors: "Betreuung",
  ),
  en: (
    abstract: "Abstract",
    abstract_en: "Abstract",
    acknowledgements: "Acknowledgements",
    appendix: "Appendix",
    bibliography: "References",
    contents: "Contents",
    declaration: "Declaration of Authorship",
    examiners: "Examiners",
    keywords: "Keywords",
    list_of_figures: "List of Figures",
    list_of_tables: "List of Tables",
    matriculation_number: "Student ID",
    supervisors: "Supervisors",
  ),
)

#let _label(lang, key) = labels.at(lang).at(key)

#let _maybe-block(title, content) = {
  if content != none {
    heading(level: 1, numbering: none)[#title]
    content
    pagebreak()
  }
}

#let _person-line(person, role: none) = {
  if type(person) == dictionary {
    let name = person.at("name", default: "")
    let affiliation = person.at("affiliation", default: none)
    let email = person.at("email", default: none)

    [#name]
    if role != none [ — #role]
    if affiliation != none [\ #text(size: 9.5pt)[#affiliation]]
    if email != none [\ #text(size: 9.5pt)[#email]]
  } else {
    person
  }
}

#let _author-block(author, lang) = {
  let name = if type(author) == dictionary { author.at("name", default: "") } else { author }
  let student-id = if type(author) == dictionary { author.at("student-id", default: none) } else { none }
  let email = if type(author) == dictionary { author.at("email", default: none) } else { none }
  let affiliation = if type(author) == dictionary { author.at("affiliation", default: none) } else { none }

  text(size: 12pt, weight: "bold")[#name]
  if student-id != none [\ #text(size: 9.5pt)[#_label(lang, "matriculation_number"): #student-id]]
  if email != none [\ #text(size: 9.5pt)[#email]]
  if affiliation != none [\ #text(size: 9.5pt)[#affiliation]]
}

#let _chunk(items, size) = {
  let rows = ()
  for i in range(0, items.len(), step: size) {
    rows.push(items.slice(i, calc.min(i + size, items.len())))
  }
  rows
}

#let _person-row(items, lang, kind: "author") = {
  let cols = if items.len() == 1 {
    (1fr,)
  } else if items.len() == 2 {
    (1fr, 1fr)
  } else {
    (1fr, 1fr, 1fr)
  }

  grid(
    columns: cols,
    gutter: 8mm,
    ..items.map(item => align(center)[
      #if kind == "author" {
        _author-block(item, lang)
      } else {
        _person-line(item)
      }
    ])
  )
}

#let _person-grid(items, lang, kind: "author") = {
  stack(
    dir: ttb,
    spacing: 5mm,
    .._chunk(items, 3).map(row => _person-row(row, lang, kind: kind)),
  )
}

#let _title-page(
  lang,
  university,
  faculty,
  institute,
  chair,
  thesis-type,
  title,
  subtitle,
  authors,
  supervisors,
  examiners,
  date,
  logo,
) = {
  set page(header: none, footer: none)

  if logo != none {
    place(top + left, dx: -13mm, dy: -13mm, image(logo, height: 20mm))
  }

  align(center)[
    #v(18mm)

    #text(size: 13pt)[#university] \
    #text(size: 12pt)[#faculty]
    #if institute != none [\ #text(size: 11pt)[#institute]]
    #if chair != none [\ #text(size: 11pt)[#chair]]

    #v(32mm)

    #text(size: 14pt)[#thesis-type]

    #text(size: 22pt, weight: "bold")[#title]

    #if subtitle != none [
      #text(size: 12pt)[#subtitle]
    ]

    #v(25mm)

    #_person-grid(authors, lang, kind: "author")

    #v(8mm)

    #if supervisors.len() > 0 [
      #text(weight: "bold")[#_label(lang, "supervisors")]
      #v(1mm)
      #_person-grid(supervisors, lang, kind: "person")
    ]

    #if examiners.len() > 0 [
      #v(5mm)
      #text(weight: "bold")[#_label(lang, "examiners")]
      #v(1mm)
      #_person-grid(examiners, lang, kind: "person")
    ]

    #v(1fr)

    #date
  ]

  pagebreak()
}

#let _frontmatter(
  lang,
  abstract,
  abstract-en,
  acknowledgements,
  declaration,
  show-figures,
  show-tables,
) = {
  set page(numbering: "I", footer: context align(center)[#counter(page).display()])
  counter(page).update(1)

  _maybe-block(_label(lang, "abstract"), abstract)
  _maybe-block(_label(lang, "abstract_en"), abstract-en)


  _maybe-block(_label(lang, "acknowledgements"), acknowledgements)
  _maybe-block(_label(lang, "declaration"), declaration)

  outline(title: _label(lang, "contents"), target: heading.where(numbering: "1.1.1"), depth: 3)
  pagebreak()

  if show-figures {
    outline(title: _label(lang, "list_of_figures"), target: figure.where(kind: image))
    pagebreak()
  }

  if show-tables {
    outline(title: _label(lang, "list_of_tables"), target: figure.where(kind: table))
    pagebreak()
  }
}

#let tud-thesis(
  lang: "de",
  // User-defined metadata. These are intentionally not translated.
  university: "Technische Universität Dresden",
  faculty: "Fakultät Informatik",
  institute: none,
  chair: none,
  thesis-type: "Bachelorarbeit",
  title: "",
  subtitle: none,
  authors: (),
  supervisors: (),
  examiners: (),
  date: "",
  logo: none,
  // Layout.
  paper: "a4",
  margin: (left: 35mm, right: 25mm, top: 25mm, bottom: 25mm),
  columns: 1,
  font: "New Computer Modern",
  font-size: 11pt,
  line-leading: 0.65em,
  // ACL-inspired scientific extras.
  abstract: none,
  abstract-en: none,
  acknowledgements: none,
  declaration: none,
  appendix: none,
  // Generated lists and bibliography.
  show-figures: true,
  show-tables: true,
  bibliography-file: none,
  bibliography-style: "ieee",
  body,
) = {
  let doc-authors = authors.map(a => if type(a) == dictionary { a.at("name", default: "") } else { a }).join(", ")

  set document(title: title, author: doc-authors)
  set text(lang: lang, font: font, size: font-size)
  set par(justify: true, leading: line-leading)

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(1.2em)
    text(size: 18pt, weight: "bold")[#it.body]
    v(0.7em)
  }

  _title-page(
    lang,
    university,
    faculty,
    institute,
    chair,
    thesis-type,
    title,
    subtitle,
    authors,
    supervisors,
    examiners,
    date,
    logo,
  )
  set page(paper: paper, margin: margin, columns: columns)
  set heading(numbering: "1.1.1")
  set figure(numbering: "1")
  set table(inset: 5pt)

  _frontmatter(
    lang,
    abstract,
    abstract-en,
    acknowledgements,
    declaration,
    show-figures,
    show-tables,
  )

  counter(page).update(1)
  set page(numbering: "1", footer: context align(center)[#counter(page).display()])

  body

  if appendix != none {
    pagebreak()
    heading(level: 1, numbering: none)[#_label(lang, "appendix")]
    appendix
  }

  if bibliography-file != none {
    pagebreak()
    bibliography(
      bibliography-file,
      title: _label(lang, "bibliography"),
      style: bibliography-style,
    )
  }
}
