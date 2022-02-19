## ----------------------------------------------------------------------------
# RBook

function find_obj(label0)
    book = currbook()
    for obj in eachobj(book)
        (get_label(obj) == label0) && return obj
    end
    return nothing
end

filter_book(qp, qps...) = filter_match(eachobj(currbook()), qp, qps...)

## ----------------------------------------------------------------------------
# bookbib
findall_bookbib(qp, qps...) = _findall_bookbib(bookdir(), qp, qps...)
findfirst_bookbib(qp, qps...) = _findfirst_bookbib(bookdir(), qp, qps...)
filter_bookbib(qp, qps...) = _filter_bookbib(bookdir(), qp, qps...)

## ----------------------------------------------------------------------------
# crossrefs
function findall_crossrefs(qp, qps...) 
    vec = references(crossrefs())
    findall_match(vec, qp, qps...)
end

function findfirst_crossrefs(qp, qps...) 
    vec = references(crossrefs())
    ret = findfirst_match(vec, qp, qps...)
    isnothing(ret) ? ret : last(ret)
end

function filter_crossrefs(qp, qps...)
    vec = references(crossrefs())
    filter_match(vec, qp, qps...)
end
