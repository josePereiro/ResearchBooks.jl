## ------------------------------------------------------------------
function _setproperty!(callinfo::LineNumberNode, ex)

    # obj
    obj = _check_currobj()
    
    # check
    _check_call_inbook(callinfo, obj)
    _check_bang_call(callinfo, obj)

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

function _invoke_setter(setter::Function, callinfo::LineNumberNode, ex...)
    obj = _check_currobj()
    _check_call_inbook(callinfo, obj)
    _check_bang_call(callinfo, obj)

    setter(obj, ex...)
    
    return obj
end

## ------------------------------------------------------------------
# Meta setters

macro setproperty!(ex...)
    _setproperty!(__source__, ex)
end

macro set_title!(ex::String)
    _invoke_setter(set_title!, __source__, ex)
end

macro set_doi!(ex::String)
    _invoke_setter(set_doi!, __source__, ex)
end

macro set_bibkey!(ex::String)
    _invoke_setter(set_bibkey!, __source__, ex)
end

macro set_abstract!(ex::String)
    _invoke_setter(set_abstract!, __source__, ex)
end

macro set_text!(ex::String)
    _invoke_setter(set_text!, __source__, ex)
end

macro set_year!(ex::String)
    _invoke_setter(set_year!, __source__, string(ex))
end

macro set_author!(ex::Union{String, Symbol}...)
    _invoke_setter(set_author!, __source__, string.(ex)...)
end

macro set_ctime!(ex::String)
    _invoke_setter(set_ctime!, __source__, ex)
end

macro set_similars!(ex::Union{String, Symbol}...)
    _invoke_setter(set_similars!, __source__, string.(ex)...)
end

macro set_antagonists!(ex::Union{String, Symbol}...)
    _invoke_setter(set_antagonists!, __source__, string.(ex)...)
end

macro set_description!(ex::String)
    _invoke_setter(set_description!, __source__, ex)
end

macro set_supertag!(ex::String)
    _invoke_setter(set_supertag!, __source__, ex)
end

## ------------------------------------------------------------------
# Meta adders

macro add_tag!(ex::Union{String, Symbol}...)
    _invoke_setter(add_tag!, __source__, string.(ex)...)
end