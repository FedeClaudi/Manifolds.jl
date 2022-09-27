module Manifolds
    using DomainSets
    using DomainSets: ×
    import Base.Iterators: product

    import DifferentialGeometry: flatten

    export Ring, Torus, Cylinder, Sphere, Mobius, Plane, Line
    export AbstractManifold, DomainManifold, ChartManifold
    export apply


    # ---------------------------------------------------------------------------- #
    #                                 ABSTRACT MFLD                                #
    # ---------------------------------------------------------------------------- #

    abstract type AbstractManifold end

    """
        DomainManifold

    Manifolds defined by a domain (that can be 
    embedded in ℝⁿ)
    """
    abstract type DomainManifold <: AbstractManifold end


    # ---------------------------------------------------------------------------- #
    #                               DOMAIN MANIFOLDS                               #
    # ---------------------------------------------------------------------------- #




    struct Manifold <: DomainManifold
        name::String
        d::Int          # intrinsic dimensionality
        Ω::Union{Domain, Interval}       # ⊆ ℝᵈ

        Manifold(name::String, Ω::Union{Domain, Interval}) = new(name, d(Ω), Ω)
    end

    Base.string(m::Manifold) = "$(m.name) (d=$(m.d))"
    Base.print(io::IO, m::Manifold) = print(io, string(m))
    Base.show(io::IO, ::MIME"text/plain", m::Manifold) = print(io, m)


    """
        apply(m::DomainManifold, f::Function, args...)

    Apply a function `f` to each point `x` sampled from a manifold `m`.
    """
    function apply(m::DomainManifold, f::Function, args...)
        M = sample(m)
        [f(args..., p) for p in M]
    end
    

    # ---------------------------------------------------------------------------- #
    #                               DOMAIN OPERATIONS                              #
    # ---------------------------------------------------------------------------- #
    """ get dimensionality of an obejct """
    function d end
    d(::Interval) = 1
    d(::Rectangle) = 2

    """ sample an interval """
    function sample end
    function sample(i::Interval, n=100)::AbstractVector
        range(leftendpoint(i), rightendpoint(i), length=n) |> collect
    end

    function sample(d::Rectangle; n=100)::Vector{Vector}
        Ω = components(d)
        N = n isa Int ? repeat([n], length(Ω)) : n
        [sample(ω, n) for (ω, n) in zip(Ω, N)]
    end
    
    function sample(m::DomainManifold; n=64, flat = false)::Union{Matrix, Vector}
        pts = collect.(product(sample(m.Ω; n=n)...) |> collect)
        flat || return pts
        return flatten(pts)
    end


    # ------------------------------------ 1D ------------------------------------ #
    Ring = Manifold(
        "Ring", (0..2π)
    )

    Line = Manifold(
        "Line", (0..1)
    )

    # ------------------------------------ 2D ------------------------------------ #
    Plane = Manifold(
        "Plane", (0..1)×(0..1)
    )

    Torus = Manifold(
        "Torus", (-π..π)×(-π..π)
    )

    Sphere = Manifold(
        "Sphere", (-π..π)×(-π/2..π/2)
    )

    Cylinder = Manifold(
        "Cylinder", (-π..π)×(0..1)
    )

    Mobius = Manifold(
        "Mobius", (-π..π)×(0..1)
    )


    # ---------------------------------------------------------------------------- #
    #                                CHART MANIFOLDS                               #
    # ---------------------------------------------------------------------------- #

    """
        ChartManifold

    Map defined by charts and chart transition maps
    """
    abstract type ChartManifold  <: AbstractManifold end

end