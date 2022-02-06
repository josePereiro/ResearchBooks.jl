sparent(i::RBItem) = i.sec
bookdir(s::RBItem) = bookdir(parent(s))
dockey(i::RBItem) = dockey(parent(i))