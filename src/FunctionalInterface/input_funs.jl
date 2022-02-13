

## ------------------------------------------------------------------
# const _META_SECTION_KEY = "Meta"
# function new_document!(dockey::String; kwargs...)
    
#     # book
#     book = currbook()
#     isnothing(book) && error("No Book selected. See `openbook`.")
    
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
