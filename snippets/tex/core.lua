local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

return {
    -- \begin{} \end{}
    s({ trig = "begi", snippetType = "autosnippet" }, fmta(
        [[
        \begin{<>}
          <>
        \end{<>}
        ]],
        {
            i(1),
            i(2),
            rep(1),
        }
    )),

    -- inline mode math
    s({ trig = "mk", snippetType = "autosnippet" }, fmta(
        "$<>$ ",
        { i(1) }
    )),

    -- display mode math
    s({ trig = "dm", snippetType = "autosnippet" }, fmta(
        [[
        \[
          <>
        \]
        ]],
        { i(1) }
    )),

    -- usepackage
    s({ trig = "usep", snippetType = "autosnippet" }, fmta(
        "\\usepackage{<>}",
        { i(1) }
    )),

    -- integrals
    s({ trig = "int", snippetType = "autosnippet" }, fmta(
        "\\int_{<>}^{<>}",
        { i(1), i(2) }
    )),

    -- subscript
    s({ trig = "([a-zA-Z])_", regTrig = true, wordTrig = false, snippetType = "autosnippet" }, fmta(
        "<>_{<>}",
        { f(function(_, snip) return snip.captures[1] end), i(1) }
    )),

    -- superscript
    s({ trig = "([a-zA-Z])^", regTrig = true, wordTrig = false, snippetType = "autosnippet" }, fmta(
        "<>^{<>}",
        { f(function(_, snip) return snip.captures[1] end), i(1) }
    )),

    -- fraction
    s({ trig = "//", regTrig = true, snippetType = "autosnippet" }, fmta(
        "\\frac{<>}{<>}",
        { i(1), i(2) }
    )),
    s({ trig = "([a-zA-Z%d_%^-%+%*%%{}%(%)]+)/", regTrig = true, snippetType = "autosnippet" }, fmta(
        "\\frac{<>}{<>}",
        { f(function(_, snip) return snip.captures[1] end), i(1) }
    )),
}
