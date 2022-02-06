## ----------------------------------------------------------------------------
# Sync and Load

const _BIB_PATHS_CONFIG_KEY = "bibs"

function bibtex_paths(bookdir)
    config = read_configfile(bookdir)
    bibs = get(config, _BIB_PATHS_CONFIG_KEY, "")
    return (bibs isa String) ? [bibs] : bibs
end

function _read_bibtex(path)
    str = read(path, String)
    _, dict = BibTeX.parse_bibtex(str)
    return dict
end

bookbib_file(bookdir) = joinpath(bookdir, "bookbib.toml")
clear_bookbib_file(bookdir) = rm(bookbib_file(bookdir); force = true)

const _BOOKBIB = Dict{String, Any}()
function load_bookbib(bookdir::String)

    # Check for update
    tomlfile = bookbib_file(bookdir)
    update = !isfile(tomlfile)
    for path in bibtex_paths(bookdir)
        !isfile(path) && continue
        update && continue
        update |= _newer(tomlfile, path) == path
    end

    # Update or load
    if update
        empty!(_BOOKBIB)
        for path in bibtex_paths(bookdir)
            dict = _read_bibtex(path)
            merge!(_BOOKBIB, dict)
        end
        open(tomlfile, "w") do io
            TOML.print(io, _BOOKBIB; sorted=false)
        end
    elseif isempty(_BOOKBIB)
        empty!(_BOOKBIB)
        merge!(_BOOKBIB, TOML.parsefile(tomlfile))
    end
    return _BOOKBIB
end
load_bookbib(bookdir, dockey) = get(load_bookbib(bookdir), dockey, "")

load_bookbib() = load_bookbib(bookdir(currbook()))

## ----------------------------------------------------------------------------
# find
_match(rstr::String, str::String) = match(Regex(rstr), str)
_match(r, str) = match(r, str)

function has_match(dict::Dict, qp::Pair)
    rkey, reg = qp
    rkey = string(rkey)
    !haskey(dict, rkey) && return false
    dval = dict[rkey]
    m = _match(reg, dval)
    !isnothing(m)
end

function has_match(dict::Dict, qps::Vector)
    for qp in qps
        ismatch = has_match(dict, qp)
        !ismatch && return false
    end
    return true
end

function foreach_bibs(f::Function, bookdir)
    bibs = load_bookbib(bookdir)
    for (dockey, bib) in bibs 
        retflag = f(dockey, bib)
        (retflag === true) && return nothing 
    end
    return nothing
end

function findall_bibs(bookdir::String, qp, qps...)
    found = String[]
    foreach_bibs(bookdir) do dockey, bib
        match_flag = has_match(bib, qp)
        for qpi in qps
            match_flag |= has_match(bib, qpi)
        end
        match_flag && push!(found, dockey)
    end
    found
end
function findall_bibs(qp, qps...)
    book = currbook()
    bdir = bookdir(book)
    findall_bibs(bdir, qp, qps...)
end

function findfirst_bibs(bookdir::String, qp, qps...)
    foreach_bibs(bookdir) do dockey, bib
        match_flag = has_match(bib, qp)
        for qpi in qps
            match_flag |= has_match(bib, qpi)
        end
        match_flag && return dockey
    end
    return ""
end
function findfirst_bibs(qp, qps...)
    book = currbook()
    bdir = bookdir(book)
    findfirst_bibs(bdir, qp, qps...)
end
