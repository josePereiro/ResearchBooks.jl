## ------------------------------------------------------------------
const GLOB_STATE = Dict{String, Any}()

const _CURR_OBJ_KEY = "currobj"
currobj!(obj::Union{Nothing, RBObject} = nothing) = (setindex!(GLOB_STATE, obj, _CURR_OBJ_KEY); obj)
currobj() = get!(GLOB_STATE, _CURR_OBJ_KEY, nothing) 

const _CURR_DOC_KEY = "currdoc"
function currdoc!(d::Union{Nothing, RBDoc} = nothing) 
    setindex!(GLOB_STATE, d, _CURR_DOC_KEY)
    currobj!(d)
end
currdoc() = get!(GLOB_STATE, _CURR_DOC_KEY, nothing)

const _CURR_SEC_KEY = "currsec"
function currsec!(s::Union{Nothing, RBSection} = nothing) 
    setindex!(GLOB_STATE, s, _CURR_SEC_KEY)
    currobj!(s)
end
currsec() = get!(GLOB_STATE, _CURR_SEC_KEY, nothing)

const _CURR_BOOK_KEY = "currbook"
function currbook!(b::Union{Nothing, RBook} = nothing)
    setindex!(GLOB_STATE, b, _CURR_BOOK_KEY)
    currobj!(b)
end
currbook() = get!(GLOB_STATE, _CURR_BOOK_KEY, nothing) 
clearbook!() = currbook!()

