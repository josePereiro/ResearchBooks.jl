_read_reports_dir() = joinpath(book_dir(), "ReadReports")

_rr_dir(refid::String) = joinpath(_read_reports_dir(), refid)
_rr_srcfile(refid::String) = joinpath(_rr_dir(refid), "src.txt")