#!/usr/bin/env bun
import { readdirSync, readFileSync, writeFileSync } from "fs";
import { join } from "path";

const outputDir = join(import.meta.dir, "..", "..", "output");

let files: string[];
try {
  files = readdirSync(outputDir).filter((f) => f.endsWith(".json"));
} catch {
  console.error("Directory 'output/' not found. Run from project root.");
  process.exit(1);
}

if (files.length === 0) {
  console.log("No JSON files found in output/.");
  process.exit(0);
}

let changed = 0;

for (const file of files) {
  const fullPath = join(outputDir, file);
  const content = readFileSync(fullPath, "utf-8");

  try {
    const parsed = JSON.parse(content);
    const formatted = JSON.stringify(parsed, null, 2) + "\n";

    if (content !== formatted) {
      writeFileSync(fullPath, formatted, "utf-8");
      console.log(`  Linted: ${file}`);
      changed++;
    }
  } catch {
    console.error(`  Skipped (invalid JSON): ${file}`);
  }
}

if (changed === 0) {
  console.log("All JSONs already consistent.");
} else {
  console.log(`Reindented ${changed} file(s) to 2-space indent.`);
}
