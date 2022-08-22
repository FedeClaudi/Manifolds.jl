import Term.Style: apply_style
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



# ---------------------------------- sample ---------------------------------- #
Base.rand(m::AbstractManifold, n::Int) = map(
    p -> Point(m, collect(p)), eachrow(rand(m.domain, n))
)

Base.rand(::UnitInterval, n::Int) = rand(n)
Base.rand(::UnitCircle, n::Int) = rand(n) * 2π
Base.rand(::UnitSquare, n::Int) = hcat(rand(n), rand(n))
Base.rand(::UnitSphere, n::Int) = hcat(rand(n), rand(n)) * 2π

 
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

Point(m::Manifold, p::Float64) = Point(m, [p])

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

Base.string(pf::ParametrizedFunction) = "func.{bold white}'$(pf.name)'{/bold white} in $(pf.m.name): {dim}$(pf.domain) → $(pf.m.domain)" |> apply_style
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