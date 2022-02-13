## ------------------------------------------------------------------
function _new_section!(srcfile, label)
    
    # TODO: Update book but just if necessary
    # _include_rbfiles()

    # TODO: Check we are in book file

    # book
    doc = currdoc()
    isnothing(doc) && error("No Doc selected. See `currdoc` help.")

    sec = RBSection()
    setdoc!(sec, doc)
    setlabel!(sec, label)

    push!(doc, label => sec)

    currsec!(sec)
end


## ------------------------------------------------------------------
macro new_section!(ex...)
    srcfile = string(__source__.file)
    callline = __source__.line

    if isempty(ex)
        # Insert random label
        macroreg = _macro_call_regex("new_section!")
        label = genlabel()
        newcall = string("@new_section!(\"", label, "\")")
        _replace_line(srcfile, callline, macroreg, newcall)
    elseif length(ex) == 1 && first(ex) isa String
        label = string(first(ex))
    else
        error("Too many arguments!. Expected either 0 or 1.")
    end
    _new_section!(srcfile, label)
end

