## ------------------------------------------------------------------
macro new_quote!(ex...)
    label = _insert_label!("new_quote!", ex, __source__)
    _add_secobj!(() -> RBQuote(label), __source__)
end
