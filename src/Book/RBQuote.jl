## ------------------------------------------------------------------
# Meta

get_sec!(q::RBQuote) = get_parent(q)
set_sec!(q::RBQuote, sec::RBSection) = set_parent!(q, sec)

## ------------------------------------------------------------------
# Data

get_text(q::RBQuote) = get_data(q, :txt, "")
set_text!(q::RBQuote, txt::String) = set_data!(q, :txt, txt)

## ------------------------------------------------------------------
# show
function Base.show(io::IO, q::RBQuote)
    println(io, _preview(io, "-"^70))
    println(io, "RBQuote(\"", get_label(q), "\")")
    print(io, "path: '", get_relpath(q), "'")
    txt = get_text(q)
    !isempty(txt) && print(io, "\n   txt: \"", _preview(io, txt), "\"")
    tags = join(get_tags(q), ", ")
    !isempty(tags) && print(io, "\n   tags: \"", _preview(io, tags), "\"")
    return nothing
end
