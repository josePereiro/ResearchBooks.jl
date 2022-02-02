abstract type RBItem end
mutable struct RBSection
    doc
    key::String
    body::Vector{RBItem}
end

mutable struct RBDoc
    book
    key::String
    secs::Vector{RBSection}
end

mutable struct RBook
    dir::String
    docs::Vector{RBDoc}
end

## ------------------------------------------------------------------
RBook() = RBook("", RBDoc[])
documents(b::RBook) = b.docs
sections(d::RBDoc) = d.secs
body(s::RBSection) = s.body

## ------------------------------------------------------------------
# base
Base.push!(b::RBook, d::RBDoc, ds::RBDoc...) = push!(documents(b), d, ds...)
Base.push!(d::RBDoc, s::RBSection, ss::RBSection...) = push!(sections(d), s, ss...)
Base.push!(s::RBSection, e::RBItem, es::RBItem...) = push!(body(s), e, es...)

Base.length(b::RBook) = length(documents(b))
Base.length(d::RBDoc) = length(sections(d))
Base.length(s::RBSection) = length(body(s))