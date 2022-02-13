macro setmeta!(ex...)

    # TODO: Check it is run from a books file
    # TODO: Maybe from the same file than the object
    
    # obj
    obj = currobj()
    isnothing(obj) && error("No obj selected. See `currobj` help.")
    
    # collect
    pairs = _extract_expr_pairs(ex)
    
    # eval
    exout = :()
    for (key, val) in pairs
        exout = quote 
            $(exout)
            ResearchBooks.setmeta!($(obj), $(Meta.quot(key)), $(esc(val)))
        end
    end
    return quote 
        $(exout); $(esc(obj))
    end

end