## ------------------------------------------------------------------
# Meta

getdoc(s::RBSection) = getparent(s)
setdoc!(s::RBSection, doc::RBDoc) = setparent!(s, doc)

getdoi(s::RBSection) = getmeta!(s, :doi, "")
setdoi!(s::RBSection, doi::String) = setmeta!(s, :doi, doi)

gettitle(s::RBSection) = getmeta!(s, :title, "")
settitle!(s::RBSection, title::String) = setmeta!(s, :title, title)

## ------------------------------------------------------------------
# Data
items(s::RBSection) = getdata!(() -> OrderedDict{String, RBObject}(), s, :items)
hasobj(s::RBSection, label::String) = haskey(items(s), label)

## ------------------------------------------------------------------
# Array
Base.length(s::RBSection) = length(items(s))
Base.push!(s::RBSection, o::Pair, os::Pair...) = push!(items(s), o, os...)
Base.setindex!(s::RBSection, value::RBObject, idx::Int) = setindex!(items(s), value, idx)
Base.getindex(s::RBSection, idx) = getindex(items(s), idx)
Base.lastindex(s::RBSection) = lastindex(items(s))
Base.firstindex(s::RBSection) = firstindex(items(s))
Base.iterate(s::RBSection) = iterate(_values(items(s)))
Base.iterate(s::RBSection, state) = iterate(_values(items(s)), state)
Base.collect(s::RBSection) = collect(_values(items(s)))
Base.collect(T::Type, s::RBSection) = filter((i) -> i isa T, _values(items(s)))

## ------------------------------------------------------------------
# Show
function Base.show(io::IO, s::RBSection)
    nobjs = length(s)
    println(io, "RBSection(\"", getlabel(s), "\") with ", nobjs, " object(s)")
    
    # meta
    for meta in [:title]
        str = getmeta(s, meta, "")
        if !isempty(str) 
            println(io, meta, ": \"", _preview(io, str), "\"")
        end
    end
    
    # data
    if nobjs > 0
        print(io, "object(s):")
        _show_data_preview(io, s) do obj
            getlabel(obj)
        end
    end
    return nothing
end


## ------------------------------------------------------------------
# Link Tools
# seclink(sec::RBSection) = string(dockey(sec), "::", seckey(sec))

## ------------------------------------------------------------------
# Functional Interface
setdoc!(s::RBSection) = setdoc!(s, currdoc())
seclink() = seclink(currsec())
seclink(i::Int) = seclink(currdoc()[i])
seclink(key::String) = seclink(currdoc()[key])
