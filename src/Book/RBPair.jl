## ------------------------------------------------------------------
# show
function Base.show(io::IO, p::RBPair)
    print(io, "RBPair: \"", p.key, "\" => \"", p.val, "\"")
end

## ------------------------------------------------------------------
# add
function add_pair!(sec::RBSection, key::String, val)
    pair = RBPair(sec, key, val)
    push!(sec, pair)
end
add_pair!(key::String, val) = add_pair!(currsec(), key, val)

## ------------------------------------------------------------------
Base.length(p::RBPair{T}) where T = 2
Base.iterate(p::RBPair{T}) where T  = (p.key, 1)
Base.iterate(p::RBPair{T}, state::Int) where T = (state == 1) ? (p.val::T, 2) : nothing