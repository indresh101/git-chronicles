#!/usr/bin/env node
// Minify CSS and JS assets in _site using esbuild
const { buildSync } = require("esbuild");
const fs = require("fs");
const path = require("path");

const siteDir = path.join(__dirname, "../../_site");

function findFiles(dir, ext) {
  const results = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory() && entry.name !== "pagefind") {
      results.push(...findFiles(full, ext));
    } else if (entry.name.endsWith(ext)) {
      results.push(full);
    }
  }
  return results;
}

const cssFiles = findFiles(path.join(siteDir, "assets"), ".css");
const jsFiles = findFiles(path.join(siteDir, "assets"), ".js");

let savedBytes = 0;

for (const file of [...cssFiles, ...jsFiles]) {
  const before = fs.statSync(file).size;
  const loader = file.endsWith(".css") ? "css" : "js";
  const { outputFiles } = buildSync({
    entryPoints: [file],
    minify: true,
    write: false,
    bundle: false,
    loader: { [`.${loader}`]: loader },
    outfile: "out"
  });
  fs.writeFileSync(file, outputFiles[0].contents);
  const after = outputFiles[0].contents.length;
  savedBytes += before - after;
}

const totalFiles = cssFiles.length + jsFiles.length;
console.log(`Minified ${totalFiles} assets, saved ${(savedBytes / 1024).toFixed(1)} KB`);
