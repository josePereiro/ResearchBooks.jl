struct abstract RBItem end
mutable struct RBSection
    doc
    key::String
    body::Vector{RBItem}
end

mutable struct RBDoc
    book
    key::String
    path::String

    secs::Vector{}
end

mutable struct RBook
    dir::String
    docs::Vector{RBDoc}
end

RBook

