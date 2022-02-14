## ------------------------------------------------------------------
# Meta

getdoc(s::RBSection) = get_parent(s)
setdoc!(s::RBSection, doc::RBDoc) = set_parent!(s, doc)

get_doi(s::RBSection) = get_meta!(s, :doi, "")
set_doi!(s::RBSection, doi::String) = set_meta!(s, :doi, doi)

get_title(s::RBSection) = get_meta!(s, :title, "")
set_title!(s::RBSection, title::String) = set_meta!(s, :title, title)

## ------------------------------------------------------------------
# Data
items(s::RBSection) = get_data!(() -> OrderedDict{String, RBObject}(), s, :items)
hasobj(s::RBSection, label::String) = haskey(items(s), label)

## ------------------------------------------------------------------
# Abstract Dict
Base.length(s::RBSection) = length(items(s))
Base.setindex!(s::RBSection, value::RBObject, label::String) = setindex!(items(s), value, label)
Base.getindex(s::RBSection, label::String) = getindex(items(s), label)
Base.collect(s::RBSection) = collect(_values(items(s)))
Base.collect(T::Type, s::RBSection) = filter((i) -> i isa T, _values(items(s)))

## ------------------------------------------------------------------
# Array
Base.push!(s::RBSection, o::Pair, os::Pair...) = push!(items(s), o, os...)
Base.getindex(s::RBSection, idx) = (objs = items(s); getindex(_values(objs), idx))
Base.lastindex(s::RBSection) = lastindex(items(s))
Base.firstindex(s::RBSection) = firstindex(items(s))
Base.iterate(s::RBSection) = iterate(_values(items(s)))
Base.iterate(s::RBSection, state) = iterate(_values(items(s)), state)

## ------------------------------------------------------------------
# Show
function Base.show(io::IO, s::RBSection)
    nobjs = length(s)
    println(io, "RBSection(\"", get_label(s), "\") with ", nobjs, " object(s)")
    
    # meta
    for meta in [:title]
        str = get_meta(s, meta, "")
        if !isempty(str) 
            println(io, meta, ": \"", _preview(io, str), "\"")
        end
    end
    
    # data
    if nobjs > 0
        print(io, "object(s):")
        _show_data_preview(io, s) do obj
            string("[", get_label(obj), "] ", typeof(obj))
        end
    end
    return nothing
end
