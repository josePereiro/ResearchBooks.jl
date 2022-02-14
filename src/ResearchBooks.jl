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
    include("Book/RBParagraph.jl")
    include("Book/RBQuote.jl")
    include("Book/RBRefs.jl")
    include("Book/RBRef.jl")
    include("Book/utils.jl")
    
    export RBook, RBDoc, RBSection
    export RBObject, RBNote, RBPair, RBQuote, RBTagLine
    export RBRef, RBRefs
    export get_book, bookdir, get_label
    export @create_doc_readme
    export get_doi, getyear, getauthor, get_title
    export references
    
    include("FunctionalInterface/openbook.jl")
    include("FunctionalInterface/glob_state.jl")
    # include("FunctionalInterface/markdown.jl")
    include("FunctionalInterface/replace_macros.jl")
    include("FunctionalInterface/genlabel.jl")
    include("FunctionalInterface/RBDoc_macros.jl")
    include("FunctionalInterface/RBSection_macros.jl")
    include("FunctionalInterface/RBQuote_macros.jl")
    include("FunctionalInterface/RBParagraph_macros.jl")
    include("FunctionalInterface/newobj_macros.jl")
    include("FunctionalInterface/setmeta_macros.jl")
    include("FunctionalInterface/utils.jl")
    include("FunctionalInterface/filesys.jl")
    
    export currdoc, currdoc!
    export currsec, currsec!
    export currobj, currobj!
    export currbook, currbook!
    export bookdir, srcline, srcfile
    export is_ipass0, is_ipass1, is_ipass2, get_ipass
    export @genlabel!
    export openbook, @openbook
    export @new_document!, @new_section!
    export @new_paragraph!, @new_quote!
    export @set_meta!, @set_title!, @set_doi!, @set_text!
    export @set_author!, @set_year!, @set_bibkey!, @set_abstract!
    export @add_tag!, @add_read!

    
    include("Core/bookbib.jl")
    include("Core/crossref.jl")
    include("Core/git.jl")
    include("Core/open.jl")
    include("Core/configfile.jl")
    include("Core/rbfiles.jl")
    include("Core/utils.jl")

    export bookbib, findall_bookbib, findfirst_bookbib, filter_bookbib
    export crossrefs, findall_crossrefs, findfirst_crossrefs, filter_crossrefs
    export @genlabel
    

    # include("ReadReport/dirtree.jl")
    # include("ReadReport/create_read_report.jl")
    # include("ReadReport/read_report.jl")

    # include("Issues/dirtree.jl")
    # include("Issues/issues.jl")

end # end module
