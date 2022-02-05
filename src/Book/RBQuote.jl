
## ------------------------------------------------------------------
# show
function Base.show(io::IO, q::RBQuote)
    print(io, "RBQuote: \"", q.txt, "\"")
end

## ------------------------------------------------------------------
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