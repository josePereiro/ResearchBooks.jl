## ------------------------------------------------------------------
# show
function Base.show(io::IO, n::RBNote)
    print(io, "RBNote: \"", n.txt , "\"")
end

## ------------------------------------------------------------------
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

