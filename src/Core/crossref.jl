_crossref_meta_dir() = joinpath(book_dir(), ".research_book", ".crossref")

function _doi_references(doi::String)
    outdir = _crossref_meta_dir()
    xmlfile = _download_crossref_meta(doi; dir = outdir)
    xmlstr = read(xmlfile, String)
    xmldict = XMLDict.xml_dict(xmlstr)
    val = _find_key(xmldict, ["citation_list", "citation"])
    return isnothing(val) ? [] : val
end

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
        sleep(0.2) # Avoid over shoting
        @info("Done")
    end
    return outpath
end