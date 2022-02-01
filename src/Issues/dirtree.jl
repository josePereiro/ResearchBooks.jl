_issues_dir() = joinpath(book_dir(), "Issues")

_issue_file(refid::String) = joinpath(_read_reports_dir(), string(refid, ".txt"))