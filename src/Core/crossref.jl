## ------------------------------------------------------------------
_crossref_meta_dir() = joinpath(depotdir(), ".crossref")

function _download_crossref_meta(doi; dir = pwd(), force = false)
    name = string(_format_doi_for_filename(doi), ".xml")
    outpath = joinpath(dir, name)
    force && rm(outpath; force)
    if !isfile(outpath)
        doi = _doi_to_url(doi)
        # TODO: Understand what is going on here!
        mkpath(dir)
        @info("Downloading", doi)
        cmdstr = """curl -L -H "Accept: application/vnd.crossref.unixsd+xml" "$(doi)" > "$(outpath)" """
        run(`bash -c $(cmdstr)`; wait = true)
        sleep(0.2) # Avoid loading the line
        @info("Done")
    end
    return outpath
end

## ------------------------------------------------------------------
function _crossref_references(doi::String)
    outdir = _crossref_meta_dir()
    xmlfile = _download_crossref_meta(doi; dir = outdir)
    try
        xmlstr = read(xmlfile, String)
        xmldict = XMLDict.xml_dict(xmlstr)
        val = _find_key(xmldict, ["citation_list", "citation"])
        return isnothing(val) ? [] : val
    catch err
        rm(xmlfile; force = true)
        rethrow(err)
    end
    return []
end


## ------------------------------------------------------------------
# Access
# The downloaded xml is unstable

const _DOI_REGEX = Regex("\\d{1,10}\\.\\d{3,20}/[-._;()/:a-zA-Z0-9]+")
function _crossref_entry_doi(ref::AbstractDict)
    !haskey(ref, "doi") && return ""
    doistr = string(ref["doi"])
    m = match(_DOI_REGEX, doistr)
    isnothing(m) ? "" : string(m.match)
end

function _crossref_to_rbref(ref::AbstractDict)
    bibkey = ""
    author = get(ref, "author", "")
    year = get(ref, "cYear", "")
    title = get(ref, "article_title", "")
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

