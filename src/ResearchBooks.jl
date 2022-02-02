module ResearchBooks

    import TOML
    import BibTeX

    using FilesTreeTools
    using ArgParse
    using XMLDict
    using Dates

    # Re-exports
    export walkup, filterup
    export walkdown, filterdown

    include("Book/types.jl")
    include("Book/base.jl")
    include("Book/functional_interface.jl")
    
    export currdoc, currdoc!
    export currsec, currsec!
    export currbook, currbook!
    export new_document
    export openbook
    
    include("Core/bookbib.jl")
    include("Core/crossref.jl")
    include("Core/git.jl")
    include("Core/open.jl")
    include("Core/user_config.jl")
    include("Core/utils.jl")

    export open_user_config_file

    include("ReadReport/dirtree.jl")
    include("ReadReport/create_read_report.jl")
    include("ReadReport/read_report.jl")

    include("Issues/dirtree.jl")
    include("Issues/issues.jl")

    # function __init__()
        
    # end

end # end module
