## ------------------------------------------------------------------
macro __GENKEY!__()
    key = genid("ID_", 8)
    srcfile = string(__source__.file)
    callline = __source__.line

    macroreg = r"\@__GENKEY\!__(\(.*\))?"
    if isfile(srcfile)
        lines = readlines(srcfile)
        linestr = lines[callline]
        nocalls = count(macroreg, linestr)
        nocalls > 1 && error("More than one @__GENKEY!__ call at the same line $(callline): '$(linestr)'. You must split it.")
        lines[callline] = replace(linestr, macroreg => string("\"", key, "\""))
        open(srcfile, "w") do io
            for line in lines
                println(io, line)
            end
        end
    end

    return :($key)
end
