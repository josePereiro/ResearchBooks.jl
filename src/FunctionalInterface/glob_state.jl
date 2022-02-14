## ------------------------------------------------------------------
const GLOB_STATE = Dict{Symbol, Any}()

currobj!(o::Union{Nothing, RBObject}) = (setindex!(GLOB_STATE, o, :currobj); o)
currobj!() = currobj!(nothing)
currobj() = get!(GLOB_STATE, :currobj, nothing) 

currsec!(s::Union{Nothing, RBSection}) = (setindex!(GLOB_STATE, currobj!(s), :currsec); s)
currsec!() = (currsec!(nothing); currobj!())
currsec() = get!(GLOB_STATE, :currsec, nothing)

currdoc!(d::Union{Nothing, RBDoc}) = (setindex!(GLOB_STATE, currobj!(d), :currdoc); d)
currdoc!() = (currdoc!(nothing); currsec!())
currdoc() = get!(GLOB_STATE, :currdoc, nothing)

currbook!(b::Union{Nothing, RBook}) = (setindex!(GLOB_STATE, currobj!(b), :currbook); b)
currbook!() = (currbook!(nothing); currdoc!())
currbook() = get!(GLOB_STATE, :currbook, nothing) 
clearbook!() = currbook!()

## ------------------------------------------------------------------
# book
function _check_currbook()
    book = currbook()
    isnothing(book) && error("No `RBook` selected. See `@openbook` help.")
    return book
end

function _check_currdoc()
    doc = currdoc()
    isnothing(doc) && error("No `RBDoc` selected. See `@new_document!` help.")
    return doc
end

function _check_currsec()
    sec = currsec()
    isnothing(sec) && error("No `RBSec` selected. See `@new_section!` help.")
    return sec
end

function _check_currobj()
    obj = currobj()
    isnothing(obj) && error("No `RBObject` selected. See `currobj` help.")
    return obj
end


## ------------------------------------------------------------------
# Functional Interface
bookdir() = bookdir(currbook())
bookbib() = bookbib(bookdir())