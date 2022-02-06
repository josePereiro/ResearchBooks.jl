## ------------------------------------------------------------------
_match(rstr::String, str::String) = match(Regex(rstr), str)
_match(r, str) = match(r, str)

function has_match(dict::Dict, qp::Pair)
    rkey, reg = qp
    rkey = string(rkey)
    !haskey(dict, rkey) && return false
    dval = string(dict[rkey])
    m = _match(reg, dval)
    return !isnothing(m)
end

# object fallback (use properties)
function has_match(obj, qp::Pair)
    rkey, reg = qp
    !hasproperty(obj, rkey) && return false
    dval = string(getproperty(obj, rkey))
    m = _match(reg, dval)
    return !isnothing(m)
end

has_match(obj, qp::String) = !isnothing(_match(qp, string(obj)))
has_match(obj, qp::Regex) = !isnothing(_match(qp, string(obj)))

function has_match(target, qps::Vector)
    for qp in qps
        ismatch = has_match(target, qp)
        !ismatch && return false
    end
    return true
end

## ------------------------------------------------------------------
function findall_match(vec::Vector, qp, qps...) 
    founds = Int[]
    for (i, obj) in enumerate(vec)
        match_flag = has_match(obj, qp)
        for qpi in qps
            match_flag |= has_match(obj, qpi)
        end
        match_flag && push!(founds, i)
    end
    return founds
end

function findfirst_match(vec::Vector{T}, qp, qps...) where T
    for (i, obj) in enumerate(vec)
        match_flag = has_match(obj, qp)
        for qpi in qps
            match_flag |= has_match(obj, qpi)
        end
        match_flag && return i
    end
    return nothing
end

filter_match(vec::Vector, qp, qps...) = vec[findall_match(vec, qp, qps...)]
