_call_if_something(f, arg, dflt = nothing) = isnothing(arg) ? dflt : f(arg)


# currbook
bookdir() = _call_if_something(bookdir, currbook(), "")

# currdoc
get_doi() = _call_if_something(get_doi, currdoc(), "")
get_year() = _call_if_something(get_year, currdoc(), "")
get_author() = _call_if_something(get_author, currdoc(), "")
get_bibkey() = _call_if_something(get_bibkey, currdoc(), "")

# currobj
get_title() = _call_if_something(get_title, currobj(), "")
get_tags() = _call_if_something(get_tags, currobj(), nothing)
get_path() = _call_if_something(get_path, currobj(), "")
get_relpath() = _call_if_something(get_relpath, currobj(), "")

# crossrefs
crossrefs(; force = false) = crossrefs(get_doi(); force)