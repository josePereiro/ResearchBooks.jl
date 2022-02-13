## ------------------------------------------------------------------
# References

# A generalize reference object
struct RBRef

    bibkey::String
    author::String
    year::String
    title::String
    doi::String

    dict::AbstractDict 
end
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

function Base.show(io::IO, r::RBRef)
    print(io, "RBRef")
    for f in [:bibkey, :author, :year, :title, :doi]
        val = getproperty(r, f)
        isempty(val) && continue
        print(io, "\n   ", f, ": \"", val, "\"")
    end
end

## ------------------------------------------------------------------
function findall_refs(r::RBRefs, q, qs...)
    refs = references(r)

    found = Int[]
    for (i, dict) in enumerate(refs)
        str = string(dict)
        match_flag = has_match(str, q)
        for qi in qs
            match_flag |= has_match(str, qi)
        end
        match_flag && push!(found, i)
    end
    found

end

findall_refs(q, qs...) = findall_refs(references(), q, qs...)