import Term.Style: apply_style
using DomainSets
import DomainSets: ×, components


identity(x) = x

# ---------------------------------------------------------------------------- #
#                                   MANIFOLD                                   #
# ---------------------------------------------------------------------------- #

abstract type AbstractManifold end

struct Manifold <: AbstractManifold 
    name::String
    domain::Domain
    ϕ::Function  # map applied to points (e.g. for embedded mflds)
end

Manifold(name::String, domain::Domain) = Manifold(name, domain, identity)

Base.string(m::AbstractManifold) = "Manifold: $(m.name)"
Base.print(io::IO, m::AbstractManifold) = print(io, string(m))
Base.show(io::IO, ::MIME"text/plain", m::AbstractManifold) = print(io, string(m))


# --------------------------------- manifolds -------------------------------- #
_circle_domain = ClosedInterval(0, 2π)
_unit_domain = UnitInterval()


R = Manifold("ℝ", _unit_domain)
R2 = Manifold("ℝ²", _unit_domain × _unit_domain)
R3 = Manifold("ℝ³", _unit_domain × _unit_domain × _unit_domain)
largeR = Manifold("LargeR", ClosedInterval(-5, 5) × ClosedInterval(-5, 5))
C = Manifold("Circle", _circle_domain)
S = Manifold("Sphere", _circle_domain × ClosedInterval(0, π))  # TODO check domain works
Cy = Manifold("Cylinder", _circle_domain × _unit_domain)
T = Manifold("T ≃ C × C", _circle_domain × _circle_domain)


# ------------------------------- random sample ------------------------------ #
Base.rand(m::AbstractManifold, n::Int) = map(
    p -> Point(m, collect(p)), eachrow(rand(m.domain, n))
) |> m.ϕ

Base.rand(::UnitInterval, n::Int)::Vector{Float64} = rand(n) |> m.ϕ
Base.rand(::UnitCircle, n::Int)::Vector{Float64} = rand(n) * 2π |> m.ϕ
Base.rand(::UnitSquare, n::Int)::Matrix{Float64} = hcat(rand(n), rand(n)) |> m.ϕ

# ---------------------------------- boundary ---------------------------------- #

""" 
Sample points on a boundary of a manifold's domain
"""
function  boundary end

"""
Sample boundary for a 1-2 dimensional manifold
"""
boundary(m::Manifold, n::Int)::Vector{Point} = if dim(m) == 1
        map(p->Point(m, p), boundary(m.domain, n))  |> collect
    else
        map(p->Point(m, [p...]), eachrow(boundary(m.domain, n)))  |> collect
    end |> m.ϕ

"""
Sample boundary along one dimension of a two dimensional boundary
"""
boundary(m::Manifold, n::Int, d::Int)::Vector{Point} = if dim(m) == 1
    map(p->Point(m, p), boundary(m.domain, n)) |> collect
else
    map(p->Point(m, [p...]), eachrow(boundary(m.domain, n, d))) |> collect
end |> m.ϕ



""" sample boundary on domain intervals """
boundary(::UnitInterval, n::Int)::Vector{Float64} = range(0.0, 1.0, length=n) |> collect
boundary(i::ClosedInterval, n::Int)::Vector{Float64} = range(leftendpoint(i), rightendpoint(i), length=n) |> collect


boundary(::UnitSquare, n::Int)::Matrix{Float64} = begin
    n = max((Int ∘ round)(n/4), 2)
    x = [range(0, 1, length=n)..., ones(n)..., range(1, 0, length=n)..., zeros(n)...]
    y = [zeros(n)..., range(0, 1, length=n)..., ones(n)..., range(1, 0, length=n)...]
    return hcat(x, y)
end

function boundary(::UnitSquare, n::Int, d::Int)::Matrix{Float64}
    if d == 1
        x = range(0, 1, length=n)
        y = zeros(n)
    elseif d == 2
        x = ones(n)
        y = range(0, 1, length=n)
    else
        throw("Invalid d: $d")
    end
    return hcat(x, y)
end

boundary(r::Rectangle, n::Int)::Matrix{Float64} = begin
    n = max((Int ∘ round)(n/4), 1)
    xcomp, ycomp = components(r)
    _x, _y = boundary(xcomp, n), boundary(ycomp, n)
    x = [_x..., repeat([_x[end]], n)..., reverse(_x)..., repeat([_x[1]], n)... ]
    y = [repeat([_y[1]], n)..., _y..., repeat([_y[end]], n)..., reverse(_y)...]
    return hcat(x, y)
end

function boundary(r::Rectangle, n::Int, d::Int)::Matrix{Float64}
    xcomp, ycomp = components(r)
    _x, _y = boundary(xcomp, n), boundary(ycomp, n)
    if d  == 1
        x, y = _x, repeat([_y[1]], n)
    elseif d == 2
        x, y = repeat([_x[end]], n), _y
    else
        throw("Invalid d: $d")
    end
    return hcat(x, y)
end




# ------------------------------------ dim ----------------------------------- #

