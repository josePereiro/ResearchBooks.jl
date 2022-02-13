function _check_setmeta_call(src)
    # TODO: Check it is run from a books file
    # TODO: Maybe from the same file than the object

    # obj
    obj = currobj()
    isnothing(obj) && error("No obj selected. See `currobj` help.")
    return obj
end

function _setmeta!(src, ex)

    obj = _check_setmeta_call(src)

    # collect
    meta = _extract_expr_pairs(ex)
        
    # eval
    exout = :()
    for (key, val) in meta
        exout = quote 
            $(exout)
            ResearchBooks.setmeta!($(obj), $(Meta.quot(key)), $(esc(val)))
        end
    end
    return quote 
        $(exout); $(esc(obj))
    end
end

## ------------------------------------------------------------------
# setmeta
macro setmeta!(ex...)
    _setmeta!(__source__, ex)
end

## ------------------------------------------------------------------
# settitle
macro settitle!(ex::String)
    obj = _check_setmeta_call(__source__)
    settitle!(obj, ex)
    return :(nothing)
end

# setdoi
macro setdoi!(ex::String)
    obj = _check_setmeta_call(__source__)
    setdoi!(obj, ex)
    return :(nothing)
end

macro settxt!(ex::String)
    obj = _check_setmeta_call(__source__)
    settxt!(obj, ex)
    return :(nothing)
end