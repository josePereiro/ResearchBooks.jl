## ------------------------------------------------------------------
function _openbook(dir0::String; reload = false)
    
    # If cache missed
    book = currbook()
    if isnothing(book)

        # bookdir
        bdir = _find_bookdir(dir0)
        isempty(bdir) && error("No '$(_rbook_toml_name())' file found in current or any parent directory!!!")
        
        # new book
        book = RBook()
        bookdir!(book, bdir)
        currbook!(book)
    end

    # Update book
    _include_rbfiles!(book; force = reload)

    return book
end
openbook(;reload = false) = _openbook(pwd(); reload)


# TODO: reload force option
macro openbook()
    src = srcfile(__source__)
    src = isfile(src) ? src : pwd()
    book = _openbook(dirname(src); reload = false)
    return book
end