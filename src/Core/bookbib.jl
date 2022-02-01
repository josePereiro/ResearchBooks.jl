function _read_bibtex(path)
    str = read(path, String)
    _, dict = BibTeX.parse_bibtex(str)
    return dict
end

const _BOOKBIB = Dict{String, Any}()
function load_bookbib()

    # Check for update
    tomlfile = bookbib_file()
    update = !isfile(tomlfile)
    for path in bibtex_paths()
        !isfile(path) && continue
        update && continue
        update |= _newer(tomlfile, path) == path
    end

    # Update or load
    if update
        empty!(_BOOKBIB)
        for path in bibtex_paths()
            dict = _read_bibtex(path)
            merge!(_BOOKBIB, dict)
        end
        open(tomlfile, "w") do io
            TOML.print(io, _BOOKBIB; sorted=false)
        end
    elseif isempty(_BOOKBIB)
        empty!(_BOOKBIB)
        merge!(_BOOKBIB, TOML.parsefile(tomlfile))
    end
    return _BOOKBIB
end

bookbib_file() = joinpath(book_dir(), "bookbib.toml")
clear_bookbib_file() = rm(bookbib_file(); force = true)