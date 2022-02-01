## ------------------------------------------------------------------
# CONFIG
const CONFIG = Dict()
const BOOK_DIR_CONFIG_KEY = "book"
const LIBS_CONFIG_KEY = "libs"

## ------------------------------------------------------------------
# Utils
function _do_if_not_empty(f::Function, src, srckey)
    val = get(src, srckey, "")
    if !isempty(val)
        f(val)
    end
    return val
end

function _set_if_not_empty(src, configkey; srckey = configkey)
    _do_if_not_empty(src, srckey) do val
        CONFIG[configkey] = val
    end
end

function _push_if_not_empty(src, configkey; srckey = configkey)
    _do_if_not_empty(src, srckey) do val
        arr = get!(CONFIG, configkey, [])
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
# USER CONFIG
user_config_file() = joinpath(homedir(), ".research_book")
function open_user_config_file(cmd = "code")
    run(`$(cmd) $(user_config_file())`; wait = false)
    nothing
end

## ------------------------------------------------------------------
# ARGS
# const CONFIG_ARG_SET = ArgParseSettings()
# TODO: make ignore! parameters
# let
#     @add_arg_table! CONFIG_ARG_SET begin
#         "--book", "-b"
#             help = "the path to the research book folder"   
#             default = ""
#             arg_type=String
#     end
# end

# "--pdflatex-cmd"
#     help = "the pdflatex command to use"   
#     default = "pdflatex"
#     arg_type=String
# "--bibtex-cmd"
#     help = "the bibtex command to use"   
#     default = "bibtex"
#     arg_type=String
# "--nthrs", "-t"
#     help = "the juila command to use"   
#     default = max(Sys.CPU_THREADS - 1, 1)
#     arg_type=Int


function source_config()

    empty!(CONFIG)

    # defaults
    CONFIG[LIBS_CONFIG_KEY] = [joinpath(homedir(), "Documents", "My Library.bib")]

    # first load ENV
    _set_if_not_empty(ENV, BOOK_DIR_CONFIG_KEY; srckey = _BOOK_ENV_KEY)
    
    # then config file 
    if isfile(user_config_file())
        config_file = TOML.parsefile(user_config_file())
        
        _set_if_not_empty(config_file, BOOK_DIR_CONFIG_KEY)
        _push_if_not_empty(config_file, LIBS_CONFIG_KEY)
        
    end
    
    # them args
    # TODO: make ignore! parameters
    # args = parse_args(CONFIG_ARG_SET)        
    # _set_if_not_empty(args, BOOK_DIR_CONFIG_KEY)

    return CONFIG
end

"""
    The directory to the system book
"""
book_dir() = get(CONFIG, BOOK_DIR_CONFIG_KEY, "")

book_relpath(path) = relpath(path, book_dir())

"""
    The paths for .bib source files
"""
bibtex_paths() = get(CONFIG, LIBS_CONFIG_KEY, String[])