#!/usr/bin/env node
/**
 * Check FR/EN parity: every French quest/cheatsheet must have
 * an English equivalent, and vice versa. Also checks that
 * frontmatter keys match between paired files.
 */

const fs = require("fs");
const path = require("path");

const SRC = path.resolve(__dirname, "../../src");
const PAIRS = [
  { fr: "fr/quetes", en: "en/quests" },
  { fr: "fr/cheatsheets", en: "en/cheatsheets" },
];

let errors = 0;

function getFrontmatter(filePath) {
  const content = fs.readFileSync(filePath, "utf8");
  const match = content.match(/^---\n([\s\S]*?)\n---/);
  if (!match) return {};
  const fm = {};
  for (const line of match[1].split("\n")) {
    const kv = line.match(/^(\w[\w_]*)\s*:/);
    if (kv) fm[kv[1]] = true;
  }
  return fm;
}

function getSlugMap(dir) {
  if (!fs.existsSync(dir)) return new Map();
  const map = new Map();
  for (const file of fs.readdirSync(dir)) {
    if (!file.endsWith(".njk") || file === "index.njk") continue;
    const fm = getFrontmatter(path.join(dir, file));
    const questNum = file.match(/^(\d+|A\d+)-/);
    if (questNum) {
      map.set(questNum[1], { file, keys: Object.keys(fm) });
    }
  }
  return map;
}

for (const pair of PAIRS) {
  const frDir = path.join(SRC, pair.fr);
  const enDir = path.join(SRC, pair.en);
  const frMap = getSlugMap(frDir);
  const enMap = getSlugMap(enDir);

  // Check FR files have EN equivalent
  for (const [num, info] of frMap) {
    if (!enMap.has(num)) {
      console.error(`MISSING EN: ${pair.fr}/${info.file} has no English equivalent (quest ${num})`);
      errors++;
    }
  }

  // Check EN files have FR equivalent
  for (const [num, info] of enMap) {
    if (!frMap.has(num)) {
      console.error(`MISSING FR: ${pair.en}/${info.file} has no French equivalent (quest ${num})`);
      errors++;
    }
  }

  // Check frontmatter key parity for matched pairs
  for (const [num, frInfo] of frMap) {
    const enInfo = enMap.get(num);
    if (!enInfo) continue;

    const frKeys = new Set(frInfo.keys);
    const enKeys = new Set(enInfo.keys);
    const requiredKeys = ["layout", "lang", "title", "arc", "quest_number", "permalink"];

    for (const key of requiredKeys) {
      if (frKeys.has(key) && !enKeys.has(key)) {
        console.error(`KEY MISMATCH: quest ${num} - "${key}" in FR but missing in EN`);
        errors++;
      }
      if (enKeys.has(key) && !frKeys.has(key)) {
        console.error(`KEY MISMATCH: quest ${num} - "${key}" in EN but missing in FR`);
        errors++;
      }
    }
  }
}

if (errors > 0) {
  console.error(`\ni18n parity: ${errors} issue(s) found`);
  process.exit(1);
} else {
  console.log(`i18n parity: all ${PAIRS.map(p => getSlugMap(path.join(SRC, p.fr)).size).reduce((a, b) => a + b, 0)} pairs matched`);
}
