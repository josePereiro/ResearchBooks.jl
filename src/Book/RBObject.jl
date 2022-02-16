## ------------------------------------------------------------------
# Property handling
function Base.getproperty(obj::RBObject, p::Symbol)
    props = _get_properties(obj)
    return haskey(props, p) ? props[p] : getfield(obj, p)
end

function Base.getproperty(obj::RBObject, p::Symbol, dflt)
    props = _get_properties(obj)
    get(props, p, dflt)
end

function getproperty!(obj::RBObject, p::Symbol, dflt)
    props = _get_properties(obj)
    get!(props, p, dflt)
end

getproperty!(f::Function, obj::RBObject, p::Symbol) = getproperty!(obj, p, f())

function Base.setproperty!(obj::RBObject, p::Symbol, value)
    props = _get_properties(obj)
    props[p] = value
    return value
end

function Base.propertynames(obj::RBObject, private::Bool = false)
    return collect(keys(_get_properties(obj)))
end

## ------------------------------------------------------------------
# common metas
get_label(obj::RBObject) = getproperty(obj, :label, "")

srcfile!(obj::RBObject, file::String) = setproperty!(obj, :srcfile, realpath(file))
srcfile(obj::RBObject)::String = getproperty(obj, :srcfile, "")

srcline!(obj::RBObject, line::Int) = setproperty!(obj, :srcline, line)
srcline(obj::RBObject)::Int = getproperty(obj, :srcline, -1)

get_parent(obj::RBObject) = getproperty(obj, :parent, nothing)
set_parent!(obj::RBObject, parent::RBObject) = setproperty!(obj, :parent, parent)

get_book(d::RBObject) = get_book(get_parent(d))
bookdir(q::RBObject) = bookdir(get_book(q))

get_tags(obj::RBObject) = getproperty!(obj, :tags, Set{String}())
add_tag!(obj::RBObject,  t::String, ts::String...) = (_push_csv!(get_tags(obj), t, ts...); obj)

function get_path(obj::RBObject; rel = false)
    file = srcfile(obj)
    file = rel ? relpath(file) : file
    line = srcline(obj)
    linestr = (line == -1) ? "" : string(":", line)
    return string(file, linestr)
end

get_relpath(obj::RBObject) = get_path(obj; rel = true)
