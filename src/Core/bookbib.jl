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

function _bookbib_to_rbref(ref::AbstractDict)
    bibkey = get(ref, "bibkey", "")
    author = get(ref, "author", "")
    year = get(ref, "year", "")
    title = get(ref, "title", "")
    doi = _doi_to_url(get(ref, "doi", ""))
    return RBRef(bibkey, author, year, title, doi, ref)
end

const _BOOKBIB = Dict{String, Any}()
const _BOOKBIB_MTIME_EVENT = FileMTimeEvent()
function bookbib(bookdir::String)
    
    # Update or load
    tomlfile = bookbib_file(bookdir)
    need_update = has_event!(_BOOKBIB_MTIME_EVENT, tomlfile)
    if need_update
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

    # return RBRefs
    refs = _bookbib_to_rbref.(values(_BOOKBIB))
    return RBRefs(refs)
end

## ----------------------------------------------------------------------------
# find

function findall_bookbib(bookdir::String, qp, qps...) 
    vec = references(bookbib(bookdir))
    findall_match(vec, qp, qps...)
end


function findfirst_bookbib(bookdir::String, qp, qps...) 
    vec = references(bookbib(bookdir))
    findfirst_match(vec, qp, qps...)
end

function filter_bookbib(bookdir::String, qp, qps...) 
    vec = references(bookbib(bookdir))
    filter_match(vec, qp, qps...)
end

## ----------------------------------------------------------------------------
# Functional interface
findall_bookbib(qp, qps...) = findall_bookbib(bookdir(), qp, qps...)
findfirst_bookbib(qp, qps...) = findfirst_bookbib(bookdir(), qp, qps...)
filter_bookbib(qp, qps...) = filter_bookbib(bookdir(), qp, qps...)

