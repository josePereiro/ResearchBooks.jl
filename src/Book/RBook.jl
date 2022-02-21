## ------------------------------------------------------------------
# Book

## ------------------------------------------------------------------
# Meta
get_parent(b::RBook) = b
get_book(b::RBook) = b

bookdir(b::RBook) = getproperty!(b, :bookdir, "")
bookdir!(b::RBook, path::String) = setproperty!(b, :bookdir, realpath(path))

## ------------------------------------------------------------------
# Data
tagmetas(b::RBook) = getproperty!(() -> OrderedDict{String, RBTagMeta}(), b, :tagset)
objlabels(b::RBook) = getproperty!(() -> Set{String}(), b, :objlabels)
documents(b::RBook) = getproperty!(() -> OrderedDict{String, RBDoc}(), b, :docs)
hasdoc(d::RBook, label::String) = haskey(documents(d), label)

## ------------------------------------------------------------------
# OrderedDict
Base.empty!(b::RBook) = empty!(documents(b))
Base.length(b::RBook) = length(documents(b))
Base.getindex(b::RBook, key::String) = getindex(documents(b), key)
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
    print(io, "RBook with ", ndocs, " document(s)")

    # meta
    for meta in [:bookdir]
        str = getproperty(b, meta, "")
        if !isempty(str) 
            print(io, "\n - ", meta, ": \"", _preview(io, str), "\"")
        end
    end

    # data
    if ndocs > 0
        print(io, "\ndocument(s):")
        _show_data_preview(io, b) do doc
            string("[", get_label(doc), "] ", get_title(doc))
        end
    end
    print(io, "\n", _preview(io, "-"^70))
    return nothing
end

## ------------------------------------------------------------------
# API
function eachdoc(book::RBook)
    values(documents(book))
end

function eachtagmeta(book::RBook)
    values(tagmetas(book))
end

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

# This should be the only method to add nre documents
# It updates all sort of stuff
function add_doc!(book::RBook, doc::RBDoc)
    
    doclabel = get_label(doc)
    
    # Update stuff
    # obj labels
    add_objlabel!(book, doclabel)
    
    # add doc
    docs = documents(book)
    push!(docs, doclabel => doc)
    
    return book
end

# check label validity and added to the book registry
function add_objlabel!(book::RBook, label::String)
    label = strip(label)
    isempty(label) && error("Empty label!")
    
    # TODO: check label already exist 
    # (maybe using srcfile to handle valid overwritting)
    # (maybe in an independent function)
    labels = objlabels(book)
    # if label ∈ labels
    #     obj = book[label]
    #     file = srcfile()
    # end

    push!(labels, label)

    return label
end

add_objlabel!(obj::RBObject, label::String) = add_objlabel!(get_book(obj), label)
add_objlabel!(obj::RBObject) = add_objlabel!(get_book(obj), get_label(obj))

function add_tagmeta!(book::RBook, tagmeta::RBTagMeta)
    
    label = get_label(tagmeta)
    
    # Update stuff
    # obj labels
    add_objlabel!(book, label)
    
    # add doc
    metas = tagmetas(book)
    push!(metas, label => tagmeta)
    
    return book
end