## ------------------------------------------------------------------
# References

struct RBRefs
    refs::Vector{RBRef}
end

## ------------------------------------------------------------------
# Accessors
references(r::RBRefs) = r.refs

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
end
