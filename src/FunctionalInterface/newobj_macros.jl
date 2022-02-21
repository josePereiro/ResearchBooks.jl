function _check_call_inbook(callinfo::LineNumberNode, obj::RBObject)
    csrc, bdir = srcfile(callinfo), bookdir(obj)
    !startswith(csrc, bdir) && error(
        "The call file is outside the book.\n", 
        "book at: '", bdir, "'\n",
        "call at: '", csrc, ":", srcline(callinfo), "'"
    )
end

function _check_bang_call(callinfo::LineNumberNode, obj::RBObject)
    csrc, osrc = srcfile(callinfo), srcfile(obj)
    (csrc != osrc) && error(
        "Object modification outside its definition file:\n",
        "obj at: '", osrc, ":", srcline(obj), "'\n",
        "call at: '", csrc, ":", srcline(callinfo), "'"
    )
end

function _add_secobj!(f::Function, callinfo::LineNumberNode)

    # sec
    sec = _check_currsec()
    
    # TODO: Update book but just if necessary
    # _include_rbfiles!(get_book(sec))
    
    # checks
    _check_call_inbook(callinfo, sec)
    _check_bang_call(callinfo, sec)
    
    obj = f()
    set_sec!(obj, sec)
    srcfile!(obj, srcfile(callinfo))
    srcline!(obj, srcline(callinfo))

    # add to section
    add_obj!(sec, obj)

    currobj!(obj)
end

function _insert_label!(macroname::String, ex::Tuple, callinfo::LineNumberNode)

    if isempty(ex)
        # Insert random label
        macroreg = _macro_call_regex(macroname)
        label = genlabel()
        newcall = string("@", macroname, "(\"", label, "\")")
        _replace_line(callinfo, macroreg, newcall)
    elseif length(ex) == 1 && first(ex) isa String
        label = string(first(ex))
    else
        error("Too many arguments!. Expected either 0 or 1.")
    end
    return label
end