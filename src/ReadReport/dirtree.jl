# Functional Interface
_read_reports_dirname() = "ReadReports"
_read_reports_dir() = joinpath(bookdir(), _read_reports_dirname())

_rr_dir(refid::String) = joinpath(_read_reports_dir(), refid)
_rr_srcfile(refid::String) = joinpath(_rr_dir(refid), "entry.rb.jl")