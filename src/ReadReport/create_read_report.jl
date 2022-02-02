const READ_REPORT_TEMPLATE = ["title", "year", "tags"]

function _load_rrtfile()
    rrdir = _read_reports_dir()
    user_rrtfile = joinpath(rrdir, "TEMPLATE.txt")
    rrtfile = isfile(user_rrtfile) ? user_rrtfile : joinpath(@__DIR__, "DFLT_TEMPLATE.txt")
    read(rrtfile, String)
end

const _CLEAR_BIBTEX_ENTRY_STRIP_SET = ['{', '}', '\n', ' ', ',', ';']

function _clear_bibtex_entry(str::String)
    str = strip(str, _CLEAR_BIBTEX_ENTRY_STRIP_SET)
    str = replace(str, "{" => "")
    str = replace(str, "}" => "")
    str = replace(str, "\\" => "")
    str = replace(str, "  " => " ")
    str = replace(str, " ," => ",")
    return str
end

function _replace_ref(str, ref::Dict)
    for (key, val) in ref
        __KEY__ = string("__", uppercase(key), "__")
        str = replace(str, __KEY__ => _clear_bibtex_entry(val))
    end
    return str
end

function create_read_report(refid::String)
    ref = get(load_bookbib(), refid, nothing)
    isnothing(ref) && 
        error("ref '$(refid)' not found at any source bibs: $(bibtex_paths())")

    rrdir = _rr_dir(refid)
    mkpath(rrdir)
    
    rrfile = _rr_srcfile(refid)
    isfile(rrfile) && error("Dir ('$(rrfile)') already exist. Overwritting is not allowed.")

    rrstr = _load_rrtfile()
    # custom
    rrstr = replace(rrstr, "__ID__" => refid)
    rrstr = replace(rrstr, "__TODAY__" => Dates.format(now(), "dd/mm/YY"))
    # from ref
    rrstr = _replace_ref(rrstr, ref)

    # write
    write(rrfile, rrstr)
    
    return read(rrfile, RBDoc)
end

# cli
function create_read_report(argsv::Vector)
    length(argsv) != 1 && error("Expected 1 argument, get $(length(argsv))")
    create_read_report(first(argsv))
end