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
    return book
end

## ------------------------------------------------------------------
function new_document(key; kwargs...)
    book = currbook()
    isnothing(book) && error("No Book selected. See `openbook`.")
    
    # Add doc
    doc = RBDoc(book, key)
    book[key] = doc
    currdoc!(doc)
    
    # Add Meta section
    sec = add_section!(doc, "Meta")
    for (key, value) in kwargs
        add_pair!(sec, string(key), value)
    end

    return doc
end

function add_section!(doc::RBDoc, key::String)
    sec = RBSection(doc, key)
    doc[key] = sec
    currsec!(sec)
end
add_section(key::String) = add_section!(currdoc(), key)
new_section = add_section

## ------------------------------------------------------------------
function add_pair!(sec::RBSection, key::String, val)
    pair = RBPair(sec, key, val)
    push!(sec, pair)
end
add_pair(key::String, val) = add_pair!(currsec(), key, val)

function add_note!(sec::RBSection, txt::String)
    note = RBNote(sec, txt)
    push!(sec, note)
end
function add_note(txt::String, txts::String...) 
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
function add_quote(txt::String, txts::String...) 
    sec = currsec()
    add_quote!(sec, txt)
    for txti in txts
        add_quote!(sec, txti)
    end
    return sec
end
