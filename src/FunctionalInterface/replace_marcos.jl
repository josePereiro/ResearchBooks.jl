## ------------------------------------------------------------------
function _macro_call_regex(name::String)
    str = string("(?>", 
        "\\@", name, "(?>", "\\([^\\(]*\\)", ")?", 
    ")")
    return Regex(str)
end

## ------------------------------------------------------------------
function _replace_line(file::String, line::Int, old, new)
    if isfile(file)
        lines = readlines(file)
        linestr = lines[line]
        nocalls = count(old, linestr)
        nocalls > 1 && error("More than one match for `$(old)`` at the same line $(line): '$(linestr)'.")
        nocalls == 0 && return
        lines[line] = replace(linestr, old => new)
        open(file, "w") do io
            for line in lines
                println(io, line)
            end
        end
    end
end

## ------------------------------------------------------------------
macro genlabel!()
    srcfile = string(__source__.file)
    callline = __source__.line
    
    macroreg = _macro_call_regex("genlabel!")
    label = genlabel()
    rep = string("\"", genlabel(), "\"")
    _replace_line(srcfile, callline, macroreg, rep)
    return :($label)
end
