## ------------------------------------------------------------------
macro new_paragraph!(ex...)
    label = _insert_label!("new_paragraph!", ex, __source__)
    _add_secobj!(() -> RBParagraph(label), __source__)
end
