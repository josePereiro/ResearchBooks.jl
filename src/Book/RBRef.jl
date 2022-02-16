## ------------------------------------------------------------------
# References

# A generalize reference object
# struct RBRef

#     bibkey::String
#     author::String
#     year::String
#     title::String
#     doi::String

#     dict::AbstractDict 
# end

## ------------------------------------------------------------------
# Accessors
refdict(r::RBRef) = getproperty(r, :dict, nothing)
get_bibkey(r::RBRef) = getproperty(r, :bibkey, "")
get_author(r::RBRef) = getproperty(r, :author, "")
get_year(r::RBRef) = getproperty(r, :year, "")
get_title(r::RBRef) = getproperty(r, :title, "")
get_doi(r::RBRef) = getproperty(r, :doi, "")

## ------------------------------------------------------------------
# Base
function Base.show(io::IO, r::RBRef)
    print(io, "RBRef")
    for meta in [:title, :bibkey, :author, :year, :doi]
        val = getproperty(r, meta)
        isempty(val) && continue
        print(io, "\n - ", meta, ": \"", _preview(io, val), "\"")
    end
    print(io, "\n", _preview(io, "-"^70))
end

