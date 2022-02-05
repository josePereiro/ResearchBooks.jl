const _SHOW_LIMIT = 20

_values(od::OrderedDict) = od.vals # This might be unstable

function format_idkey(key)
    reg = Regex("[^A-Za-z0-9]")
    key = replace(key, reg => "_")
    return key
end