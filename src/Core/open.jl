function _open_src_libs(cmd = "code")
    for path in bibtex_paths()
        !isfile(path) && continue
        run(`$(cmd) $(path)`; wait = false)
    end
end

function _open_book_root(cmd = "code")
    broot = book_dir()
    if isdir(broot)
        run(`$(cmd) $(broot)`; wait = false)
    end
end
