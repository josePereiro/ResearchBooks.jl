## ------------------------------------------------------------------
function _macro_call_regex(name::String)
    str = string("(?>", 
        "\\@", name, "(?>", "\\([^\\(]*\\)", ")?", 
    ")")
    return Regex(str)
end

## ------------------------------------------------------------------
function _replace_line(callinfo::LineNumberNode, old, new)
    file, line = srcfile(callinfo), srcline(callinfo)
    !isfile(file) && return
    lines = readlines(file)
    linestr = lines[line]
    nocalls = count(old, linestr)
    nocalls > 1 && error("More than one match for `$(old)` at the same line $(line): '$(linestr)'.")
    nocalls == 0 && return
    lines[line] = replace(linestr, old => new)
    open(file, "w") do io
        for line in lines
            println(io, line)
        end
    end
end