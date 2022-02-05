## ------------------------------------------------------------------
# Items

abstract type RBItem end

mutable struct RBQuote <: RBItem
    sec
    txt::String
end

mutable struct RBNote <: RBItem
    sec
    txt::String
end

mutable struct RBPair{T} <: RBItem
    sec
    key::String
    val::T
end

mutable struct RBTag <: RBItem
    sec
    tag::String
end

## ------------------------------------------------------------------
# Section

struct RBSection
    doc
    key::String
    items::Vector{RBItem}
end

## ------------------------------------------------------------------
# Doc
struct RBDoc
    book
    key::String
    secs::OrderedDict{String, RBSection}
end

## ------------------------------------------------------------------
# Book
struct RBook
    dir::String
    docs::OrderedDict{String, RBDoc}
end

## ------------------------------------------------------------------
# Constructors

RBook(bookdir::String = "") = RBook(bookdir, OrderedDict{String, RBDoc}())
RBDoc(book::RBook, key::String) = RBDoc(book, key, OrderedDict{String, RBSection}())
RBSection(doc::RBDoc, key::String) = RBSection(doc, key, RBItem[])

## ------------------------------------------------------------------
# Accessors

parent(b::RBook) = b
parent(d::RBDoc) = d.book
parent(s::RBSection) = s.doc
parent(i::RBItem) = i.sec

bookdir(b::RBook) = b.dir
bookdir(d::RBDoc) = bookdir(parent(d))
bookdir(s::RBSection) = bookdir(parent(s))
bookdir(s::RBItem) = bookdir(parent(s))

documents(b::RBook) = b.docs
sections(d::RBDoc) = d.secs
items(s::RBSection) = s.items

dockey(d::RBDoc) = d.key
dockey(s::RBSection) = dockey(parent(s))
dockey(i::RBItem) = dockey(parent(i))

seckey(s::RBSection) = s.key

