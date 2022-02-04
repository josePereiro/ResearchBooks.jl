## ------------------------------------------------------------------
const GLOB_STATE = Dict{String, Any}()

const _CURR_DOC_KEY = "currdoc"
currdoc!(d::RBDoc) = (GLOB_STATE[_CURR_DOC_KEY] = d)
currdoc!() = (GLOB_STATE[_CURR_DOC_KEY] = nothing)
currdoc() = get!(GLOB_STATE, _CURR_DOC_KEY, nothing)

const _CURR_SEC_KEY = "currsec"
currsec!(s::RBSection) = (GLOB_STATE[_CURR_SEC_KEY] = s)
currsec!() = (GLOB_STATE[_CURR_SEC_KEY] = nothing)
currsec() = get!(GLOB_STATE, _CURR_SEC_KEY, nothing)

const _CURR_BOOK_KEY = "currbook"
currbook!(b::RBook) = (GLOB_STATE[_CURR_BOOK_KEY] = b)
currbook!() = (GLOB_STATE[_CURR_BOOK_KEY] = nothing)
currbook() = get!(GLOB_STATE, _CURR_BOOK_KEY, nothing) 

## ------------------------------------------------------------------
function find_bookdir(dir0::String)

    # curr dir
    # if isfile(config_file(dir0))
    #     return dir0
    # end
    # @show dir0

    # search up
    root = homedir()
    bookdir = ""
    walkup(dir0) do path
        if isdir(path)
            @show path
            (path == root) && return true
            bookfile = config_file(path)
            @show isfile(bookfile)
            if isfile(bookfile)
                bookdir = path
                return true
            end
        end
    end
    return bookdir

end

## ------------------------------------------------------------------
function openbook(dir0::String; reload = false)

    # bookdir
    bookdir = find_bookdir(dir0)
    isempty(bookdir) && error("No '$(_RBOOK_FILE_NAME)' file found in current or any parent directory")

    # Load cache
    # GLOB_STATE
    
    # If cache missed
    book = currbook()
    if isnothing(book)
        book = RBook(bookdir, RBDoc[])
    end
    currbook!(book)
    
    return book
end

## ------------------------------------------------------------------
function new_document(key; kwargs...)
    book = currbook()
    isnothing(book) && error("Any current Book available")
    
    # TODO:: Finish this
    doc = RBDoc(book, key, RBSection[])
    push!(book, doc)
    
    currdoc!(doc)
end