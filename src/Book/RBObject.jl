## ------------------------------------------------------------------
# Accessors
for sym in [:meta, :data]

    getfun = Symbol("get", sym)
    fun = Symbol("get", sym)
    @eval $(fun)(obj::RBObject) = error($(fun), "(obj::", typeof(obj), ") no defined!!!")
    @eval $(fun)(obj::RBObject, key) = getindex($(getfun)(obj), key)
    @eval $(fun)(obj::RBObject, key, deft) = get($(getfun)(obj), key, deft)
    @eval $(fun)(f::Function, obj::RBObject, key) = get(f, $(getfun)(obj), key)
    fun = Symbol("get", sym, "!")
    @eval $(fun)(obj::RBObject, key, deft) = get!($(getfun)(obj), key, deft)
    @eval $(fun)(f::Function, obj::RBObject, key) = get!(f, $(getfun)(obj), key)

    fun = Symbol("has", sym)
    @eval $(fun)(obj::RBObject, key) = haskey($(getfun)(obj), key)
    fun = Symbol("set", sym, "!")
    @eval $(fun)(obj::RBObject, key, val) = setindex!($(getfun)(obj), val, key)
    fun = Symbol(sym, "keys")
    @eval $(fun)(obj::RBObject) = keys($(getfun)(obj))
    fun = Symbol(sym, "values")
    @eval $(fun)(obj::RBObject) = values($(getfun)(obj))
end

## ------------------------------------------------------------------
# common metas
srcfile!(obj::RBObject, file) = setmeta!(obj, :srcfile, file)
srcfile(obj::RBObject) = getmeta(obj, :srcfile, "")

getparent(obj::RBObject) = getmeta(obj, :parent, nothing)
setparent!(obj::RBObject, parent::RBObject) = setmeta!(obj, :parent, parent)

getbook(d::RBObject) = getbook(getparent(d))
bookdir(q::RBObject) = bookdir(getbook(q))
