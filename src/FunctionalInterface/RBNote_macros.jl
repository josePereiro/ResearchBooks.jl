## ------------------------------------------------------------------
macro new_note!(ex...)
    label = _insert_label!("new_note!", ex, __source__)
    _add_secobj!(() -> RBNote(label), __source__)
end
