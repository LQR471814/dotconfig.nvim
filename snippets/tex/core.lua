local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

return {
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
    s({ trig = "mk", snippetType = "autosnippet" }, fmta(
        "$<>$ ",
        { i(1) }
    )),
    s({ trig = "dm", snippetType = "autosnippet" }, fmta(
        [[
        \[
          <>
        \]
        ]],
        { i(1) }
    )),
    s({ trig = "usep", snippetType = "autosnippet" }, fmta(
        "\\usepackage{<>}",
        { i(1) }
    )),
    s({ trig = "int", snippetType = "autosnippet" }, fmta(
        "\\int_{<>}^{<>} ",
        { i(1), i(2) }
    ))
}
