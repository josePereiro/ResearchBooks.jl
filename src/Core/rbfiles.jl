## ------------------------------------------------------------------
const _INCLUDING_PASS_KEY = "including_pass"
_set_ipass!(pass) = (GLOB_STATE[_INCLUDING_PASS_KEY] = pass)
get_ipass() = get!(GLOB_STATE, _INCLUDING_PASS_KEY, 0)
is_ipass0() = (get_ipass() == 0)
is_ipass1() = (get_ipass() == 1)
is_ipass2() = (get_ipass() == 2)

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

const _INCLUDE_MTIME_EVENT = FileMTimeEvent()
function _include_rdfile(path; force = false)
    !isfile(path) && return false
    !_is_rbfile(path) && return false
    
    need_update = has_event!(_INCLUDE_MTIME_EVENT, path)
    if force || need_update
        include(path)
        return true
    end
    return false
end

function _include_rbfiles(; force = false)

    # TODO: for now including all files every time
    # A no-action-required mechanism must be provided
    force = true

    if is_ipass0()
        try
            book = currbook()
            empty!(book)
            bdir = bookdir(book)
            
            for ipass in 1:2

                _set_ipass!(ipass)

                # include in order
                for path in include_order(bdir)
                    _include_rdfile(path; force)
                end

                # walkdown (un-ordered)
                keepout = _keepout_git
                walkdown(bdir; keepout) do path
                    _include_rdfile(path; force)
                    return nothing
                end

            end

        finally
            _set_ipass!(0)
        end
    end
    
end
