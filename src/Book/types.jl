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
            meta::OrderedDict{Symbol, Any}
            data::OrderedDict{Symbol, Any}
        end

        function $(esc(name))()
            $(esc(name))(OrderedDict{Symbol, Any}(), OrderedDict{Symbol, Any}())
        end

        $(esc(:getmeta))(obj::$(esc(name))) = obj.meta
        $(esc(:getdata))(obj::$(esc(name))) = obj.data
    end
end

# mutable struct RBNote <: RBObject
#     meta::Dict
#     data::Dict
# end

# mutable struct RBPair{T} <: RBObject
#     sec
#     key::String
#     val::T
# end

# mutable struct RBQuote <: RBObject
#     sec
#     txt::String
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

