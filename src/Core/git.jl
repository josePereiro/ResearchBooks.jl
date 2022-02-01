function _push_book(cmd = "git")
    broot = book_dir()
    if isdir(broot)
        run(`$(cmd) -C $(broot) add .`; wait = true)
        cm = "Assistant push"
        run(`$(cmd) -C $(broot) commit -m $(cm)`; wait = true)
        run(`$(cmd) -C $(broot) push`; wait = true)
        # run(`$(cmd) -C $(broot) --no-pager log -l1`; wait = true)
    end
end
