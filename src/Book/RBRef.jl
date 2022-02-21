## ------------------------------------------------------------------
# References

## ------------------------------------------------------------------
# Meta

refdict(r::RBRef) = getproperty(r, :dict, nothing)
refdict!(r::RBRef, dict::AbstractDict) = setproperty!(r, :dict, dict)

get_bibkey(r::RBRef) = getproperty(r, :bibkey, "")
set_bibkey!(r::RBRef, key::String) = setproperty!(r, :bibkey, strip(key))

get_author(r::RBRef) = getproperty(r, :author, "")
set_author!(r::RBRef, author::String) = setproperty!(r, :author, strip(author))

get_year(r::RBRef) = getproperty(r, :year, "")
set_year!(r::RBRef, year::String) = setproperty!(r, :year, strip(year))

get_title(r::RBRef) = getproperty(r, :title, "")
set_title!(r::RBRef, title::String) = setproperty!(r, :title, strip(title))

get_doi(r::RBRef) = getproperty(r, :doi, "")
set_doi!(r::RBRef, doi::String) = setproperty!(r, :doi, _doi_to_url(doi))

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

