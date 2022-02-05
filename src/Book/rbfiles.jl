## ------------------------------------------------------------------
const _INCLUDING_FLAG_KEY = "including"
_including_flag!(flag) = (GLOB_STATE[_INCLUDING_FLAG_KEY] = flag)
_including_flag() = get!(GLOB_STATE, _INCLUDING_FLAG_KEY, false)

_keepout_git(path) = (basename(path) == ".git")

const _RBFILE_SUFFIX = ".rb.jl"
_is_rbfile(path) = endswith(path, _RBFILE_SUFFIX)

const _INCLUDE_ORDER_CONFIG_KEY = "include-order"

function include_order(bookdir)
    config = read_configfile(bookdir)
    order = get(config, _INCLUDE_ORDER_CONFIG_KEY, "")
    order = (order isa String) ? [order] : order
    return bookdir_relpath.(order)
end

function include_rdfile(path; force = false)
    !isfile(path) && return false
    !_is_rbfile(path) && return false
    if force || _need_update(path)
        include(path)
        _up_mtime_reg!(path)
        return true
    end
    return false
end

function include_rbfiles(; force = false)
    book = currbook()
    bdir = bookdir(book)

    # include in order
    for path in include_order(bdir)
        include_rdfile(path; force)
    end

    # walkdown (un-ordered)
    keepout = _keepout_git
    walkdown(bdir; keepout) do path
        include_rdfile(path; force)
        return nothing
    end
end
