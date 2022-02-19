# TODO add filter
function show_tags(q, qs...)
    book = currbook()
    acc = Set{String}()
    for obj in eachobj(book)
        tags = get_tags(obj)
        isempty(tags) || push!(acc, tags...)
    end

    sorted = sort(collect(acc))
    filtered = filter_match(sorted, q, qs)
    for (i, tag) in enumerate(filtered)
        println("[", i, "] ", tag)
    end
    return nothing
end
show_tags() = show_tags(r"")