## ------------------------------------------------------------------
# USER CONFIG
_rbook_toml_name() = "ResearchBook.toml"
config_file(bookdir) = joinpath(bookdir, _rbook_toml_name())

function read_configfile(bookdir)
    cfile = config_file(bookdir)
    return TOML.parsefile(cfile)
end

## ------------------------------------------------------------------
function _find_bookdir(dir0::String)

    # search up
    root = homedir()
    bookdir = ""
    walkup(dir0) do path
        if isdir(path)
            (path == root) && return true
            bookfile = config_file(path)
            if isfile(bookfile)
                bookdir = path
                return true
            end
        end
    end
    return bookdir
end
