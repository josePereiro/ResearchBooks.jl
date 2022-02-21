## ------------------------------------------------------------------
# References

function reflist(refs::Vector{RBRef})
    ref = RBRefList()
    push!(ref, refs...)
    return ref
end

## ------------------------------------------------------------------
# Accessors
references(r::RBRefList) = getproperty!(() -> Vector{RBRef}(), r, :refs)

## ------------------------------------------------------------------
# Meta

get_sec(q::RBRefList) = get_parent(q)
set_sec!(q::RBRefList, sec::RBSection) = set_parent!(q, sec)

## ------------------------------------------------------------------
# Base
Base.length(r::RBRefList) = length(references(r))
Base.getindex(r::RBRefList, idx) = getindex(references(r), idx)
Base.lastindex(r::RBRefList) = lastindex(references(r))
Base.firstindex(r::RBRefList) = firstindex(references(r))
Base.iterate(r::RBRefList) = iterate(references(r))
Base.iterate(r::RBRefList, state) = iterate(references(r), state)
Base.push!(r::RBRefList, ref::RBRef, refs::RBRef...) = push!(references(r), ref, refs...)

## ------------------------------------------------------------------
# show
function Base.show(io::IO, l::RBRefList)
    nrefs = length(l)
    println(io, "RBRefList(\"", get_label(l), "\") with ", nrefs, " reference(s)")
    # data
    if nrefs > 0
        print(io, "\nreference(s):")
        _show_data_preview(io, l) do ref
            # string("[", get_doi(ref), "] ", get_title(sec))
            string(ref)
        end
    end
    print(io, "\n", _preview(io, "-"^70))
end
