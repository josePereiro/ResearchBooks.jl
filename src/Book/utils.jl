const _SHOW_LIMIT = 20

_values(od::OrderedDict) = od.vals # This might be unstable

function format_idkey(key)
    reg = Regex("[^A-Za-z0-9]")
    key = replace(key, reg => "_")
    return key
end

function _preview(io::IO, str, hlim = displaysize(io)[2])
    hlim = max(40, floor(Int, hlim * 0.8))
    (length(str) <= hlim) ? str : string(SubString(str, 1, hlim), "...")
end

function _show_data_preview(f::Function, io::IO, col)
    vlim = max(20, displaysize(io)[1])
    for (i, dat) in enumerate(col)
        val = string(f(dat))
        str = _preview(io, val)
        print(io, "\n[", i, "] ", str)
        if i == vlim
            print(io, "\n[...]")
            break
        end
    end
end

function _push_csv!(col, str::String)
    vals = split(str, ",", keepempty = false)
    for vali in vals
        push!(col, strip(vali))
    end
    return col
end

function _push_csv!(col, str::String, strs::String...)
    _push_csv!(col, str)
    for stri in strs
        _push_csv!(col, stri)
    end
    return col
end