## ------------------------------------------------------------------
# Meta

getsec(q::RBQuote) = getparent(q)
setsec!(q::RBQuote, sec::RBSection) = setparent!(q, sec)

## ------------------------------------------------------------------
gettxt(q::RBQuote) = getdata(q, :txt, "")
settxt!(q::RBQuote, txt::String) = setdata!(q, :txt, txt)

## ------------------------------------------------------------------
# show
function Base.show(io::IO, q::RBQuote)
    println(io, "RBQuote")
    println("label: \"", getlabel(q), "\"")
    print("txt:\n\"", gettxt(q), "\"")
end

