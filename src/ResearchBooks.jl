# Inter book operations
# TODO: Link on run time two books
# USAGE: You could have a private and a public book (both in different repositories)
# TODO: This might introduce cooperation capabilities

# Include system
# TODO: Redo include system (make it lazy)
# NOTES: Make it includes the whole book (even with the multiple passes maybe) only if currbook() === nothing
# NOTES: The rest of the time just include the modified files
# NOTES: The user can always force the whole loading at any time.
# TODO: redo the API

# Tags
# TODO: Include tag alias (maybe, not sure)
# TODO: Include tag types
# TODO: Include tag parameters
# TODO: Creates a tag recommendation system.
# TODO: Create a parametrized tag system. Like IL5.
# TODO: Make tags insensitive to space (non alpha numeric) and case. Create standardization tool (detect tag variants).

# Filetree
# TODO: Add folder sorting capabilities (book -> Readreport -> :year -> :author)
# TODO: Abstract the concept of a Structured Folder

# To Remember
# TODO: Create a 'To Remember' tag and a system for interacting with Anki (or any other to remember app)

# TODOS
# TODO: make a todo report 

# Documments
# TODO: Revisit the doc stuctures (allow nested sections and sectionless documents)


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
    include("Book/RBNote.jl")
    include("Book/RBRef.jl")
    include("Book/RBTagMeta.jl")
    include("Book/RBRefList.jl")
    include("Book/utils.jl")
    
    export RBook, RBDoc, RBSection
    export RBObject
    export RBQuote, RBParagraph, RBNote
    export RBRef, RBRefList
    export RBTagMeta
    export refdict, getproperty
    export eachdoc, eachobj, eachtagmeta
    export tagmetas, objlabels
    export get_book, bookdir, get_label, localpath, localrelpath
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
    include("FunctionalInterface/RBTagMeta_macros.jl")
    include("FunctionalInterface/RBQuote_macros.jl")
    include("FunctionalInterface/RBNote_macros.jl")
    include("FunctionalInterface/RBParagraph_macros.jl")
    include("FunctionalInterface/newobj_macros.jl")
    include("FunctionalInterface/setmeta_macros.jl")
    include("FunctionalInterface/utils.jl")
    include("FunctionalInterface/show.jl")
    include("FunctionalInterface/filesys.jl")
    include("FunctionalInterface/tag_report.jl")
    
    export currdoc, currdoc!
    export currsec, currsec!
    export currobj, currobj!
    export currbook, currbook!
    export bookdir, srcline, srcfile
    export is_ipass0, is_ipass1, is_ipass2, get_ipass
    export genlabel, @genlabel!
    export openbook, @openbook
    export @new_document!, @new_section!
    export @new_paragraph!, @new_quote!, @new_note!
    export @setproperty!, @set_title!, @set_doi!, @set_text!
    export @set_author!, @set_year!, @set_bibkey!, @set_abstract!
    export @set_ctime!
    export @add_tag!, @add_todo!
    export @new_tagmeta!, @set_similars!, @set_antagonists!, @set_description!, @set_supertag!
    export show_tags
    export show_tag_report, @report
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
