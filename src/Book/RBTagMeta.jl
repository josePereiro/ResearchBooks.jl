## ------------------------------------------------------------------
# Meta

# TODO: Add check to the data being entered.
# e.g: A label can not be its own anthagonist

# TODO: Creates a tag recomendation system.


# RBTagMeta
get_similars(obj::RBTagMeta) = getproperty!(() -> Set{String}(), obj, :similar)
set_similars!(obj::RBTagMeta,  t::String, ts::String...) = (_push_csv!(empty!(get_similars(obj)), t, ts...); obj)

get_antagonists(obj::RBTagMeta) = getproperty!(() -> Set{String}(), obj, :antagonist)
set_antagonists!(obj::RBTagMeta,  t::String, ts::String...) = (_push_csv!(empty!(get_antagonists(obj)), t, ts...); obj)

get_description(t::RBTagMeta) = getproperty(t, :description, "")
set_description!(t::RBTagMeta, text::String) = setproperty!(t, :description, strip(text))

get_supertag(t::RBTagMeta) = getproperty(t, :supertag, nothing)
set_supertag!(t::RBTagMeta, tag::String) = setproperty!(t, :supertag, strip(tag))

get_book(d::RBTagMeta) = get_parent(d)
set_book!(d::RBTagMeta, book::RBook) = set_parent!(d, book)

## ------------------------------------------------------------------
# Show
function Base.show(io::IO, tm::RBTagMeta)
    println(io, "RBTagMeta(\"", get_label(tm), "\")")
    print(io, " - path: '", localrelpath(tm), "'")
    text = get_description(tm)
    !isempty(text) && print(io, "\n - description: \"", _preview(io, text), "\"")
    return nothing
end
