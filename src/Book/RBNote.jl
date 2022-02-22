
## ------------------------------------------------------------------
# Meta

get_sec(q::RBNote) = get_parent(q)
set_sec!(q::RBNote, sec::RBSection) = set_parent!(q, sec)

## ------------------------------------------------------------------
# Data

get_text(q::RBNote) = getproperty!(q, :text, "")
set_text!(q::RBNote, text::String) = setproperty!(q, :text, strip(text))

## ------------------------------------------------------------------
# show
function Base.show(io::IO, p::RBNote)
    print(io, "RBNote(\"", get_label(p), "\")")
    print(io, "\n - path: '", localrelpath(p), "'")
    text = get_text(p)
    !isempty(text) && print(io, "\n - text: \"", _preview(io, text), "\"")
    tags = join(get_tags(p), ", ")
    !isempty(tags) && print(io, "\n - tags: \"", _preview(io, tags), "\"")
    print(io, "\n", _preview(io, "-"^70))
end
