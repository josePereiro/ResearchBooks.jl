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
    include("Book/RBRef.jl")
    include("Book/RBRefs.jl")
    include("Book/utils.jl")
    
    export RBook, RBDoc, RBSection
    export RBObject, RBQuote, RBParagraph
    export RBRef, RBRefs
    export get_data, get_meta
    export eachobj
    export get_book, bookdir, get_label, get_path, get_relpath
    export get_doi, get_year, get_author, get_title, get_bibkey, get_tags
    export references
    
    include("FunctionalInterface/openbook.jl")
    include("FunctionalInterface/glob_state.jl")
    include("FunctionalInterface/getters.jl")
    include("FunctionalInterface/find.jl")
    # include("FunctionalInterface/markdown.jl")
    include("FunctionalInterface/replace_macros.jl")
    include("FunctionalInterface/genlabel.jl")
    include("FunctionalInterface/RBDoc_macros.jl")
    include("FunctionalInterface/RBSection_macros.jl")
    include("FunctionalInterface/RBQuote_macros.jl")
    include("FunctionalInterface/RBParagraph_macros.jl")
    include("FunctionalInterface/newobj_macros.jl")
    include("FunctionalInterface/setmeta_macros.jl")
    include("FunctionalInterface/getters.jl")
    include("FunctionalInterface/utils.jl")
    include("FunctionalInterface/filesys.jl")
    
    export currdoc, currdoc!
    export currsec, currsec!
    export currobj, currobj!
    export currbook, currbook!
    export bookdir, srcline, srcfile
    export is_ipass0, is_ipass1, is_ipass2, get_ipass
    export genlabel, @genlabel!
    export openbook, @openbook
    export @new_document!, @new_section!
    export @new_paragraph!, @new_quote!
    export @set_meta!, @set_title!, @set_doi!, @set_text!
    export @set_author!, @set_year!, @set_bibkey!, @set_abstract!
    export @add_tag!, @add_read!
    # export @create_doc_readme
    
    export bookbib, findall_bookbib, findfirst_bookbib, filter_bookbib
    export crossrefs, findall_crossrefs, findfirst_crossrefs, filter_crossrefs
    export find_obj, filter_book
    
    
    include("Core/bookbib.jl")
    include("Core/crossref.jl")
    include("Core/git.jl")
    include("Core/open.jl")
    include("Core/configfile.jl")
    include("Core/rbfiles.jl")
    include("Core/utils.jl")

    

    include("ReadReport/dirtree.jl")
    include("ReadReport/create_read_report.jl")

    export create_read_report

    # include("Issues/dirtree.jl")
    # include("Issues/issues.jl")

end # end module
