## ------------------------------------------------------------------
Base.length(b::RBook) = length(documents(b))
Base.length(d::RBDoc) = length(sections(d))
Base.length(s::RBSection) = length(items(s))

Base.push!(b::RBook, d::Pair, ds::Pair...) = push!(documents(b), d, ds...)
Base.push!(d::RBDoc, s::Pair, ss::Pair...) = push!(sections(d), s, ss...)
Base.push!(s::RBSection, e::RBItem, es::RBItem...) = push!(items(s), e, es...)

## ------------------------------------------------------------------
# Dict
Base.haskey(b::RBook, key) = haskey(documents(b), key)
Base.haskey(d::RBDoc, key) = haskey(sections(d), key)

Base.getindex(b::RBook, key::String) = getindex(documents(b), key)
Base.getindex(d::RBDoc, key::String) = getindex(sections(d), key)

Base.setindex!(b::RBook, value::RBDoc, key::String) = setindex!(documents(b), value, key)
Base.setindex!(d::RBDoc, value::RBSection, key::String) = setindex!(sections(d), value, key)
Base.setindex!(s::RBSection, value::RBItem, idx::Int) = setindex!(items(s), value, idx)

Base.keys(b::RBook) = keys(documents(b))
Base.keys(d::RBDoc) = keys(sections(d))

## ------------------------------------------------------------------
# Array
_values(od::OrderedDict) = od.vals # This might be unstable
Base.getindex(b::RBook, idx) = (docs = documents(b); getindex(_values(docs), idx))
Base.getindex(d::RBDoc, idx) = (secs = sections(d); getindex(_values(secs), idx))
Base.getindex(s::RBSection, idx) = getindex(items(s), idx)

Base.lastindex(b::RBook) = lastindex(_values(documents(b)))
Base.lastindex(d::RBDoc) = lastindex(_values(sections(d)))
Base.lastindex(s::RBSection) = lastindex(items(s))

Base.firstindex(b::RBook) = firstindex(_values(documents(b)))
Base.firstindex(d::RBDoc) = firstindex(_values(sections(d)))
Base.firstindex(s::RBSection) = firstindex(items(s))

## ------------------------------------------------------------------
# show
const _SHOW_LIMIT = 20

function Base.show(io::IO, b::RBook)
    println(io, "RBook with ", length(b), " document(s)")
    println(io, "dir: ", bookdir(b))
    println(io, "docs:")
    for (i, key) in enumerate(keys(b))
        print(io, "\n   \"", key, "\"")
        if i == _SHOW_LIMIT
            print(io, "\n...")
        end
    end
    return nothing
end

function Base.show(io::IO, d::RBDoc)
    println(io, "RBDoc with ", length(d), " section(s)")
    println(io, "bookdir: ", bookdir(d))
    println(io, "dockey: \"", dockey(d), "\"")
    println(io, "secs:")
    for (i, key) in enumerate(keys(d))
        print(io, "\n   \"", key, "\"")
        if i == _SHOW_LIMIT
            print(io, "\n...")
        end
    end
    return nothing
end

function Base.show(io::IO, d::RBSection)
    println(io, "RBSection with ", length(d), " items(s)")
    println(io, "bookdir: ", bookdir(d))
    println(io, "dockey: \"", dockey(d), "\"")
    println(io, "seckey: \"", seckey(d), "\"")
    print(io, "items:")
    for item in items(d)
        print(io, "\n  ", item)
    end
end

function Base.show(io::IO, q::RBQuote)
    print(io, "RBQuote: \"", q.txt, "\"")
end

function Base.show(io::IO, n::RBNote)
    print(io, "RBNote: \"", n.txt , "\"")
end

function Base.show(io::IO, p::RBPair)
    print(io, "RBPair: \"", p.key, "\" => \"", p.val, "\"")
end