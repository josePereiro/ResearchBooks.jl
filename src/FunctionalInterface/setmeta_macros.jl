function _setproperty!(callinfo, ex)

    # obj
    obj = _check_currobj()
    
    # check
    _check_call_inbook(__source__, obj)
    _check_bang_call(__source__, obj)

    # collect
    meta = _extract_expr_pairs(ex)
        
    # quote
    exout = :()
    for (key, val) in meta
        exout = quote 
            $(exout)
            ResearchBooks.setproperty!($(obj), $(Meta.quot(key)), $(esc(val)))
        end
    end
    return quote 
        $(exout); $(esc(obj))
    end
end

## ------------------------------------------------------------------
# Meta setters
macro setproperty!(ex...)
    _setproperty!(__source__, ex)
end

macro set_title!(ex::String)
    obj = _check_currobj()
    _check_call_inbook(__source__, obj)
    _check_bang_call(__source__, obj)

    set_title!(obj, ex)
    return obj
end

macro set_doi!(ex::String)
    obj = _check_currobj()
    _check_call_inbook(__source__, obj)
    _check_bang_call(__source__, obj)

    set_doi!(obj, ex)
    return obj
end

macro set_bibkey!(ex::String)
    obj = _check_currobj()
    _check_call_inbook(__source__, obj)
    _check_bang_call(__source__, obj)

    set_bibkey!(obj, ex)
    return obj
end

macro set_abstract!(ex::String)
    obj = _check_currobj()
    _check_call_inbook(__source__, obj)
    _check_bang_call(__source__, obj)

    set_abstract!(obj, ex)
    return obj
end

macro set_text!(ex::String)
    obj = _check_currobj()
    _check_call_inbook(__source__, obj)
    _check_bang_call(__source__, obj)

    set_text!(obj, ex)
    return obj
end

macro set_year!(ex::String)
    obj = _check_currobj()
    _check_call_inbook(__source__, obj)
    _check_bang_call(__source__, obj)

    set_year!(obj, ex)
    return obj
end

macro set_author!(ex::Union{String, Symbol}...)
    obj = _check_currobj()
    _check_call_inbook(__source__, obj)
    _check_bang_call(__source__, obj)
    
    ex = string.(ex)
    set_author!(obj, ex...)
end

## ------------------------------------------------------------------
# Meta adders

macro add_tag!(ex::Union{String, Symbol}...)
    obj = _check_currobj()
    _check_call_inbook(__source__, obj)
    _check_bang_call(__source__, obj)
    
    ex = string.(ex)
    add_tag!(obj, ex...)
end

macro add_read!(ex::Union{String, Symbol}...)
    obj = _check_currobj()
    _check_call_inbook(__source__, obj)
    _check_bang_call(__source__, obj)
    
    ex = string.(ex)
    add_read!(obj, ex...)
end