## ------------------------------------------------------------------
# Meta

getbook(d::RBDoc) = getmeta(d, :book, nothing)
setbook!(d::RBDoc, book::RBook) = setmeta!(d, :book, book)
setbook!(d::RBDoc) = setbook!(d, currbook())

getdoi(d::RBDoc) = getmeta(d, :doi, "")
setdoi!(d::RBDoc, doi::String) = setmeta!(d, :doi, doi)

gettitle(d::RBDoc) = getmeta(d, :title, "")
settitle!(d::RBDoc, title::String) = setmeta!(d, :title, title)

parent(d::RBDoc) = getbook(d)
bookdir(d::RBDoc) = bookdir(getbook(d))

## ------------------------------------------------------------------
# Data

sections(d::RBDoc) = getdata!(() -> OrderedDict{String, RBSection}(), d, :secs)
hasobj(d::RBDoc, label::String) = haskey(sections(d), label)

## ------------------------------------------------------------------
# OrderedDict
Base.length(d::RBDoc) = length(sections(d))
Base.haskey(d::RBDoc, key) = haskey(sections(d), key)
Base.getindex(d::RBDoc, key::String) = getindex(sections(d), key)
Base.setindex!(d::RBDoc, value::RBSection, key::String) = setindex!(sections(d), value, key)
Base.push!(d::RBDoc, s::Pair, ss::Pair...) = push!(sections(d), s, ss...)
Base.keys(d::RBDoc) = keys(sections(d))
Base.get(d::RBDoc, key::String, default) = get(sections(d), key, default)
Base.get!(d::RBDoc, key::String, default) = get!(sections(d), key, default)

## ------------------------------------------------------------------
# Array
Base.getindex(d::RBDoc, idx) = (secs = sections(d); getindex(_values(secs), idx))
Base.lastindex(d::RBDoc) = lastindex(_values(sections(d)))
Base.firstindex(d::RBDoc) = firstindex(_values(sections(d)))
Base.iterate(d::RBDoc) = iterate(_values(sections(d)))
Base.iterate(d::RBDoc, state) = iterate(_values(sections(d)), state)

## ------------------------------------------------------------------
# show
function Base.show(io::IO, d::RBDoc)
    nsecs = length(d)
    println(io, "RBDoc with ", nsecs, " section(s)")
    
    # meta
    for meta in [:label, :title, :doi]
        str = getmeta(d, meta, "")
        if !isempty(str) 
            println(io, meta, ": \"", _preview(io, str), "\"")
        end
    end
    
    # data
    if nsecs > 0
        print(io, "section(s):")
        _show_data_preview(io, d) do sec
            string(getlabel(sec), ": ", gettitle(sec))
        end
    end
    return nothing
end

