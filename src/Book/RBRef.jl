## ------------------------------------------------------------------
# Accessors
refdict(r::RBRef) = r.dict
bibkey(r::RBRef) = r.bibkey
getauthor(r::RBRef) = r.author
getyear(r::RBRef) = r.year
gettitle(r::RBRef) = r.title
getdoi(r::RBRef) = r.doi

