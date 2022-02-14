_book_depot_dirname() = ".researchbook"
depotdir() = joinpath(bookdir(), _book_depot_dirname())
bookdir_relpath(path) = abspath(joinpath(bookdir(), path))