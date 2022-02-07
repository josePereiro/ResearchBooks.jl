## ------------------------------------------------------------------
_crossref_meta_dir() = joinpath(depotdir(), ".crossref")

function _download_crossref_meta(doi; dir = pwd(), force = false)
    # name = string(_format_doi_for_filename(doi), ".json")
    name = string(_format_doi_for_filename(doi), ".json")
    outpath = joinpath(dir, name)
    force && rm(outpath; force)
    if !isfile(outpath)
        doi = _doi_to_url(doi)
        # TODO: Understand what is going on here!
        mkpath(dir)
        @info("Downloading", doi)
        # cmdstr = """curl -L -H "Accept: application/vnd.crossref.unixsd+json" "$(doi)" > "$(outpath)" """
        cmdstr = """curl -G "https://api.crossref.org/works/$(doi)" > "$(outpath)" """
        run(`bash -c $(cmdstr)`; wait = true)
        sleep(0.2) # Avoid loading the line
        @info("Done")
    end
    return outpath
end

## ------------------------------------------------------------------
function _crossref_references(doi::String)
    outdir = _crossref_meta_dir()
    jsonfile = _download_crossref_meta(doi; dir = outdir)
    try
        jsonstr = read(jsonfile, String)
        jsondict = JSON.parse(jsonstr)
        val = _find_key(jsondict, ["message", "reference"])
        return isnothing(val) ? [] : val
    catch err
        rm(jsonfile; force = true)
        rethrow(err)
    end
    return []
end


## ------------------------------------------------------------------
# Access
# Interface with crossref api json

# const _DOI_REGEX = Regex("\\d{1,10}\\.\\d{3,20}/[-._;()/:a-zA-Z0-9]+")
# function _crossref_entry_doi(ref::AbstractDict)
#     !haskey(ref, "DOI") && return ""
#     doistr = string(ref["DOI"])
#     m = match(_DOI_REGEX, doistr)
#     isnothing(m) ? "" : string(m.match)
# end

_crossref_entry_doi(ref::AbstractDict) = get(ref, "DOI", "")
_crossref_entry_author(ref::AbstractDict) = get(ref, "author", "")
_crossref_entry_year(ref::AbstractDict) = get(ref, "year", "")

function _crossref_entry_title(ref::AbstractDict) 
    hint = "-title"
    for key in keys(ref)
        key == "journal-title" && continue
        endswith(key, "-title") && return ref[key]
    end
    return ""
end

function _crossref_to_rbref(ref::AbstractDict)
    bibkey = ""
    author = _crossref_entry_author(ref)
    year = _crossref_entry_year(ref)
    title = _crossref_entry_title(ref)
    doi = _crossref_entry_doi(ref)
    return RBRef(bibkey, author, year, title, doi, ref)
end

## ------------------------------------------------------------------
function crossrefs()
    doc = currdoc()
    doi = getdoi(doc)
    ref_dicts = _crossref_references(doi)
    refs = RBRef[]
    for dict in ref_dicts
        push!(refs, _crossref_to_rbref(dict))
    end
    return RBRefs(refs)
end

## ------------------------------------------------------------------
# find

function findall_crossrefs(qp, qps...) 
    vec = references(crossrefs())
    findall_match(vec, qp, qps...)
end

function findfirst_crossrefs(qp, qps...) 
    vec = references(crossrefs())
    findfirst_match(vec, qp, qps...)
end

function filter_crossrefs(qp, qps...)
    vec = references(crossrefs())
    filter_match(vec, qp, qps...)
end
