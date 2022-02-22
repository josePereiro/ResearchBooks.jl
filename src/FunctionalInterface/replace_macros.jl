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
    touch(file)
    return nothing
end

# ------------------------------------------
function _make_report(f::Function, file, srcli)
    
    lines = readlines(file)
    line = lines[srcli]

    # check line
    !contains(line, _macro_call_regex("report")) && error("macro call missing at ", line)

    # capture
    output = _capture_output(f)
    
    # write
    # TODO: handle or detect multiline expressions
    open(file, "w") do io
        # original
        for (li, line) in enumerate(lines)
            println(io, line)
            (li == srcli) && break
        end

        # output
        for line in split(output, "\n")
            println(io, "# ", line)
        end
    end

end

# ------------------------------------------
macro report(ex)
    file, line = srcfile(__source__), srcline(__source__)
    quote
        _make_report($(file), $(line)) do
            $(esc(ex))
        end
    end
end