
## ------------------------------------------------------------------
# show
function Base.show(io::IO, p::RBPair)
    print(io, "RBPair: \"", p.key, "\" => \"", p.val, "\"")
end

## ------------------------------------------------------------------
function add_pair!(sec::RBSection, key::String, val)
    pair = RBPair(sec, key, val)
    push!(sec, pair)
end
add_pair!(key::String, val) = add_pair!(currsec(), key, val)

