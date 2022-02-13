## ------------------------------------------------------------------
# Meta

getdoc(s::RBSection) = getmeta(s, :doc, nothing)
setdoc!(s::RBSection, doc::RBDoc) = setmeta!(s, :doc, doc)
setdoc!(s::RBSection) = setdoc!(s, currdoc())

getdoi(s::RBSection) = getmeta!(s, :doi, "")
setdoi!(s::RBSection, doi::String) = setmeta!(s, :doi, doi)

gettitle(s::RBSection) = getmeta!(s, :title, "")
settitle!(s::RBSection, title::String) = setmeta!(s, :title, title)

parent(s::RBSection) = getdoc(s)
bookdir(s::RBSection) = bookdir(getdoc(s))

## ------------------------------------------------------------------
# Data
items(s::RBSection) = getdata!(() -> OrderedDict{String, RBObject}(), s, :items)
hasobj(s::RBSection, label::String) = haskey(items(s), label)

## ------------------------------------------------------------------
# Array
Base.length(s::RBSection) = length(items(s))
Base.push!(s::RBSection, e::RBObject, es::RBObject...) = push!(items(s), e, es...)
Base.setindex!(s::RBSection, value::RBObject, idx::Int) = setindex!(items(s), value, idx)
Base.getindex(s::RBSection, idx) = getindex(items(s), idx)
Base.lastindex(s::RBSection) = lastindex(items(s))
Base.firstindex(s::RBSection) = firstindex(items(s))
Base.iterate(s::RBSection) = iterate(_value(items(s)))
Base.iterate(s::RBSection, state) = iterate(_value(items(s)), state)
Base.collect(s::RBSection) = collect(_value(items(s)))
Base.collect(T::Type, s::RBSection) = filter((i) -> i isa T, _value(items(s)))

## ------------------------------------------------------------------
# Show
function Base.show(io::IO, s::RBSection)
    nobjs = length(s)
    println(io, "RBSection with ", nobjs, " object(s)")
    
    # meta
    for meta in [:label, :title]
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
seclink(sec::RBSection) = string(dockey(sec), "::", seckey(sec))
seclink() = seclink(currsec())
seclink(i::Int) = seclink(currdoc()[i])
seclink(key::String) = seclink(currdoc()[key])

## ------------------------------------------------------------------
function add_section!(doc::RBDoc, key::String)
    key = format_idkey(key)
    sec = RBSection(doc, key)
    doc[key] = sec
    currsec!(sec)
end
add_section!(key::String) = add_section!(currdoc(), key)
new_section! = add_section!
