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

        $(esc(:getmeta))(obj::$(esc(name))) = obj.meta
        $(esc(:getdata))(obj::$(esc(name))) = obj.data
        $(esc(:getlabel))(obj::$(esc(name))) = obj.label
    end
end

"""
    A Collection of RBObjects which share some metadata
"""
RBQuote

@RBObject RBQuote

# mutable struct RBNote <: RBObject
#     meta::Dict
#     data::Dict
# end

# mutable struct RBPair{T} <: RBObject
#     sec
#     key::String
#     val::T
# end

# mutable struct RBTagLine <: RBObject
#     sec
#     tags::Vector{String}
# end

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

