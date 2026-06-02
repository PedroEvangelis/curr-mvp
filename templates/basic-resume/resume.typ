#let resume(
  author: "",
  author-position: left,
  personal-info-position: left,
  pronouns: "",
  location: "",
  email: "",
  github: "",
  linkedin: "",
  phone: "",
  personal-site: "",
  accent-color: "#000000",
  body-color: "#000000",
  font: ("Noto Sans", "Segoe UI", "Arial"),
  paper: "us-letter",
  author-font-size: 18pt,
  font-size: 11pt,
  tech-block-font-size: 9.5pt,
  lang: "en",
  keywords: "",
  body,
) = {
  set document(author: author, title: author, keywords: keywords)

  set text(
    font: font,
    size: font-size,
    fill: rgb(body-color),
    lang: lang,
    ligatures: false
  )

  set page(
    margin: (0.4in),
    paper: paper,
  )

  show link: underline

  show heading.where(level: 2): it => [
    #v(1.8em)
    #smallcaps(it.body)
    #line(length: 100%, stroke: 1pt)
    #v(0.4em)
  ]

  show heading.where(level: 3): set block(above: 1.2em, below: 0.25em)

  show heading: set text(
    fill: rgb(accent-color),
  )

  show link: set text(
    fill: rgb(accent-color),
  )

  show heading.where(level: 1): it => [
    #set align(author-position)
    #set text(
      weight: 700,
      size: author-font-size,
    )
    #pad(it.body)
  ]

  [= #(author)]

  let contact-item(value, prefix: "", link-type: "") = {
    if value != "" {
      if link-type != "" {
        link(link-type + value)[#(prefix + value)]
      } else {
        value
      }
    }
  }

  pad(
    top: 0.25em,
    align(personal-info-position)[
      #{
        let items = (
          contact-item(pronouns),
          contact-item(phone, link-type: "tel:"),
          contact-item(location),
          contact-item(email, link-type: "mailto:"),
          contact-item(github, link-type: "https://"),
          contact-item(linkedin, link-type: "https://"),
          contact-item(personal-site, link-type: "https://"),
        )
        items.filter(x => x != none).join("  |  ")
      }
    ],
  )

  set par(justify: true)
  set list(spacing: 0.15em)

  body
}

#let generic-two-by-two(
  top-left: "",
  top-right: "",
  bottom-left: "",
  bottom-right: "",
) = {
  [
    #top-left #h(1fr) #top-right \
    #bottom-left #h(1fr) #bottom-right
  ]
}

#let generic-one-by-two(
  left: "",
  right: "",
) = {
  [
    #left #h(1fr) #right
  ]
}

#let tech-block(technologies: (), methodologies: (), keywords: (), size: 9.5pt) = {
  let parts = ()
  if technologies.len() > 0 { parts.push([_Tecnologias:_ #technologies.join(", ")]) }
  if methodologies.len() > 0 { parts.push([_Metodologias:_ #methodologies.join(", ")]) }
  if keywords.len() > 0 { parts.push([_Palavras-chave:_ #keywords.join(", ")]) }
  if parts.len() > 0 {
    let result = parts.at(0)
    for i in range(1, parts.len()) {
      result = [#result \ #parts.at(i)]
    }
    set text(size: size)
    [#result]
  }
}

#let edu(
  institution: "",
  dates: "",
  degree: "",
  location: "",
  level: "",
  technologies: "",
  methodologies: "",
  keywords: "",
) = {
  heading(level: 3)[
    #strong(institution) #if level != "" { [ — #level] }
  ]
  generic-two-by-two(
    top-left: emph(degree),
    top-right: dates,
    bottom-left: "",
    bottom-right: emph(location),
  )
  v(0.4em)
}

#let work(
  title: "",
  dates: "",
  company: "",
  location: "",
  technologies: "",
  methodologies: "",
  keywords: "",
) = {
  heading(level: 3)[#company]
  generic-two-by-two(
    top-left: strong(title),
    top-right: dates,
    bottom-left: "",
    bottom-right: emph(location),
  )
  v(0.4em)
}

#let project(
  role: "",
  name: "",
  url: "",
  dates: "",
  technologies: "",
  methodologies: "",
  keywords: "",
) = {
  heading(level: 3)[#role]
  generic-two-by-two(
    top-left: name,
    top-right: dates,
    bottom-left: "",
    bottom-right: {
      if url != "" { link("https://" + url)[#url] }
    },
  )
  v(0.4em)
}

#let certificates(
  name: "",
  issuer: "",
  url: "",
  date: "",
  technologies: "",
  methodologies: "",
  keywords: "",
) = {
  heading(level: 3)[
    *#name*, #issuer
    #if url != "" {
      [ (#link("https://" + url)[#url])]
    }
    #h(1fr) #date
  ]
  v(0.4em)
}

#let extracurriculars(
  activity: "",
  dates: "",
) = {
  generic-one-by-two(
    left: strong(activity),
    right: dates,
  )
  v(0.3em)
}