""" Intrinsic dimensionality """
function dim end
dim(m::Manifold)::Int = dim(m.domain)
dim(::UnitInterval)::Int = 1
dim(::UnitCircle)::Int = 1
dim(::ClosedInterval) = 1
dim(::UnitSquare)::Int = 2
dim(::UnitSphere)::Int = 2
dim(::Rectangle)::Int = 2

""" Extrinsic dimensionality """
function extdim end
extdim(m::Manifold) = length(Point(R, repeat([0], dim(m))) |> m.ϕ)


# ---------------------------------------------------------------------------- #
#                                    min/max                                   #
# ---------------------------------------------------------------------------- #
Base.min(m::Manifold)::Vector{Float64} = boundary(m, 2)[1].p
Base.max(m::Manifold)::Vector{Float64} = boundary(m, 2)[end].p
Base.min(m::Manifold, d::Int)::Float64 = boundary(m, 2, d)[1].p[d]
Base.max(m::Manifold, d::Int)::Float64 = boundary(m, 2, d)[end].p[d]

 
# ---------------------------------------------------------------------------- #
#                                     POINT                                    #
# ---------------------------------------------------------------------------- #
abstract type AbstractManifoldObject end

struct Point <: AbstractManifoldObject
    manifold::Manifold
    p::Vector{Float64}
end

Point(m::Manifold, p::Float64) = Point(m, [p])

dim(p::Point) = length(p.p)

Base.string(p::Point) = "$(p.p) - p ∈ $(p.manifold.name)"
Base.print(io::IO, p::Point) = print(io, string(p))
Base.show(io::IO, ::MIME"text/plain", p::Point) = print(io, string(p))
Base.length(p::Point) = length(p.p)
Base.:*(x::Number, p::Point) = x*p.p
function Base.:+(p::Point, x::Vector{Float64})
    @assert length(p.p)==length(x) "Dimension mismatch"
    return Point(p.manifold, p.p + x)
end
Base.:+(x::Vector{Float64}, p::Point) = p + x



# ---------------------------------------------------------------------------- #
#                                 PARAM. FUNC.                                 #
# ---------------------------------------------------------------------------- #

"""
Parametrized function on a manifold.

Function from a domain D → 𝓜.
Functions f are maps from a point p ∈ D to a point f(p) ∈ 𝓜.
If f(p) is outisde of 𝓜 an error is given.

"""
struct ParametrizedFunction <: AbstractManifoldObject
    name::String
    domain::Domain
    m::AbstractManifold
    f::Function
    x::Vector
    y::Vector{Point}
end

ParametrizedFunction(name::String, m::AbstractManifold, f::Function)::ParametrizedFunction = ParametrizedFunction(name, UnitInterval(), m, f)

function ParametrizedFunction(name::String, domain::Domain, m::Manifold, f::Function)
    p = 0:.05:1
    x0 = collect([leftendpoint(domain)...])
    x1 = collect([rightendpoint(domain)...])
    x = @. x0 * p + x1 * (1 - p)
    y = f.(x) |> m.ϕ

    return ParametrizedFunction(name, domain, m, f, x, map(p -> Point(m, p), y))
end

Base.string(pf::ParametrizedFunction) = "func.{bold white}'$(pf.name)'{/bold white} in $(pf.m.name): {dim}$(pf.domain) → $(pf.m.domain)" |> apply_style
Base.print(io::IO, pf::ParametrizedFunction) = print(io, string(pf))
Base.show(io::IO, ::MIME"text/plain", pf::ParametrizedFunction) = print(io, string(pf))

dim(f::ParametrizedFunction) = dim(f.y[1])

# ---------------------------------------------------------------------------- #
#                                 MANIFOLD GRID                                #
# ---------------------------------------------------------------------------- #

struct ManifoldGrid <: AbstractManifoldObject
    v::Vector{ParametrizedFunction}
    h::Vector{ParametrizedFunction}
end

Base.string(pf::ManifoldGrid) = "ManifoldGrid" 
Base.print(io::IO, pf::ManifoldGrid) = print(io, string(pf))
Base.show(io::IO, ::MIME"text/plain", pf::ManifoldGrid) = print(io, string(pf))

dim(g::ManifoldGrid) = dim(g.v[1])

function ManifoldGrid(m::Manifold, n=10)
    x0, x1 = min(m,1), max(m, 2)
    y0, y1 = min(m, 1), max(m, 2)

    px(t) = t*x0 + (1-t)*x1
    py(t) = t*y0 + (1-t)*y1


    v = map(
        i -> ParametrizedFunction(
            "v:$(i[1])", m, t -> Float64[i[2].p[1], px(t)]
        ),
        enumerate(boundary(m, n, 1))
    )

    h = map(
        i -> ParametrizedFunction(
            "h:$(i[1])", m, t -> Float64[py(t), i[2].p[2]]
        ),
        enumerate(boundary(m, n, 2))
    )

    return ManifoldGrid(v, h)
end