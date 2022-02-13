## ------------------------------------------------------------------
function _new_quote!(srcfile, label)
    
    # TODO: Update book but just if necessary
    # _include_rbfiles()

    # TODO: Check we are in book file

    # book
    sec = currsec()
    isnothing(sec) && error("No Sec selected. See `currdoc` help.")

    obj = RBQuote(label)
    setsec!(obj, sec)

    push!(sec, label => obj)

    currobj!(obj)
end


## ------------------------------------------------------------------
macro new_quote!(ex...)
    srcfile = string(__source__.file)
    callline = __source__.line

    if isempty(ex)
        # Insert random label
        macroreg = _macro_call_regex("new_quote!")
        label = genlabel()
        newcall = string("@new_quote!(\"", label, "\")")
        _replace_line(srcfile, callline, macroreg, newcall)
    elseif length(ex) == 1 && first(ex) isa String
        label = string(first(ex))
    else
        error("Too many arguments!. Expected either 0 or 1.")
    end
    _new_quote!(srcfile, label)
end

