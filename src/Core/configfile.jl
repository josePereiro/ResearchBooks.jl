## ------------------------------------------------------------------
# USER CONFIG
const _RBOOK_FILE_NAME = "ResearchBook.toml"
config_file(bookdir) = joinpath(bookdir, _RBOOK_FILE_NAME)

function read_configfile(bookdir)
    cfile = config_file(bookdir)
    return TOML.parsefile(cfile)
end

## ------------------------------------------------------------------
