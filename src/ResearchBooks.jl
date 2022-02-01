module ResearchBooks

    import TOML
    import BibTeX
    using ArgParse
    using XMLDict
    using Dates

    export RBDoc, RBSection
    export load_bookbib, clear_bookbib_file
    export book_dir, bibtex_paths, open_user_config_file, source_config
    export book_relpath
    export create_read_report, read_report
    export find_section, sections_iders
    export docpath, get_ider, parent
    export hasider, hastype, get_link

    include("Core/bookbib.jl")
    include("Core/config.jl")
    include("Core/crossref.jl")
    include("Core/git.jl")
    include("Core/open.jl")
    include("Core/utils.jl")

    include("ReadReport/dirtree.jl")
    include("ReadReport/create_read_report.jl")
    include("ReadReport/read_report.jl")

    include("Issues/dirtree.jl")
    include("Issues/issues.jl")

    function __init__()
        source_config()
    end

end # end module
