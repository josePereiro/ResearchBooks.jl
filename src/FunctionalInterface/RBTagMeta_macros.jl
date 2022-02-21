## ------------------------------------------------------------------
function _new_tagmeta!(callinfo::LineNumberNode, label)

    # book
    book = _check_currbook()

    # TODO: Update book but just if necessary
    # _include_rbfiles!(book)

    # checks
    _check_call_inbook(callinfo, book)

    # new doc
    tmeta = RBTagMeta(label)
    set_book!(tmeta, book)
    srcfile!(tmeta, srcfile(callinfo))
    srcline!(tmeta, srcline(callinfo))

    # add to book
    add_tagmeta!(book, tmeta)

    currobj!(tmeta)
end

## ------------------------------------------------------------------
macro new_tagmeta!(label::String)
    _new_tagmeta!(__source__, label)
end
