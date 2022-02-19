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
            # label::String # labels are unmutable
            props::Dict{Symbol, Any}

            function $(esc(name))(label::String)
                # new(label, Dict{Symbol, Any}())
                obj = new(Dict{Symbol, Any}())
                obj.label = label
                return obj
            end

            $(esc(name))() = $(esc(name))("")

        end

        # RBObject Interface
        # $(esc(:get_label))(obj::$(esc(name))) = getfield(obj, :label)
        $(esc(:_get_properties))(obj::$(esc(name))) = getfield(obj, :props)
    end
end

## ------------------------------------------------------------------
# Items
@RBObject RBQuote
@RBObject RBParagraph
@RBObject RBRef
@RBObject RBRefList
@RBObject RBSymLink

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

