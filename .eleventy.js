// SPDX-License-Identifier: MIT
const htmlmin = require("html-minifier-terser");

const isProd = process.env.NODE_ENV === "production";

module.exports = function(eleventyConfig) {
  eleventyConfig.addPassthroughCopy("src/assets");
  eleventyConfig.addPassthroughCopy("src/CNAME");

  if (isProd) {
    eleventyConfig.addTransform("htmlmin", async function(content) {
      if ((this.page.outputPath || "").endsWith(".html")) {
        return await htmlmin.minify(content, {
          collapseWhitespace: true,
          conservativeCollapse: true,
          removeComments: true,
          minifyCSS: true,
          minifyJS: true,
          ignoreCustomFragments: [/<%[\s\S]*?%>/, /<pre[\s\S]*?<\/pre>/]
        });
      }
      return content;
    });
  }

  return {
    dir: {
      input: "src",
      output: "_site",
      includes: "_includes",
      data: "_data"
    },
    templateFormats: ["njk", "md", "html"],
    markdownTemplateEngine: "njk",
    htmlTemplateEngine: "njk"
  };
};
