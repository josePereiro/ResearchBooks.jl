## ------------------------------------------------------------------
# Meta

get_book(d::RBDoc) = get_parent(d)
set_book!(d::RBDoc, book::RBook) = set_parent!(d, book)

get_title(d::RBDoc) = getproperty!(d, :title, "")
set_title!(d::RBDoc, title::String) = setproperty!(d, :title, strip(title))

get_doi(d::RBDoc) = getproperty!(d, :doi, "")
set_doi!(d::RBDoc, doi::String) = setproperty!(d, :doi, _doi_to_url(strip(doi)))

get_year(d::RBDoc) = getproperty!(d, :year, "")
set_year!(d::RBDoc, year::String) = setproperty!(d, :year, strip(year))

get_bibkey(d::RBDoc) = getproperty!(d, :bibkey, "")
set_bibkey!(d::RBDoc, bibkey::String) = setproperty!(d, :bibkey, strip(bibkey))

get_abstract(d::RBDoc) = getproperty!(d, :abstract, "")
set_abstract!(d::RBDoc, abstract::String) = setproperty!(d, :abstract, strip(abstract))

get_ctime(d::RBDoc) = getproperty!(d, :ctime, "")
set_ctime!(d::RBDoc, ctime::String) = setproperty!(d, :ctime, strip(ctime))

get_author(d::RBDoc) = getproperty!(d, :authors, Set{String}())
set_author!(d::RBDoc, author::String, authors::String...) = (_push_csv!(empty!(get_author(d)), author, authors...); d)

## ------------------------------------------------------------------
# Data
sections(d::RBDoc) = getproperty!(() -> OrderedDict{String, RBSection}(), d, :secs)
hassec(d::RBDoc, label::String) = haskey(sections(d), strip(label))

## ------------------------------------------------------------------
# OrderedDict
Base.length(d::RBDoc) = length(sections(d))
Base.getindex(d::RBDoc, key::String) = getindex(sections(d), key)
Base.get(d::RBDoc, key::String, default) = get(sections(d), key, default)
Base.get!(d::RBDoc, key::String, default) = get!(sections(d), key, default)

## ------------------------------------------------------------------
# Array
Base.getindex(d::RBDoc, idx) = (secs = sections(d); getindex(_values(secs), idx))
Base.lastindex(d::RBDoc) = lastindex(_values(sections(d)))
Base.firstindex(d::RBDoc) = firstindex(_values(sections(d)))
Base.iterate(d::RBDoc) = iterate(_values(sections(d)))
Base.iterate(d::RBDoc, state) = iterate(_values(sections(d)), state)

## ------------------------------------------------------------------
# show
function Base.show(io::IO, d::RBDoc)
    nsecs = length(d)
    println(io, "RBDoc(\"", get_label(d), "\") with ", nsecs, " section(s)")
    print(io, " - path: '", localrelpath(d), "'")
    
    # meta
    for meta in [:title, :doi]
        str = getproperty(d, meta, "")
        if !isempty(str) 
            print(io, "\n - ", meta, ": \"", _preview(io, str), "\"")
        end
    end
    
    # data
    if nsecs > 0
        print(io, "\nsection(s):")
        _show_data_preview(io, d) do sec
            string("[", get_label(sec), "] ", get_title(sec))
        end
    end
    print(io, "\n", _preview(io, "-"^70))
    return nothing
end

## ------------------------------------------------------------------
# API
function eachobj(doc::RBDoc)
    ch = Channel{RBObject}(1) do ch_
        for sec in doc
            put!(ch_, sec)
            for obj in sec
                put!(ch_, obj)
            end
        end
    end

    return (obj for obj in ch)
end

# This should be the only method to add nre documents
# It updates all sort of stuff
function add_sec!(doc::RBDoc, sec::RBSection)
    
    seclabel = get_label(sec)
    
    # Update stuff
    # obj labels
    add_objlabel!(sec)
    
    # add doc
    secs = sections(doc)
    push!(secs, seclabel => sec)
    
    return doc
end
