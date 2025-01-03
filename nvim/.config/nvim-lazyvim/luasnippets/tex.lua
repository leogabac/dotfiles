
local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

luasnip.add_snippets("all", {
  s("needcite", {t("\\textbf{[CITE]}")}),
  s("needfig", {
    t({"\\vspace{1em} INCLUDE FIGURE OF"}),
    i(0),
    t({"\\vspace{1em}"}),
  }),
})

