#!/usr/bin/env node
/**
 * Check that all internal href links in the built _site/ resolve
 * to actual files. Catches broken links before deployment.
 *
 * Must run AFTER eleventy build (_site/ must exist).
 */

const fs = require("fs");
const path = require("path");

const SITE = path.resolve(__dirname, "../../_site");

if (!fs.existsSync(SITE)) {
  console.error("_site/ not found. Run 'npx eleventy' first.");
  process.exit(1);
}

let errors = 0;
let linksChecked = 0;
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

function extractInternalLinks(content) {
  const links = [];
  const regex = /href="(\/[^"#?]*)/g;
  let match;
  while ((match = regex.exec(content)) !== null) {
    links.push(match[1]);
  }
  return links;
}

function linkResolves(href) {
  // /fr/quetes/01-la-guilde-des-archivistes/ -> _site/fr/quetes/01-.../index.html
  let target = path.join(SITE, href);

  // If it ends with /, look for index.html
  if (href.endsWith("/")) {
    target = path.join(target, "index.html");
  }

  // Check exact file or directory with index.html
  if (fs.existsSync(target)) return true;

  // Try adding .html
  if (fs.existsSync(target + ".html")) return true;

  // Try as directory with index.html
  if (fs.existsSync(path.join(target, "index.html"))) return true;

  return false;
}

const htmlFiles = getAllHtmlFiles(SITE);

for (const file of htmlFiles) {
  const content = fs.readFileSync(file, "utf8");
  const links = extractInternalLinks(content);
  const relFile = path.relative(SITE, file);
  filesChecked++;

  for (const href of links) {
    linksChecked++;
    if (!linkResolves(href)) {
      console.error(`BROKEN: ${relFile} -> ${href}`);
      errors++;
    }
  }
}

if (errors > 0) {
  console.error(`\nInternal links: ${errors} broken link(s) found (${linksChecked} checked in ${filesChecked} files)`);
  process.exit(1);
} else {
  console.log(`Internal links: ${linksChecked} links OK in ${filesChecked} files`);
}
