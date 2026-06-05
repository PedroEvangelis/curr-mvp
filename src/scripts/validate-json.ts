import { z } from "zod";
import { readFileSync } from "fs";

const DateRange = z.object({
  start: z.string(),
  end: z.string(),
});

const BaseItem = z.object({
  technologies: z.array(z.string()).optional(),
  methodologies: z.array(z.string()).optional(),
  keywords: z.array(z.string()).optional(),
  bullets: z.array(z.string()),
});

const EducationItem = BaseItem.extend({
  institution: z.string(),
  degree: z.string(),
  level: z.string().optional(),
  dates: DateRange,
  gpa: z.string().optional(),
});

const WorkItem = BaseItem.extend({
  company: z.string(),
  title: z.string(),
  dates: DateRange,
});

const ProjectItem = BaseItem.extend({
  name: z.string(),
  role: z.string().optional(),
  url: z.string().optional(),
  dates: DateRange,
});

const CertificateItem = BaseItem.extend({
  name: z.string(),
  issuer: z.string(),
  url: z.string().optional(),
  date: z.string(),
});

const ExtracurricularItem = z.object({
  activity: z.string(),
  dates: DateRange,
  bullets: z.array(z.string()),
});

const SkillItem = z.object({
  category: z.string(),
  skills: z.array(z.string()),
});

const LanguageItem = z.object({
  language: z.string(),
  proficiency: z.string(),
});

const Section = z.discriminatedUnion("type", [
  z.object({
    type: z.literal("education"),
    title: z.string(),
    items: z.array(EducationItem),
  }),
  z.object({
    type: z.literal("work"),
    title: z.string(),
    items: z.array(WorkItem),
  }),
  z.object({
    type: z.literal("projects"),
    title: z.string(),
    items: z.array(ProjectItem),
  }),
  z.object({
    type: z.literal("certificates"),
    title: z.string(),
    items: z.array(CertificateItem),
  }),
  z.object({
    type: z.literal("extracurriculars"),
    title: z.string(),
    items: z.array(ExtracurricularItem),
  }),
  z.object({
    type: z.literal("skills"),
    title: z.string(),
    items: z.array(SkillItem),
  }),
  z.object({
    type: z.literal("languages"),
    title: z.string(),
    items: z.array(LanguageItem),
  }),
]);

const ResumeSchema = z.object({
  meta: z.object({
    template: z.string(),
    "accent-color": z.string(),
    "body-color": z.string().optional(),
    font: z.string(),
    paper: z.string(),
    "author-position": z.enum(["left", "right", "center"]),
    "personal-info-position": z.enum(["left", "right", "center"]),
    lang: z.string(),
    keywords: z.string(),
    "tech-block-font-size": z.number().optional(),
  }),
  personal: z.object({
    name: z.string(),
    email: z.string(),
    phone: z.string(),
    github: z.string(),
    linkedin: z.string(),
    "personal-site": z.string(),
    pronouns: z.string(),
  }),
  summary: z.string().optional(),
  sections: z.array(Section),
});

function main() {
  const args = process.argv.slice(2);
  if (args.length < 1) {
    console.error("Usage: bun run src/scripts/validate-json.ts <json-file>");
    process.exit(1);
  }

  const filePath = args[0];
  let raw: unknown;

  try {
    const content = readFileSync(filePath, "utf-8");
    raw = JSON.parse(content);
  } catch (err) {
    console.error(`Error reading/parsing ${filePath}: ${(err as Error).message}`);
    process.exit(1);
  }

  const result = ResumeSchema.safeParse(raw);

  if (!result.success) {
    console.error(`Error: validation failed for ${filePath}`);
    for (const issue of result.error.issues) {
      const path = issue.path.join(".");
      console.error(`  - ${path}: ${issue.message}`);
    }
    process.exit(1);
  }

  console.log(`OK: ${filePath}`);
}

main();
