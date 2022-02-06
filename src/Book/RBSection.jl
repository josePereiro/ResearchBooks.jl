## ------------------------------------------------------------------
# Section
RBSection(doc::RBDoc, key::String) = RBSection(doc, key, RBItem[])

## ------------------------------------------------------------------
# Accessors
parent(s::RBSection) = s.doc
bookdir(s::RBSection) = bookdir(parent(s))
items(s::RBSection) = s.items
dockey(s::RBSection) = dockey(parent(s))
seckey(s::RBSection) = s.key

Base.collect(s::RBSection) = collect(items(s))
Base.collect(T::Type, s::RBSection) = filter((i) -> i isa T, items(s))

## ------------------------------------------------------------------
# Array
Base.length(s::RBSection) = length(items(s))
Base.push!(s::RBSection, e::RBItem, es::RBItem...) = push!(items(s), e, es...)
Base.setindex!(s::RBSection, value::RBItem, idx::Int) = setindex!(items(s), value, idx)
Base.getindex(s::RBSection, idx) = getindex(items(s), idx)
Base.lastindex(s::RBSection) = lastindex(items(s))
Base.firstindex(s::RBSection) = firstindex(items(s))
Base.iterate(s::RBSection) = iterate(items(s))
Base.iterate(s::RBSection, state) = iterate(items(s), state)

## ------------------------------------------------------------------
# Show
function Base.show(io::IO, d::RBSection)
    println(io, "RBSection with ", length(d), " items(s)")
    println(io, "bookdir: ", bookdir(d))
    println(io, "dockey: \"", dockey(d), "\"")
    println(io, "seckey: \"", seckey(d), "\"")
    print(io, "items:")
    for item in items(d)
        print(io, "\n  ", item)
    end
end

## ------------------------------------------------------------------
# Link Tools
seclink(sec::RBSection) = string(dockey(sec), "::", seckey(sec))
seclink() = seclink(currsec())
seclink(i::Int) = seclink(currdoc()[i])
seclink(key::String) = seclink(currdoc()[key])

## ------------------------------------------------------------------
function add_section!(doc::RBDoc, key::String)
    key = format_idkey(key)
    sec = RBSection(doc, key)
    doc[key] = sec
    currsec!(sec)
end
add_section!(key::String) = add_section!(currdoc(), key)
new_section! = add_section!
