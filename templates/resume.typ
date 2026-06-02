#import "basic-resume/resume.typ": *

#let data = json(sys.inputs.at("data"))

#let opt(x) = if x == none { "" } else { x }

#let opt-len(x) = {
  if type(x) == "array" { x }
  else if x == none or x == "" { () }
  else { x }
}

#let pos(x) = {
  if x == "center" { center }
  else if x == "right" { right }
  else { left }
}

#let fmt-dates(start, end) = {
  if start != "" and end != "" {
    start + " — " + end
  } else if start != "" {
    start
  } else if end != "" {
    end
  } else {
    ""
  }
}

#let tb-size = if "tech-block-font-size" in data.meta { data.meta.tech-block-font-size * 1pt } else { 9.5pt }

#show: resume.with(
  author: opt(data.personal.name),
  email: opt(data.personal.email),
  github: opt(data.personal.github),
  linkedin: opt(data.personal.linkedin),
  phone: opt(data.personal.phone),
  personal-site: opt(data.personal.personal-site),
  pronouns: opt(data.personal.pronouns),
  accent-color: data.meta.accent-color,
  body-color: data.meta.body-color,
  font: data.meta.font,
  paper: data.meta.paper,
  author-position: pos(data.meta.author-position),
  personal-info-position: pos(data.meta.personal-info-position),
  lang: data.meta.lang,
  keywords: opt(data.meta.keywords),
  tech-block-font-size: tb-size,
)

#if "summary" in data and data.summary != "" {
  data.summary
  v(0.7em)
}

#for section in data.sections {
  if section.items.len() > 0 {
    heading(level: 2)[#section.title]

    if section.type == "education" {
      for item in section.items {
        edu(
          institution: item.institution,
          degree: item.degree,
          level: opt(item.level),
          dates: fmt-dates(item.dates.start, item.dates.end),
          technologies: opt(item.technologies),
          methodologies: opt(item.methodologies),
          keywords: opt(item.keywords),
        )
        list(..item.bullets.map(bullet => [#bullet]))
        v(0.4em)
        tech-block(
          technologies: opt(item.technologies),
          methodologies: opt(item.methodologies),
          keywords: opt(item.keywords),
          size: tb-size,
        )
        v(0.3em)
      }

    } else if section.type == "work" {
      for item in section.items {
        work(
          title: item.title,
          company: item.company,
          dates: fmt-dates(item.dates.start, item.dates.end),
          technologies: opt(item.technologies),
          methodologies: opt(item.methodologies),
          keywords: opt(item.keywords),
        )
        list(..item.bullets.map(bullet => [#bullet]))
        v(0.4em)
        tech-block(
          technologies: opt(item.technologies),
          methodologies: opt(item.methodologies),
          keywords: opt(item.keywords),
          size: tb-size,
        )
        v(0.3em)
      }

    } else if section.type == "projects" {
      for item in section.items {
        project(
          name: item.name,
          role: item.role,
          url: item.url,
          dates: fmt-dates(item.dates.start, item.dates.end),
          technologies: opt(item.technologies),
          methodologies: opt(item.methodologies),
          keywords: opt(item.keywords),
        )
        list(..item.bullets.map(bullet => [#bullet]))
        v(0.4em)
        tech-block(
          technologies: opt(item.technologies),
          methodologies: opt(item.methodologies),
          keywords: opt(item.keywords),
          size: tb-size,
        )
        v(0.3em)
      }

    } else if section.type == "certificates" {
      for item in section.items {
        certificates(
          name: item.name,
          issuer: item.issuer,
          url: item.url,
          date: item.date,
          technologies: opt(item.technologies),
          methodologies: opt(item.methodologies),
          keywords: opt(item.keywords),
        )
        list(..item.bullets.map(bullet => [#bullet]))
        v(0.4em)
        tech-block(
          technologies: opt(item.technologies),
          methodologies: opt(item.methodologies),
          keywords: opt(item.keywords),
          size: tb-size,
        )
        v(0.3em)
      }

    } else if section.type == "extracurriculars" {
      for item in section.items {
        extracurriculars(
          activity: item.activity,
          dates: fmt-dates(item.dates.start, item.dates.end),
        )
        list(..item.bullets.map(bullet => [#bullet]))
      }

    } else if section.type == "skills" {
      for item in section.items {
        heading(level: 3)[#item.category]
        [#item.skills.join(", ")]
      }

    } else if section.type == "languages" {
      for item in section.items {
        heading(level: 3)[#item.language]
        [#item.proficiency]
      }
    }
  }
}
