## ------------------------------------------------------------------
# Book
RBook(bookdir::String = "") = RBook(bookdir, OrderedDict{String, RBDoc}())

## ------------------------------------------------------------------
# Accessors
parent(b::RBook) = b
bookdir(b::RBook) = b.dir
bookdir() = bookdir(currbook())
documents(b::RBook) = b.docs
clearbook!(b::RBook) = empty!(b)
clearbook!() = empty!(currbook())

## ------------------------------------------------------------------
# OrderedDict
Base.empty!(b::RBook) = empty!(documents(b))
Base.length(b::RBook) = length(documents(b))
Base.push!(b::RBook, d::Pair, ds::Pair...) = push!(documents(b), d, ds...)
Base.haskey(b::RBook, key) = haskey(documents(b), key)
Base.getindex(b::RBook, key::String) = getindex(documents(b), key)
Base.setindex!(b::RBook, value::RBDoc, key::String) = setindex!(documents(b), value, key)
Base.keys(b::RBook) = keys(documents(b))
Base.get(b::RBook, key::String, default) = get(documents(b), key, default)
Base.get!(b::RBook, key::String, default) = get!(documents(b), key, default)

## ------------------------------------------------------------------
# Array
Base.getindex(b::RBook, idx) = (docs = documents(b); getindex(_values(docs), idx))
Base.lastindex(b::RBook) = lastindex(_values(documents(b)))
Base.firstindex(b::RBook) = firstindex(_values(documents(b)))
Base.iterate(b::RBook) = iterate(documents(b))
Base.iterate(b::RBook, state) = iterate(documents(b), state)

## ------------------------------------------------------------------
# Show
function Base.show(io::IO, b::RBook)
    println(io, "RBook with ", length(b), " document(s)")
    println(io, "dir: ", bookdir(b))
    print(io, "docs:")
    for (i, key) in enumerate(keys(b))
        print(io, "\n   \"", key, "\"")
        if i == _SHOW_LIMIT
            print(io, "\n...")
        end
    end
    return nothing
end