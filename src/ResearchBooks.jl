module ResearchBooks

    import TOML
    import BibTeX

    using FilesTreeTools
    using ArgParse
    using XMLDict
    using Dates
    using OrderedCollections

    # Re-exports
    export walkup, filterup
    export walkdown, filterdown

    include("Book/types.jl")
    include("Book/base.jl")
    include("Book/functional_interface.jl")
    
    export RBook
    export currdoc, currdoc!
    export currsec, currsec!
    export currbook, currbook!
    export new_document, new_section
    export add_section, add_note, add_pair, add_quote
    export find_bookdir, openbook
    
    include("Core/bookbib.jl")
    include("Core/crossref.jl")
    include("Core/git.jl")
    include("Core/open.jl")
    include("Core/configfile.jl")
    include("Core/utils.jl")

    export foreach_bibs, findall_bibs, findfirst_bibs

    include("ReadReport/dirtree.jl")
    include("ReadReport/create_read_report.jl")
    include("ReadReport/read_report.jl")

    include("Issues/dirtree.jl")
    include("Issues/issues.jl")

    # function __init__()
        
    # end

end # end module
