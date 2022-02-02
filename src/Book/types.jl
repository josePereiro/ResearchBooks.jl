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

RBook() = RBook("", RBDoc[])