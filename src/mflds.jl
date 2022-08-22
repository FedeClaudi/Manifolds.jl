
using DomainSets
import DomainSets: ×


# ---------------------------------------------------------------------------- #
#                                   MANIFOLD                                   #
# ---------------------------------------------------------------------------- #

abstract type AbstractManifold end


struct Manifold <: AbstractManifold 
    name::String
    domain::Domain
end

Base.string(m::AbstractManifold) = "Manifold: $(m.name)"
Base.print(io::IO, m::AbstractManifold) = print(io, string(m))
Base.show(io::IO, ::MIME"text/plain", m::AbstractManifold) = print(io, string(m))


# --------------------------------- manifolds -------------------------------- #
R = Manifold("ℝ", UnitInterval())
R2 = Manifold("ℝ²", UnitInterval() × UnitInterval())
C = Manifold("Circle", UnitCircle())
S = Manifold("Sphere", UnitSphere())
Cy = Manifold("Cylinder", UnitCircle() × UnitInterval())
T = Manifold("T ≃ C × C", UnitCircle() × UnitCircle())
 
# ---------------------------------------------------------------------------- #
#                                     POINT                                    #
# ---------------------------------------------------------------------------- #
abstract type AbstractManifoldObject end

struct Point <: AbstractManifoldObject
    manifold::Manifold
    p::Vector{Float64}
    function Point(manifold::Manifold, p::Vector{Float64})
        @assert p ∈ manifold.domain "Point $p out of manifold domain: $(manifold.domain)"
        new(manifold, p)
    end
end

Base.string(p::Point) = "$(p.p) - p ∈ $(p.manifold.name)"
Base.print(io::IO, p::Point) = print(io, string(p))
Base.show(io::IO, ::MIME"text/plain", p::Point) = print(io, string(p))




# ---------------------------------------------------------------------------- #
#                                 PARAM. FUNC.                                 #
# ---------------------------------------------------------------------------- #
struct ParametrizedFunction <: AbstractManifoldObject
    name::String
    domain::Domain
    m::AbstractManifold
    f::Function
    x::Vector
    y::Vector{Point}
end

Base.string(pf::ParametrizedFunction) = "func.'$(pf.name)' in $(pf.m.name): $(pf.domain) → $(pf.m.domain)"
Base.print(io::IO, pf::ParametrizedFunction) = print(io, string(pf))
Base.show(io::IO, ::MIME"text/plain", pf::ParametrizedFunction) = print(io, string(pf))


ParametrizedFunction(name::String, m::AbstractManifold, f::Function)::ParametrizedFunction = ParametrizedFunction(name, UnitInterval(), m, f)

function ParametrizedFunction(name::String, domain::Domain, m::Manifold, f::Function)
    p = 0:.05:1
    x0 = collect([leftendpoint(domain)...])
    x1 = collect([rightendpoint(domain)...])
    x = @. x0 * p + x1 * (1 - p)
    y = f.(x)

    return ParametrizedFunction(name, domain, m, f, x, map(p -> Point(m, p), y))
end