## ------------------------------------------------------------------
# RBObject

abstract type RBObject end

"""
    Generate a RBObject object subtype
"""
macro RBObject(name)
    isdefined(Main, name) && return :(nothing)
    return quote
        struct $(name) <: RBObject
            label::String
            meta::OrderedDict{Symbol, Any}
            data::OrderedDict{Symbol, Any}
        end

        function $(esc(name))(label::String)
            $(esc(name))(label, OrderedDict{Symbol, Any}(), OrderedDict{Symbol, Any}())
        end

        # RBObject Interface
        $(esc(:get_meta))(obj::$(esc(name))) = obj.meta
        $(esc(:get_data))(obj::$(esc(name))) = obj.data
        $(esc(:get_label))(obj::$(esc(name))) = obj.label
    end
end

## ------------------------------------------------------------------
# Items
@RBObject RBQuote
@RBObject RBParagraph

## ------------------------------------------------------------------
# Section

"""
    A Collection of RBObjects which share some metadata
"""
RBSection

@RBObject RBSection

## ------------------------------------------------------------------
# Doc

"""
    A Collection of Sections which share metadata
"""
RBDoc

@RBObject RBDoc

## ------------------------------------------------------------------
# Book

"""
    The top level object.
    A Collection of Docs which share metadata
"""
RBook

@RBObject RBook

