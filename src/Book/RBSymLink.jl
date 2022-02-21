
## ------------------------------------------------------------------
# Meta

get_sec(l::RBSymLink) = get_parent(l)
set_sec!(l::RBSymLink, sec::RBSection) = set_parent!(l, sec)

## ------------------------------------------------------------------
# Data

get_text(l::RBSymLink) = getproperty!(l, :text, "")
set_text!(l::RBSymLink, text::String) = setproperty!(l, :text, strip(text))

## ------------------------------------------------------------------
# show
function Base.show(io::IO, p::RBSymLink)
    print(io, "RBSymLink(\"", get_label(p), "\")")
    print(io, "\n - path: '", localrelpath(p), "'")
    text = get_text(p)
    !isempty(text) && print(io, "\n - text: \"", _preview(io, text), "\"")
    tags = join(get_tags(p), ", ")
    !isempty(tags) && print(io, "\n - tags: \"", _preview(io, tags), "\"")
    print(io, "\n", _preview(io, "-"^70))
end
