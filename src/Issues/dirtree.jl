# Functional Interface
_issues_dir() = joinpath(bookdir(), "Issues")

_issue_file(refid::String) = joinpath(_read_reports_dir(), string(refid, ".txt"))