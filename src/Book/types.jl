## ------------------------------------------------------------------
# Items
abstract type RBItem end

mutable struct RBNote <: RBItem
    sec
    txt::String
end

mutable struct RBPair{T} <: RBItem
    sec
    key::String
    val::T
end

mutable struct RBQuote <: RBItem
    sec
    txt::String
end

mutable struct RBTagLine <: RBItem
    sec
    tags::Vector{String}
end

## ------------------------------------------------------------------
# References

# A generalize reference object
struct RBRef

    bibkey::String
    author::String
    year::String
    title::String
    doi::String

    dict::AbstractDict 
end
struct RBRefs
    refs::Vector{RBRef}
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

