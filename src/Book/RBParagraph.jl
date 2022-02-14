
## ------------------------------------------------------------------
# Meta

get_sec!(q::RBParagraph) = get_parent(q)
set_sec!(q::RBParagraph, sec::RBSection) = set_parent!(q, sec)

## ------------------------------------------------------------------
# Data

get_text(q::RBParagraph) = get_data!(q, :txt, "")
set_text!(q::RBParagraph, txt::String) = set_data!(q, :txt, txt)

## ------------------------------------------------------------------
# show
function Base.show(io::IO, q::RBParagraph)
    println(io, "RBParagraph(\"", get_label(q), "\")")
    print(io, "txt:\n\"", _preview(io, get_text(q)), "\"")
end
