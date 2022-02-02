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
function openbook(; reload = false)
    
    # book dir
    _source_user_config()
    path = _config_book_dir()
    isempty(path) && error("'book' path not defined!")

    # Load cache
    # GLOB_STATE
    
    # If cache missed
    book = currbook()
    if isnothing(book)
        book = RBook(path, RBDoc[])
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