## ------------------------------------------------------------------
function _new_document!(callinfo::LineNumberNode, label)

    # book
    book = _check_currbook()

    # TODO: Update book but just if necessary
    # _include_rbfiles!(book)

    # checks
    _check_call_inbook(callinfo, book)

    # new doc
    doc = RBDoc(label)
    set_book!(doc, book)
    srcfile!(doc, srcfile(callinfo))
    srcline!(doc, srcline(callinfo))

    push!(book, label => doc)

    currdoc!(doc)
end

## ------------------------------------------------------------------
macro new_document!(ex...)
    label = _insert_label!("new_document!", ex, __source__)
    _new_document!(__source__, label)
end
