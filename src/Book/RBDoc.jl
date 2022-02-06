## ------------------------------------------------------------------
# Doc
RBDoc(book::RBook, key::String) = RBDoc(book, key, OrderedDict{String, RBSection}())

## ------------------------------------------------------------------
# Accessors
parent(d::RBDoc) = d.book
bookdir(d::RBDoc) = bookdir(parent(d))
sections(d::RBDoc) = d.secs
dockey(d::RBDoc) = d.key

const _DOI_META_KEY = "doi"
function getdoi(d::RBDoc)
    meta = get(d, _META_SECTION_KEY, nothing)
    isnothing(meta) && return ""
    pairs = collect(RBPair, meta)
    for (k, v) in pairs
        (k != _DOI_META_KEY) && continue
        return _doi_to_url(v)
    end
    return ""
end
getdoi() = getdoi(currdoc())

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
Base.iterate(d::RBDoc) = iterate(sections(d))
Base.iterate(d::RBDoc, state) = iterate(sections(d), state)

## ------------------------------------------------------------------
# show
function Base.show(io::IO, d::RBDoc)
    println(io, "RBDoc with ", length(d), " section(s)")
    println(io, "bookdir: ", bookdir(d))
    println(io, "dockey: \"", dockey(d), "\"")
    print(io, "secs:")
    for (i, key) in enumerate(keys(d))
        print(io, "\n   \"", key, "\"")
        if i == _SHOW_LIMIT
            print(io, "\n...")
        end
    end
    return nothing
end

## ------------------------------------------------------------------
const _META_SECTION_KEY = "Meta"
function new_document!(dockey::String; kwargs...)
    
    # book
    book = currbook()
    isnothing(book) && error("No Book selected. See `openbook`.")
    
    # Add doc
    dockey = format_idkey(dockey)
    doc = RBDoc(book, dockey)
    book[dockey] = doc
    currdoc!(doc)
    
    # Add Meta section
    sec = add_section!(doc, _META_SECTION_KEY)
    for (key, value) in kwargs
        add_pair!(sec, string(key), value)
    end

    return doc
end

# Use a kwargs as input for the dockey
function new_document!(dockey::Symbol; kwargs...)
    !haskey(kwargs, dockey) && error("refkey ':$(dockey)' missing!")
    dockey = string(kwargs[dockey])
    new_document!(dockey::String; kwargs...)
end
