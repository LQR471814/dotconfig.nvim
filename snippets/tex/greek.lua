local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node

local mapping = {
    a = "alpha",
    b = "beta",
    g = "gamma",
    o = "omega",
    t = "theta",
    l = "lambda",
    p = "phi",
    r = "rho",
    s = "sigma"
    d = "delta"
}
local result = {}

local i = 1
for key, value in pairs(mapping) do
    result[i] = s(
        {
            trig = ";" .. key,
            snippetType = "autosnippet"
        },
        {
            t("\\" .. value)
        }
    )
    i = i + 1
    result[i] = s(
        {
            trig = ";" .. string.upper(key),
            snippetType = "autosnippet"
        },
        {
            t("\\" .. string.upper(string.sub(value, 0, 1)) .. string.sub(value, 2))
        }
    )
    i = i + 1
end

return result
