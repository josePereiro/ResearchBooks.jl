## ------------------------------------------------------------------


## ------------------------------------------------------------------
function openbook(dir0::String; reload = false)
    
    # If cache missed
    book = currbook()
    if isnothing(book)

        # bookdir
        bookdir = find_bookdir(dir0)
        isempty(bookdir) && error("No '$(_RBOOK_FILE_NAME)' file found in current or any parent directory")

        # new book
        book = RBook(bookdir)
        currbook!(book)
    end

    # Update book
    if reload || !_including_flag()
        try
            _including_flag!(true)
            include_rbfiles(; force = reload)
        finally
            _including_flag!(false)
        end
    end

    return book
end

# TODO: reload force option
macro openbook()
    __file__ = string(__source__.file)
    openbook(dirname(__file__); reload = false)
    return :(nothing)
end