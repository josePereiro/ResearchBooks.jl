const _BIB_PATHS_CONFIG_KEY = "bibs"

function bibtex_paths(bookdir)
    config = read_configfile(bookdir)
    bibs = get(config, _BIB_PATHS_CONFIG_KEY, "")
    return (bibs isa String) ? [bibs] : bibs
end


function _read_bibtex(path)
    str = read(path, String)
    _, dict = BibTeX.parse_bibtex(str)
    return dict
end

bookbib_file(bookdir) = joinpath(bookdir, "bookbib.toml")
clear_bookbib_file(bookdir) = rm(bookbib_file(bookdir); force = true)

const _BOOKBIB = Dict{String, Any}()
function load_bookbib(bookdir)

    # Check for update
    tomlfile = bookbib_file(bookdir)
    update = !isfile(tomlfile)
    for path in bibtex_paths(bookdir)
        !isfile(path) && continue
        update && continue
        update |= _newer(tomlfile, path) == path
    end

    # Update or load
    if update
        empty!(_BOOKBIB)
        for path in bibtex_paths(bookdir)
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