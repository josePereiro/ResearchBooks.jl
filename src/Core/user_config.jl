## ------------------------------------------------------------------
# USER_CONFIG
const USER_CONFIG = Dict()
const _BOOK_DIR_CONFIG_KEY = "book"
const _LIBS_CONFIG_KEY = "bibs"

## ------------------------------------------------------------------
# Utils
function _do_if_not_empty(f::Function, src, srckey)
    val = get(src, srckey, "")
    if !isempty(val)
        f(val)
    end
    return val
end

# ser USER_CONFIG[configkey] if src[srckey] is not empty
function _set_if_not_empty(src, configkey; srckey = configkey)
    _do_if_not_empty(src, srckey) do val
        USER_CONFIG[configkey] = val
    end
end

# push! into USER_CONFIG[configkey] if src[srckey] is not empty
function _push_if_not_empty(src, configkey; srckey = configkey)
    _do_if_not_empty(src, srckey) do val
        arr = get!(USER_CONFIG, configkey, [])
        if val isa Array
            push!(arr, val...)
        else
            push!(arr, val)
        end
    end
end


## ------------------------------------------------------------------
# ENV VARS
const _BOOK_ENV_KEY = "RESEARCH_BOOK_ROOT"

## ------------------------------------------------------------------
# USER USER_CONFIG
user_config_file() = joinpath(homedir(), ".research_book")
function open_user_config_file(cmd = "code")
    run(`$(cmd) $(user_config_file())`; wait = false)
    nothing
end

function _source_user_config()

    empty!(USER_CONFIG)

    # defaults
    USER_CONFIG[_LIBS_CONFIG_KEY] = String[]

    # first load ENV
    _set_if_not_empty(ENV, _BOOK_DIR_CONFIG_KEY; srckey = _BOOK_ENV_KEY)
    
    # then config file 
    if isfile(user_config_file())
        config_file = TOML.parsefile(user_config_file())
        
        _set_if_not_empty(config_file, _BOOK_DIR_CONFIG_KEY)
        _push_if_not_empty(config_file, _LIBS_CONFIG_KEY)
        
    end

    return USER_CONFIG
end

"""
    The directory to the system book
"""
_config_book_dir() = get(USER_CONFIG, _BOOK_DIR_CONFIG_KEY, "")

# book_relpath(path) = relpath(path, book_dir())

"""
    The paths for .bib source files
"""
bibtex_paths() = get(USER_CONFIG, _LIBS_CONFIG_KEY, String[])