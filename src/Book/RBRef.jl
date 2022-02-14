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

## ------------------------------------------------------------------
# Accessors
get_data(r::RBRef) = r.dict
get_bibkey(r::RBRef) = r.bibkey
get_author(r::RBRef) = r.author
get_year(r::RBRef) = r.year
get_title(r::RBRef) = r.title
get_doi(r::RBRef) = r.doi

## ------------------------------------------------------------------
# Base
function Base.show(io::IO, r::RBRef)
    println(io, _preview(io, "-"^70))
    print(io, "RBRef")
    for f in [:bibkey, :author, :year, :title, :doi]
        val = getproperty(r, f)
        isempty(val) && continue
        print(io, "\n   ", f, ": \"", _preview(io, val), "\"")
    end
end

