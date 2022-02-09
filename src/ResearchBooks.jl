module ResearchBooks

    import TOML
    import BibTeX
    import JSON
    import Random: randstring

    using ArgParse
    using Dates
    using OrderedCollections
    using EasyEvents
    
    # Re-exports
    using Reexport
    @reexport using FilesTreeTools
    @reexport using StringRepFilter

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
    include("Book/utils.jl")
    
    export RBook, RBDoc, RBSection
    export RBItem, RBNote, RBPair, RBQuote, RBTagLine
    export new_document!, new_section!
    export add_section!, add_note!, add_pair!, add_quote!
    export seclink
    export openbook, @openbook
    export @create_doc_readme
    export getdoi, getyear, getauthor, gettitle
    export references
    
    include("FunctionalInterface/openbook.jl")
    include("FunctionalInterface/glob_state.jl")
    include("FunctionalInterface/markdown.jl")
    include("FunctionalInterface/replace_marcos.jl")
    
    export currdoc, currdoc!
    export currsec, currsec!
    export currbook, currbook!
    export bookdir
    export @__GENKEY!__
    
    include("Core/filesys.jl")
    include("Core/mtime.jl")
    include("Core/bookbib.jl")
    include("Core/crossref.jl")
    include("Core/git.jl")
    include("Core/open.jl")
    include("Core/configfile.jl")
    include("Core/rbfiles.jl")
    include("Core/utils.jl")

    export bookbib, findall_bookbib, findfirst_bookbib, filter_bookbib
    export crossrefs, findall_crossrefs, findfirst_crossrefs, filter_crossrefs
    export genid
    

    include("ReadReport/dirtree.jl")
    include("ReadReport/create_read_report.jl")
    include("ReadReport/read_report.jl")

    include("Issues/dirtree.jl")
    include("Issues/issues.jl")

end # end module
