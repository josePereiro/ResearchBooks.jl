# Functional Interface
_read_reports_dirname() = "ReadReports"
_read_reports_dir() = joinpath(bookdir(), _read_reports_dirname())

_rr_dir(refid::String) = joinpath(_read_reports_dir(), refid)
_rr_srcfile(refid::String) = joinpath(_rr_dir(refid), "entry.rb.jl")

function _load_rrtfile()
    rrdir = _read_reports_dir()
    user_rrtfile = joinpath(rrdir, "TEMPLATE.jl")
    rrtfile = isfile(user_rrtfile) ? user_rrtfile : joinpath(@__DIR__, "DFLT_TEMPLATE.jl")
    read(rrtfile, String)
end

function _replace_ref(str, ref::Dict)
    for (key, val) in ref
        __KEY__ = string("__", uppercase(key), "__")
        str = replace(str, __KEY__ => _clear_bibtex_entry(val))
    end
    return str
end

function create_read_report(bibkey::String)
    isempty(bibkey) && error("bibkey is empty")
    ref = findfirst_bookbib(:bibkey => Regex("^$bibkey\$"))
    isnothing(ref) && 
        error(
            "ref '$(bibkey)' not found at any source bibs: ", bibtex_paths(bookdir())
        )

    rrdir = _rr_dir(bibkey)
    mkpath(rrdir)
    
    rrfile = _rr_srcfile(bibkey)
    isfile(rrfile) && error("File ('$(relpath(rrfile))') already exist. Overwritting is not allowed.")

    rrstr = _load_rrtfile()
    # custom
    rrstr = replace(rrstr, "__TODAY__" => Dates.format(now(), "dd/mm/YY"))
    # from ref
    rrstr = _replace_ref(rrstr, refdict(ref))

    # write
    write(rrfile, rrstr)
    
    return rrfile
end