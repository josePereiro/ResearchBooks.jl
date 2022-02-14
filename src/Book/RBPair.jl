## ------------------------------------------------------------------
# show
function Base.show(io::IO, p::RBPair)
    print(io, "RBPair: \"", p.key, "\" => \"", p.val, "\"")
end

## ------------------------------------------------------------------
Base.length(p::RBPair{T}) where T = 2
Base.iterate(p::RBPair{T}) where T  = (p.key, 1)
Base.iterate(p::RBPair{T}, state::Int) where T = (state == 1) ? (p.val::T, 2) : nothing