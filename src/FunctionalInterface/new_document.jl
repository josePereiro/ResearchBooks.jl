## ------------------------------------------------------------------
function _new_document!(srcfile, label)
    
    # TODO: Update book but just if necessary
    # _include_rbfiles()

    # TODO: Check we are in book file

    # book
    book = currbook()
    isnothing(book) && error("No Book selected. See `@openbook` help.")

    doc = RBDoc(label)
    setbook!(doc, book)
    srcfile!(doc, srcfile)

    push!(book, label => doc)

    currdoc!(doc)
end


## ------------------------------------------------------------------
macro new_document!(ex...)
    srcfile = string(__source__.file)
    callline = __source__.line

    if isempty(ex)
        # Insert random label
        macroreg = _macro_call_regex("new_document!")
        label = genlabel()
        newcall = string("@new_document!(\"", label, "\")")
        _replace_line(srcfile, callline, macroreg, newcall)
    elseif length(ex) == 1 && first(ex) isa String
        label = string(first(ex))
    else
        error("Too many arguments!. Expected either 0 or 1.")
    end
    _new_document!(srcfile, label)
end

# ## ------------------------------------------------------------------
# const _META_SECTION_KEY = "Meta"
# function new_document!(dockey::String; kwargs...)
    
    
#     # Add doc
#     dockey = format_idkey(dockey)
#     doc = RBDoc(book, dockey)
#     book[dockey] = doc
#     currdoc!(doc)
    
#     # Add Meta section
#     sec = add_section!(doc, _META_SECTION_KEY)
#     for (key, value) in kwargs
#         add_pair!(sec, string(key), value)
#     end

#     return doc
# end

# # Use a kwargs as input for the dockey
# function new_document!(dockey::Symbol; kwargs...)
#     !haskey(kwargs, dockey) && error("refkey ':$(dockey)' missing!")
#     dockey = string(kwargs[dockey])
#     new_document!(dockey::String; kwargs...)
# end
