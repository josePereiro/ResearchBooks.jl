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

function _bookbib_to_rbref(refdict::AbstractDict)

    ref = RBRef()

    # add custom
    ref.bibkey = get(refdict, "bibkey", "")
    ref.author = get(refdict, "author", "")
    ref.year = get(refdict, "year", "")
    ref.title = get(refdict, "title", "")
    ref.doi = _doi_to_url(get(refdict, "doi", ""))
    ref.dict = refdict
    
    return ref
end

function _format_BOOKBIB!()

    # clear content
    for (bibkey, dict) in _BOOKBIB

        # doi
        if haskey(dict, "doi")
            doistr = _doi_to_url(dict["doi"])
            !isempty(doistr) && (dict["doi"] = doistr)
        end

        # add bibkeys into dicts
        dict["bibkey"] = bibkey

        for (key, val) in dict
            dict[key] = _clear_bibtex_entry(val)
        end
    end
end

const _BOOKBIB = Dict{String, Any}()
const _BOOKBIB_MTIME_EVENT = FileMTimeEvent()
function bookbib(bookdir::String)
    
    # Check if need update
    tomlfile = bookbib_file(bookdir)
    is_unsync = false
    for path in bibtex_paths(bookdir)
        is_unsync |= has_event!(_BOOKBIB_MTIME_EVENT, path)
    end
    is_unsync |= has_event!(_BOOKBIB_MTIME_EVENT, tomlfile)

    # Update or load
    if is_unsync || !isfile(tomlfile)
        # Sync from external bib files
        empty!(_BOOKBIB)
        for path in bibtex_paths(bookdir)
            dict = _read_bibtex(path)

            merge!(_BOOKBIB, dict)
        end
        _format_BOOKBIB!()
        open(tomlfile, "w") do io
            TOML.print(io, _BOOKBIB; sorted=false)
        end
    elseif isempty(_BOOKBIB)
        # Load from cache
        empty!(_BOOKBIB)
        merge!(_BOOKBIB, TOML.parsefile(tomlfile))
    end

    # reset listener of tomlfile
    update!(_BOOKBIB_MTIME_EVENT, tomlfile)

    # return RBRefList
    refs = _bookbib_to_rbref.(values(_BOOKBIB)) 
    return reflist(refs)
end

## ----------------------------------------------------------------------------
# find

function _findall_bookbib(bookdir::String, qp, qps...) 
    vec = references(bookbib(bookdir))
    findall_match(vec, qp, qps...)
end

function _findfirst_bookbib(bookdir::String, qp, qps...) 
    vec = references(bookbib(bookdir))
    ret = findfirst_match(vec, qp, qps...)
    isnothing(ret) ? ret : last(ret)
end

function _filter_bookbib(bookdir::String, qp, qps...) 
    vec = references(bookbib(bookdir))
    filter_match(vec, qp, qps...)
end

