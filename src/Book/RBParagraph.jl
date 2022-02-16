
## ------------------------------------------------------------------
# Meta

get_sec!(q::RBParagraph) = get_parent(q)
set_sec!(q::RBParagraph, sec::RBSection) = set_parent!(q, sec)

## ------------------------------------------------------------------
# Data

get_text(q::RBParagraph) = getproperty!(q, :txt, "")
set_text!(q::RBParagraph, txt::String) = setproperty!(q, :txt, txt)

## ------------------------------------------------------------------
# show
function Base.show(io::IO, p::RBParagraph)
    print(io, "RBParagraph(\"", get_label(p), "\")")
    print(io, "\n - path: '", get_relpath(p), "'")
    txt = get_text(p)
    !isempty(txt) && print(io, "\n - txt: \"", _preview(io, txt), "\"")
    tags = join(get_tags(p), ", ")
    !isempty(tags) && print(io, "\n - tags: \"", _preview(io, tags), "\"")
    print(io, "\n", _preview(io, "-"^70))
end
