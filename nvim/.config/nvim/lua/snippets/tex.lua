local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt

return {
	-- ============================================
	-- simple text abbreviations
	-- ============================================
	s(";a", { t("\\alpha") }),
	s(";b", { t("\\beta") }),
	s(";g", { t("\\gamma") }),
	-- placeholder text for cites
	s("needcite", { t("\\textbf{[CITE]}") }),

	-- ============================================
	-- more involved wrappers, and inserts
	-- ============================================

	-- inline math mode
	s("mm", fmt(
			"$<>$",
			{ i(0) },
			{ delimiters = "<>" }
		)
	),

	-- dfrac
	s("dfrac", fmt(
			"\\dfrac{<>}{<>}",
			{ i(1), i(2) },
			{ delimiters = "<>" }
		)
	),
	-- integral
	s("int", fmt(
			"\\int_{<>}^{<>} <> \\textrm{d}<>",
			{ i(1), i(2), i(0), i(3) },
			{ delimiters = "<>" }
		)
	),

	-- generic environment
	s("env", fmt(
		[[
			\begin{<>}
				<>
			\end{<>}
		]],
		{ i(1), i(0), rep(1) },
		{ delimiters = "<>" }
		)
	),

	-- placeholder text for figures
	s("needfig", {
		t({ "\\vspace{1em} INCLUDE FIGURE OF" }),
		i(0),
		t({ "\\vspace{1em}" }),
	}),
}
