#!/usr/bin/env node
/**
 * Basic accessibility checks on built HTML files:
 * - Images must have alt attributes
 * - Headings must not skip levels (h1 -> h3 without h2)
 * - Links must have discernible text
 * - Lang attribute must be present on <html>
 *
 * Lightweight alternative to pa11y (no browser needed).
 * Must run AFTER eleventy build.
 */

const fs = require("fs");
const path = require("path");

const SITE = path.resolve(__dirname, "../../_site");

if (!fs.existsSync(SITE)) {
  console.error("_site/ not found. Run 'npx eleventy' first.");
  process.exit(1);
}

let errors = 0;
let warnings = 0;
let filesChecked = 0;

function getAllHtmlFiles(dir) {
  const results = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...getAllHtmlFiles(full));
    } else if (entry.name.endsWith(".html")) {
      results.push(full);
    }
  }
  return results;
}

function checkFile(filePath) {
  const content = fs.readFileSync(filePath, "utf8");
  const rel = path.relative(SITE, filePath);
  const issues = [];

  // Check lang attribute on <html>
  if (content.includes("<html") && !/<html[^>]*\slang=/.test(content)) {
    issues.push({ level: "error", msg: "Missing lang attribute on <html>" });
  }

  // Check images have alt
  const imgRegex = /<img\b([^>]*)>/g;
  let match;
  while ((match = imgRegex.exec(content)) !== null) {
    if (!/\balt\s*=/.test(match[1])) {
      issues.push({ level: "error", msg: `<img> missing alt attribute` });
    }
  }

  // Check heading hierarchy
  const headingRegex = /<h([1-6])\b/g;
  let prevLevel = 0;
  while ((match = headingRegex.exec(content)) !== null) {
    const level = parseInt(match[1]);
    if (prevLevel > 0 && level > prevLevel + 1) {
      issues.push({ level: "warning", msg: `Heading skip: h${prevLevel} -> h${level}` });
    }
    prevLevel = level;
  }

  // Check empty links
  const linkRegex = /<a\b[^>]*>([\s]*)<\/a>/g;
  while ((match = linkRegex.exec(content)) !== null) {
    issues.push({ level: "error", msg: "Empty link (no text content)" });
  }

  for (const issue of issues) {
    const prefix = issue.level === "error" ? "ERROR" : "WARN";
    console.error(`${prefix}: ${rel} - ${issue.msg}`);
    if (issue.level === "error") errors++;
    else warnings++;
  }

  return issues.length;
}

const htmlFiles = getAllHtmlFiles(SITE);
for (const file of htmlFiles) {
  filesChecked++;
  checkFile(file);
}

console.log(`Accessibility: ${filesChecked} files checked, ${errors} error(s), ${warnings} warning(s)`);
if (errors > 0) process.exit(1);
