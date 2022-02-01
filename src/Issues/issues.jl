
# function read_issue(refid::String)
#     rrfile = _rr_srcfile(refid)
#     if !isfile(rrfile)
#         error("No report found!!!")
#     end
#     return read(rrfile, RBDoc)
# end