## ------------------------------------------------------------------
# Book

# The top book has no label
RBook() = RBook("")

## ------------------------------------------------------------------
# Meta
get_parent(b::RBook) = b
get_book(b::RBook) = b

bookdir(b::RBook) = get_meta!(b, :bookdir, "")
bookdir!(b::RBook, path::String) = set_meta!(b, :bookdir, realpath(path))

## ------------------------------------------------------------------
# Data
documents(b::RBook) = get_data!(() -> OrderedDict{String, RBDoc}(), b, :docs)
hasobj(d::RBook, label::String) = haskey(documents(d), label)

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
Base.iterate(b::RBook) = iterate(_values(documents(b)))
Base.iterate(b::RBook, state) = iterate(_values(documents(b)), state)

## ------------------------------------------------------------------
# Show
function Base.show(io::IO, b::RBook)
    ndocs = length(b)
    println(io, _preview(io, "-"^70))
    println(io, "RBook with ", ndocs, " document(s)")

    # meta
    for meta in [:bookdir]
        str = get_meta(b, meta, "")
        if !isempty(str) 
            println(io, meta, ": \"", _preview(io, str), "\"")
        end
    end

    # data
    if ndocs > 0
        print(io, "docs:")
        _show_data_preview(io, b) do doc
            string("[", get_label(doc), "] ", get_title(doc))
        end
    end
    return nothing
end

## ------------------------------------------------------------------
function eachobj(book::RBook)
    ch = Channel{RBObject}(1) do ch_
        for doc in book
            put!(ch_, doc)
            for sec in doc
                put!(ch_, sec)
                for obj in sec
                    put!(ch_, obj)
                end
            end
        end
    end

    return (obj for obj in ch)
end
