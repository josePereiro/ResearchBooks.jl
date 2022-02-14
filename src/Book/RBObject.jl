## ------------------------------------------------------------------
# Accessors
for sym in [:meta, :data]

    getfun = Symbol("get_", sym)
    fun = Symbol("get_", sym)
    @eval $(fun)(obj::RBObject) = error($(fun), "(obj::", typeof(obj), ") no defined!!!")
    @eval $(fun)(obj::RBObject, key) = getindex($(getfun)(obj), key)
    @eval $(fun)(obj::RBObject, key, deft) = get($(getfun)(obj), key, deft)
    @eval $(fun)(f::Function, obj::RBObject, key) = get(f, $(getfun)(obj), key)
    fun = Symbol("get_", sym, "!")
    @eval $(fun)(obj::RBObject, key, deft) = get!($(getfun)(obj), key, deft)
    @eval $(fun)(f::Function, obj::RBObject, key) = get!(f, $(getfun)(obj), key)

    fun = Symbol("has", sym)
    @eval $(fun)(obj::RBObject, key) = haskey($(getfun)(obj), key)
    fun = Symbol("set_", sym, "!")
    @eval $(fun)(obj::RBObject, key, val) = setindex!($(getfun)(obj), val, key)
    fun = Symbol(sym, "keys")
    @eval $(fun)(obj::RBObject) = keys($(getfun)(obj))
    fun = Symbol(sym, "values")
    @eval $(fun)(obj::RBObject) = values($(getfun)(obj))
end

## ------------------------------------------------------------------
# common metas
srcfile!(obj::RBObject, file::String) = set_meta!(obj, :srcfile, realpath(file))
srcfile(obj::RBObject)::String = get_meta(obj, :srcfile, "")

srcline!(obj::RBObject, line::Int) = set_meta!(obj, :srcline, line)
srcline(obj::RBObject)::Int = get_meta(obj, :srcline, -1)

get_parent(obj::RBObject) = get_meta(obj, :parent, nothing)
set_parent!(obj::RBObject, parent::RBObject) = set_meta!(obj, :parent, parent)

get_book(d::RBObject) = get_book(get_parent(d))
bookdir(q::RBObject) = bookdir(get_book(q))

get_tags(obj::RBObject) = get_meta!(obj, :tags, Set{String}())
add_tag!(obj::RBObject,  t::String, ts::String...) = (_push_csv!(get_tags(obj), t, ts...); obj)

function get_path(obj::RBObject; rel = false)
    file = srcfile(obj)
    file = rel ? relpath(file) : file
    line = srcline(obj)
    linestr = (line == -1) ? "" : string(":", line)
    return string(file, linestr)
end

get_relpath(obj::RBObject) = get_path(obj; rel = true)
