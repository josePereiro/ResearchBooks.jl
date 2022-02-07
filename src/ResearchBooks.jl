module ResearchBooks

    import TOML
    import BibTeX
    import JSON
    import StringRepFilter

    using FilesTreeTools
    using ArgParse
    using Dates
    using OrderedCollections

    # Re-exports
    export walkup, filterup
    export walkdown, filterdown

    include("Book/types.jl")
    include("Book/RBItem.jl")
    include("Book/RBSection.jl")
    include("Book/RBDoc.jl")
    include("Book/RBook.jl")
    include("Book/RBNote.jl")
    include("Book/RBPair.jl")
    include("Book/RBQuote.jl")
    include("Book/RBTagLine.jl")
    include("Book/RBRefs.jl")
    include("Book/RBRef.jl")
    include("Book/filesys.jl")
    include("Book/rbfiles.jl")
    include("Book/openbook.jl")
    include("Book/glob_state.jl")
    include("Book/markdown.jl")
    include("Book/utils.jl")
    
    export RBook, RBDoc, RBSection
    export RBItem, RBNote, RBPair, RBQuote, RBTagLine
    export currdoc, currdoc!
    export currsec, currsec!
    export currbook, currbook!
    export new_document!, new_section!
    export add_section!, add_note!, add_pair!, add_quote!
    export find_bookdir, seclink
    export openbook, @openbook
    export @create_doc_readme
    export getdoi, getyear, getauthor, gettitle
    export references
    
    include("Core/mtime.jl")
    include("Core/bookbib.jl")
    include("Core/crossref.jl")
    include("Core/git.jl")
    include("Core/open.jl")
    include("Core/configfile.jl")
    include("Core/find_match.jl")
    include("Core/utils.jl")

    export bookbib, findall_bookbib, findfirst_bookbib, filter_bookbib
    export crossrefs, findall_crossrefs, findfirst_crossrefs, filter_crossrefs
    

    include("ReadReport/dirtree.jl")
    include("ReadReport/create_read_report.jl")
    include("ReadReport/read_report.jl")

    include("Issues/dirtree.jl")
    include("Issues/issues.jl")

    # function __init__()
        
    # end

end # end module
