
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
function Base.show(io::IO, p::RBParagraph)
    println(io, _preview(io, "-"^70))
    println(io, "RBParagraph(\"", get_label(p), "\")")
    print(io, "path: '", get_relpath(p), "'")
    txt = get_text(p)
    !isempty(txt) && print(io, "\n   txt: \"", _preview(io, txt), "\"")
    tags = join(get_tags(p), ", ")
    !isempty(tags) && print(io, "\n   tags: \"", _preview(io, tags), "\"")
end
