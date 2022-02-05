function markdown_str(q::RBQuote)
    split_ = split(q.txt, "\n")
    return string(">", join(split_, "\n>"))
end

function markdown_str(n::RBNote)
    return n.txt
end

function markdown_str(p::RBPair)
    return string("- ", p.key, ": ", p.val)
end

function markdown_str(t::RBTagLine)
    return string("***", t.tag, "***")
end

function markdown_str(i::RBItem)
    return string("***'", nameof(i), "' not supported", "***")
end

# TODO: introduce grupping (tag grups, etc)
function create_markdown(doc::RBDoc, outfile)
    lines = String[]
    
    # top level
    push!(lines, string("# ", dockey(doc)))
    push!(lines, "")
    
    for (seckey, sec) in sections(doc)
        push!(lines, string("## ", seckey))
        push!(lines, "")

        for item in items(sec)
            push!(lines, markdown_str(item))
            push!(lines, "")
        end

    end

    # write
    open(outfile, "w") do io
        for line in lines
            println(io, line)
        end
    end
end

# TODO: Add expand links
macro create_doc_readme()
    __file__ = string(__source__.file)
    outfile = joinpath(dirname(__file__), "README.md")
    create_markdown(currdoc(), outfile)
    :(nothing)
end