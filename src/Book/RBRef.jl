## ------------------------------------------------------------------
# Accessors
refdict(r::RBRef) = r.dict
bibkey(r::RBRef) = r.bibkey
getauthor(r::RBRef) = r.author
getyear(r::RBRef) = r.year
get_title(r::RBRef) = r.title
get_doi(r::RBRef) = r.doi

