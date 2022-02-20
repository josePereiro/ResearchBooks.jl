srcfile(src::LineNumberNode) = abspath(string(src.file))
srcline(src::LineNumberNode) = src.line

function _check_file(obj, srcnode)

    # book
    book = _check_currbook()
    bdir = bookdir(book)

    src = srcfile(srcnode)
    if !isfile(src) 
        startswith(basename(src), "REPL") &&
            error("A new object can't be created from the repl. Use a `.br.jl` file at the books folder!!!")
        error("A new object must be defined in a `.br.jl` file under the book directory!!")
    end
    abspath(srcfile(obj)) != abspath(src)

    return src
end

function _extract_expr_pairs(ex)

    ex = (ex isa Tuple) ? ex : tuple(ex)

    pairs = Dict()
    for subex in ex
        (subex isa LineNumberNode) && continue
        if Meta.isexpr(subex, :(=))
            key, val = subex.args

            if key isa Symbol
                pairs[key] = val
                continue
            end
        end
        error("Unsupported syntax at:\n", subex, 
            "\n\nUsage:\n@macro(A = \"Bla\", B = [1,2,3]) or", 
            "\n@macro A = \"Bla\"  B = [1,2,3]\n"
        )
    end
    return pairs
end

function _capture_output(dofunc::Function)
    tfile = tempname()
    try
        touch(tfile)
        open(tfile, "w") do out
            redirect_stdout(out) do
                redirect_stderr(out) do
                    dofunc()
                end
            end
        end
        return read(tfile, String)
    finally
        rm(tfile; force = true)
    end
end

