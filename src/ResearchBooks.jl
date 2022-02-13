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
    include("Book/RBObject.jl")
    include("Book/RBDoc.jl")
    include("Book/RBSection.jl")
    include("Book/RBook.jl")
    # include("Book/RBNote.jl")
    # include("Book/RBPair.jl")
    include("Book/RBQuote.jl")
    # include("Book/RBTagLine.jl")
    # include("Book/RBRefs.jl")
    # include("Book/RBRef.jl")
    include("Book/utils.jl")
    
    export RBook, RBDoc, RBSection
    export RBObject, RBNote, RBPair, RBQuote, RBTagLine
    export getbook, bookdir, getlabel
    export @create_doc_readme
    export getdoi, getyear, getauthor, gettitle
    export references
    
    include("FunctionalInterface/openbook.jl")
    include("FunctionalInterface/glob_state.jl")
    # include("FunctionalInterface/markdown.jl")
    include("FunctionalInterface/replace_marcos.jl")
    include("FunctionalInterface/new_document.jl")
    include("FunctionalInterface/new_section.jl")
    include("FunctionalInterface/new_quote.jl")
    include("FunctionalInterface/setmeta.jl")
    include("FunctionalInterface/utils.jl")
    
    export currdoc, currdoc!
    export currsec, currsec!
    export currobj, currobj!
    export currbook, currbook!
    export bookdir
    export is_ipass0, is_ipass1, is_ipass2, get_ipass
    export @genlabel!, @new_document!, @new_quote!
    export @setmeta!, @new_section!, @settitle!, @setdoi!, @settxt!
    export openbook, @openbook

    
    include("Core/filesys.jl")
    include("Core/bookbib.jl")
    include("Core/crossref.jl")
    include("Core/git.jl")
    include("Core/open.jl")
    include("Core/configfile.jl")
    include("Core/rbfiles.jl")
    include("Core/utils.jl")

    # export bookbib, findall_bookbib, findfirst_bookbib, filter_bookbib
    # export crossrefs, findall_crossrefs, findfirst_crossrefs, filter_crossrefs
    # export genlabel
    

    # include("ReadReport/dirtree.jl")
    # include("ReadReport/create_read_report.jl")
    # include("ReadReport/read_report.jl")

    # include("Issues/dirtree.jl")
    # include("Issues/issues.jl")

end # end module
