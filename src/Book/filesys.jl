bookdir() = bookdir(currdoc())

const _BOOK_DEPOT_DIR_NAME = ".research_book"
depotdir() = joinpath(bookdir(), _BOOK_DEPOT_DIR_NAME)

function bookdir_relpath(path)
    book = currbook()
    bdir = bookdir(book)
    abspath(joinpath(bdir, path))
end