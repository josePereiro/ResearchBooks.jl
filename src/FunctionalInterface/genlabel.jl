## ------------------------------------------------------------------
genlabel(prefix::String, n::Int = 8) = string(prefix, randstring(n))
genlabel(n::Int = 8) = randstring(n)

macro genlabel!()
    
    macroreg = _macro_call_regex("genlabel!")
    label = genlabel()
    rep = string("\"", genlabel(), "\"")
    _replace_line(__source__, macroreg, rep)
    return :($label)
end
