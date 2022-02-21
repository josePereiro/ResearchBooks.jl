# ------------------------------------------------------------

# to_read_docs() = filter_book([RBDoc, _to_read_query()])
# reading_docs() = filter_book([RBDoc, _reading_query()])
# read_docs() = filter_book([RBDoc, _read_query()])
# to_check_docs() = filter_book([RBDoc, _to_check_query()])
# ill_tagged_read_docs() = filter_book([RBDoc, _ill_tagged_read_query()])

# ------------------------------------------------------------
function show_tag_report(taglabel::String)
    # book
    book = _check_currbook()

    # look for childs
    childmetas = RBTagMeta[]
    for meta in eachtagmeta(book)
        stag = get_supertag(meta)
        (stag == taglabel) && push!(childmetas, meta)
    end
    isempty(childmetas) && return nothing

    # found objects
    founds = Dict{String, Vector}()
    for meta in childmetas
        label = get_label(meta)
        get!(founds, label, [])
        reg = _spaceless_unsensitive_regex(label)
        founds[label] = filter_book(:tags => _has_tag(reg))
    end

    # Print tag descriptions
    println("\n", "="^60)
    println("Tag found:")
    for meta in childmetas
        label = get_label(meta)
        desc = get_description(meta)
        println(label, ": ", desc)
    end

    # Print short resume
    println("\n", "="^60)
    println("Finding resume:")
    for (label, objs) in founds
        println(label, ": ", length(objs))
    end

    # TODO: find ill tagged using antagonist

    # Prompt
    println("\n", "="^60)
    print("Press 'y' to see all objects: ")
    input = readline()
    uppercase(input) != "Y" && return nothing

    # Displays objects
    println("Object found:")
    for (label, objs) in founds
        isempty(objs) && continue
        println("\n", "="^60)
        println(label, ": ", length(objs), " obj(s)", "\n")
        for (di, obj) in enumerate(objs)
            println("[", label, ": ", di, "]\n", obj)
        end
    end
end
