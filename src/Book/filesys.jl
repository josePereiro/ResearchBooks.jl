function bookdir_relpath(path)
    book = currbook()
    bdir = bookdir(book)
    abspath(joinpath(bdir, path))
end