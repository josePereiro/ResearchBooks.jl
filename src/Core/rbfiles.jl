## ------------------------------------------------------------------
_set_ipass!(pass::Int) = setindex!(GLOB_STATE, pass, :ipass)
get_ipass() = get!(GLOB_STATE, :ipass, 0)
is_ipass0() = (get_ipass() == 0)
is_ipass1() = (get_ipass() == 1)
is_ipass2() = (get_ipass() == 2)

_keepout_git(path) = (basename(path) == ".git")

_rbfile_suffix() = ".rb.jl"
_is_rbfile(path) = endswith(path, _rbfile_suffix())


_include_order_configkey() = "include-order"
function include_order(bookdir)
    config = read_configfile(bookdir)
    order = get(config, _include_order_configkey(), "")
    order = (order isa String) ? [order] : order
    return bookdir_relpath.(order)
end

const _INCLUDE_MTIME_EVENT = FileMTimeEvent()
function _include_rdfile(path; force = false)
    !isfile(path) && return false
    !_is_rbfile(path) && return false
    
    need_update = has_event!(_INCLUDE_MTIME_EVENT, path)
    if force || need_update
        # include into main
        Base.include(Main, path)
        return true
    end
    return false
end

function _include_rbfiles!(book::RBook; force = false, nipass = 3)

    # TODO: for now including all files every time
    # A no-action-required mechanism must be provided
    force = true

    if is_ipass0()
        try
            empty!(book)
            bdir = bookdir(book)
            
            for ipass in 1:nipass

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
