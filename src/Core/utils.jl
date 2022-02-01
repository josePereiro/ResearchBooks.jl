function _doi_to_url(doi)
    if startswith(doi, "http")
        return doi 
    elseif startswith(doi, "doi.org")
        return string("https://", doi)
    elseif startswith(doi, "10.")
        return string("https://doi.org/", doi)
    else
        error("We don't like your DOI: '$(doi)'")
    end
end

function _format_doi_for_filename(doi)
    url = _doi_to_url(doi)
    replace(url, r"[^a-zA-Z0-9]" => "_")
end

# Search a multilayer Dict for a given key
function _find_key(dict::AbstractDict, key)
    for (ikey, val) in dict
        (ikey == key) && return val
        if (val isa AbstractDict)
            val = _find_key(val, key)
            !isnothing(val) && return val
        end
    end
    return nothing
end

# Search a multilayer Dict for a given set of keys
function _find_key(dict::AbstractDict, keys::Vector)
    for key in keys
        dict = _find_key(dict, key)
        isnothing(dict) && break
    end
    return dict
end

# case insensitive get
function _get_non_Aa(dict, skey, dfl)
    skey = lowercase(skey)
    for (dkey, val) in dict
        (skey == lowercase(dkey)) && return val
    end
    return dfl
end

# Retursn the newer file
function _newer(f1::String, f2::String)
    t1 = mtime(f1)
    t2 = mtime(f2)
    return t1 > t2 ? f1 : f2
end

