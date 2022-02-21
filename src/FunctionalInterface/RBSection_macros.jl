## ------------------------------------------------------------------
function _new_section!(callinfo::LineNumberNode, label)
    
    # book
    doc = _check_currdoc()
    
    # TODO: Update book but just if necessary
    # _include_rbfiles!(get_book(doc))
    
    # checks
    _check_call_inbook(callinfo, doc)
    _check_bang_call(callinfo, doc)
    
    # new section
    sec = RBSection(label)
    setdoc!(sec, doc)
    srcfile!(sec, srcfile(callinfo))
    srcline!(sec, srcline(callinfo))
    
    # add to doc
    add_sec!(doc, sec)

    currsec!(sec)
end

## ------------------------------------------------------------------
macro new_section!(ex...)
    label = _insert_label!("new_section!", ex, __source__)
    _new_section!(__source__, label)
end

