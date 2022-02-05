const _MTIME_REGISTRY = Dict{String, Float64}()

function _need_update(path)
    curr_mtime = mtime(path)
    last_mtime = get!(_MTIME_REGISTRY, path, -1.0)
    curr_mtime != last_mtime
end

_up_mtime_reg!(path) = (_MTIME_REGISTRY[path] = mtime(path))