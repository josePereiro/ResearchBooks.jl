## ------------------------------------------------------------------
function references()
    doc = currdoc()
    doi = getdoi(doc)
    refs = _crossref_references(doi)
    return RBRefs(doc, refs)
end


## ------------------------------------------------------------------
# Accessors
references(r::RBRefs) = r.refs
dockey(r::RBRefs) = dockey(r.doc)

function _do_to_refs(f::Function, r::RBRefs, idx)
    ref = references(r)[idx]
    return (ref isa Vector) ? f.(ref) : f(ref)
end

getdoi(r::RBRefs, idx) = _do_to_refs(_crossref_entry_doi, r, idx)
getyear(r::RBRefs, idx) = _do_to_refs(_crossref_entry_year, r, idx)
getauthor(r::RBRefs, idx) = _do_to_refs(_crossref_entry_author, r, idx)

## ------------------------------------------------------------------
# Base
Base.length(r::RBRefs) = length(references(r))
Base.getindex(r::RBRefs, idx) = getindex(references(r), idx)
Base.lastindex(r::RBRefs) = lastindex(references(r))
Base.firstindex(r::RBRefs) = firstindex(references(r))
Base.iterate(r::RBRefs) = iterate(references(r))
Base.iterate(r::RBRefs, state) = iterate(references(r), state)

## ------------------------------------------------------------------
# show
function Base.show(io::IO, r::RBRefs)
    println(io, "RBRefs with ", length(r), " reference(s)")
    println(io, "dockey: \"", dockey(r), "\"")
end

## ------------------------------------------------------------------
function findall_refs()
    
end
