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

## ------------------------------------------------------------------
const _INCLUDING_FLAG_KEY = "including"
_including_flag!(flag) = (GLOB_STATE[_INCLUDING_FLAG_KEY] = flag)
_including_flag() = get!(GLOB_STATE, _INCLUDING_FLAG_KEY, false)

function _include_rbfiles_keepout(path)
    basename(path) == ".git"
end

function include_rbfiles(; force = false)
    book = currbook()
    bdir = bookdir(book)
    keepout = _include_rbfiles_keepout
    walkdown(bdir; keepout) do path
        !isfile(path) && return false
        !endswith(path, ".rb.jl") && return false
        if force || _need_update(path)
            include(path)
            _up_mtime_reg!(path)
        end
    end
end

## ------------------------------------------------------------------
function openbook(dir0::String; reload = false)
    
    # If cache missed
    book = currbook()
    if isnothing(book)

        # bookdir
        bookdir = find_bookdir(dir0)
        isempty(bookdir) && error("No '$(_RBOOK_FILE_NAME)' file found in current or any parent directory")

        # new book
        book = RBook(bookdir)
        currbook!(book)
    end

    # Update book
    if reload || !_including_flag()
        try
            _including_flag!(true)
            include_rbfiles(; force = reload)
        finally
            _including_flag!(false)
        end
    end

    return book
end

## ------------------------------------------------------------------
function format_idkey(key)
    reg = Regex("[^A-Za-z0-9]")
    key = replace(key, reg => "_")
    return key
end

function new_document!(dockey::String; kwargs...)
    
    # book
    book = currbook()
    isnothing(book) && error("No Book selected. See `openbook`.")
    
    # Add doc
    dockey = format_idkey(dockey)
    doc = RBDoc(book, dockey)
    book[dockey] = doc
    currdoc!(doc)
    
    # Add Meta section
    sec = add_section!(doc, "Meta")
    for (key, value) in kwargs
        add_pair!(sec, string(key), value)
    end

    return doc
end

# Use a kwargs as input for the dockey
function new_document!(dockey::Symbol; kwargs...)
    !haskey(kwargs, dockey) && error("refkey ':$(dockey)' missing!")
    dockey = string(kwargs[dockey])
    new_document!(dockey::String; kwargs...)
end

function add_section!(doc::RBDoc, key::String)
    key = format_idkey(key)
    sec = RBSection(doc, key)
    doc[key] = sec
    currsec!(sec)
end
add_section!(key::String) = add_section!(currdoc(), key)
new_section! = add_section!

## ------------------------------------------------------------------
function add_pair!(sec::RBSection, key::String, val)
    pair = RBPair(sec, key, val)
    push!(sec, pair)
end
add_pair!(key::String, val) = add_pair!(currsec(), key, val)

function add_note!(sec::RBSection, txt::String)
    note = RBNote(sec, txt)
    push!(sec, note)
end
function add_note!(txt::String, txts::String...) 
    sec = currsec()
    add_note!(sec, txt)
    for txti in txts
        add_note!(sec, txti)
    end
    return sec
end


function add_quote!(sec::RBSection, txt::String)
    note = RBQuote(sec, txt)
    push!(sec, note)
end
function add_quote!(txt::String, txts::String...) 
    sec = currsec()
    add_quote!(sec, txt)
    for txti in txts
        add_quote!(sec, txti)
    end
    return sec
end

## ------------------------------------------------------------------
# Link Tools
seclink(sec::RBSection) = string(dockey(sec), "::", seckey(sec))
seclink() = seclink(currsec())
seclink(i::Int) = seclink(currdoc()[i])
seclink(key::String) = seclink(currdoc()[key])