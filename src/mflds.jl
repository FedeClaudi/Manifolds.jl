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
_circle_domain = ClosedInterval(0, 2π)
_unit_domain = UnitInterval()


R = Manifold("ℝ", _unit_domain)
R2 = Manifold("ℝ²", _unit_domain × _unit_domain)
R3 = Manifold("ℝ³", _unit_domain × _unit_domain × _unit_domain)
C = Manifold("Circle", _circle_domain)
S = Manifold("Sphere", UnitSphere())  # TODO check domain works
Cy = Manifold("Cylinder", _circle_domain × _unit_domain)
T = Manifold("T ≃ C × C", _circle_domain × _circle_domain)


# ------------------------------- random sample ------------------------------ #
Base.rand(m::AbstractManifold, n::Int) = map(
    p -> Point(m, collect(p)), eachrow(rand(m.domain, n))
)

Base.rand(::UnitInterval, n::Int)::Vector{Float64} = rand(n)
Base.rand(::UnitCircle, n::Int)::Vector{Float64} = rand(n) * 2π
Base.rand(::UnitSquare, n::Int)::Matrix{Float64} = hcat(rand(n), rand(n))
Base.rand(::UnitSphere, n::Int)::Matrix{Float64} = hcat(rand(n), rand(n)) * 2π

# ---------------------------------- boundary ---------------------------------- #

boundary(::UnitInterval, n::Int)::Vector{Float64} = range(0.0, 1.0, length=n) |> collect
boundary(::UnitCircle, n::Int)::Vector{Float64} = range(0.0, 2π, length=n) |> collect
boundary(i::ClosedInterval, n::Int)::Vector{Float64} = range(leftendpoint(i), rightendpoint(i), length=n) |> collect
boundary(::UnitSquare, n::Int)::Matrix{Float64} = begin
    n = max((Int ∘ round)(n/4), 1)
    x = [range(0, 1, length=n)..., ones(n)..., range(1, 0, length=n)..., zeros(n)...]
    y = [zeros(n)..., range(0, 1, length=n)..., ones(n)..., range(1, 0, length=n)...]
    return hcat(x, y)
end
boundary(::UnitSphere, n::Int)::Matrix{Float64} = hcat(range(0.0, 1.0, length=n), range(0.0, 1.0, length=n)) * 2π

boundary(r::Rectangle, n::Int)::Matrix{Float64} = hcat(range(r.a[1], r.b[1], length=n), range(r.a[2], r.b[2], length=n))



# --------------------------------- boundary --------------------------------- #
boundary(m::Manifold, n::Int=24)::Vector{Point} = if dim(m) == 1
    map(p->Point(m, p), boundary(m.domain, n))
else
    map(p->Point(m, [p...]), eachrow(boundary(m.domain, n)))
end

# ------------------------------------ dim ----------------------------------- #
dim(m::Manifold)::Int = dim(m.domain)
dim(::UnitInterval)::Int = 1
dim(::UnitCircle)::Int = 1
dim(::ClosedInterval) = 1
dim(::UnitSquare)::Int = 2
dim(::UnitSphere)::Int = 2
dim(::Rectangle)::Int = 2

 
# ---------------------------------------------------------------------------- #
#                                     POINT                                    #
# ---------------------------------------------------------------------------- #
abstract type AbstractManifoldObject end

struct Point <: AbstractManifoldObject
    manifold::Manifold
    p::Vector{Float64}

    function Point(manifold::Manifold, p::Vector{Float64})
        if p isa Vector && (manifold.domain isa UnitInterval || manifold.domain isa ClosedInterval)
            @assert p[1] ∈ manifold.domain "Point $p out of manifold domain: $(manifold.domain)"
        else
            @assert p ∈ manifold.domain "Point $p out of manifold domain: $(manifold.domain)"
        end
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