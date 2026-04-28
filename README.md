# TU Dresden Computer Science Typst Thesis Template

A versatile Typst template for theses, reports, and scientific writing in computer science.
It is designed for students at TU Dresden by default, but university, faculty, institute, chair, and thesis type are user-configurable metadata.

## Files

- `template.typ` – reusable template function
- `example.typ` – example starting point
- `example-ref.bib` – example BibTeX bibliography
- `assets/` – optional logo folder

## Compile

```bash
typst compile main.typ
```

## Minimal usage

```typst
#import "template.typ": tud-cs-thesis

#show: tud-cs-thesis.with(
  lang: "en",
  university: "Technische Universität Dresden",
  faculty: "Faculty of Computer Science",
  thesis-type: "Bachelor Thesis",
  title: "My Thesis",
  authors: ((name: "Ada Lovelace", student-id: "1234567"),),
  supervisors: ((name: "Dr. Example"),),
  bibliography-file: "references.bib",
)

= Introduction

Your text.
```

## Notes

- The template uses translations only for fixed labels such as contents, references, supervisors, and keywords.
- for more information on how to use Typst look at the officail [documentation](https://typst.app/docs/) or watch this [video](https://www.youtube.com/watch?v=BB1zhr-QWjQ&t=27s) 
- University, faculty, thesis type, institute, and chair are normal metadata fields.
- The title page supports multiple authors.
- `logo` is optional. Put an SVG/PDF/PNG in `assets/` and set `logo: "assets/tud-logo-blue.svg"`.
- The default bibliography style is `ieee`.
- The default body layout is one column. Set `columns: 2` if a two-column layout is needed.
