import ForwardDiff: jacobian

# ---------------------------------------------------------------------------- #
#                                   EMBEDDING                                  #
# ---------------------------------------------------------------------------- #
abstract type AbstractEmbedding end


struct Embedding 
    name::String
    m::AbstractManifold
    n::AbstractManifold
    ϕ::Function

    function Embedding(name::String, m::AbstractManifold, n::AbstractManifold, ϕ::Function)

        phi(x) = ϕ(x)
        phi(x::Point) = Point(x.m, ϕ(x.p...))
        phi(x...) = ϕ(x...)
        new(name, m, n, phi)
    end
end

Base.string(e::Embedding) = "Embedding $(e.name): $(e.m.name) → $(e.n.name)"
Base.print(io::IO, e::Embedding) = print(io, string(e))
Base.show(io::IO, ::MIME"text/plain", e::Embedding) = print(io, string(e))


# ---------------------------- standard embeddings --------------------------- #

standard_R2_to_R3 = Embedding(
    "std. plane",
    R2, R3,
    (x, y) -> [x, y, x+y]
)


standard_sphere = Embedding(
    "std. sphere",
    S, R3,
    (θ₁, θ₂) -> [sin(θ₁)cos(θ₂), sin(θ₁)sin(θ₂), cos(θ₁)]
)


standard_torus = Embedding(
    "std. torus",
    T, R3,
    (θ₁, θ₂) -> begin
        R, r = 0.75, .25  # radii
        [(R + r * cos(θ₁)) * cos(θ₂), (R + r * cos(θ₁)) * sin(θ₂), r * sin(θ₁),]
    end
)



# ---------------------------------------------------------------------------- #
#                                     EMBED                                    #
# ---------------------------------------------------------------------------- #
function embed end

embed(p::Point, e::Embedding)::Point = Point(e.n, e.ϕ(p.p...))


function embed(fn::ParametrizedFunction, e::Embedding)::ParametrizedFunction 

    ŷ = map(p->embed(p, e), fn.y) |> collect

    n = embed(e.m, e)
    f̂ = n.ϕ ∘ e.ϕ ∘ fn.f

    ParametrizedFunction(
        fn.name * " embedded by $(e.name) in $(e.n.name)", 
        fn.domain, 
        e.n, 
        f̂, 
        fn.x,
        ŷ 
    )
end

function embed(g::ManifoldGrid, e::Embedding)::ManifoldGrid
    ManifoldGrid(
        map(f -> embed(f, e), g.v),
        map(f -> embed(f, e), g.h)
    )
end


function embed(m::Manifold, e::Embedding)::Manifold
    """ Embedding map """
    phi(x::Vector) = e.ϕ.(x...)
    phi(x::Vector{Point}) = e.ϕ.(x)
    phi(p::Point) = Point(m, e.ϕ(p.p...))
    
    # update maniofold embedding function
    ϕ = (phi ∘ m.ϕ)

    return Manifold(
        "$(m.name) embedded by $(e.name) in $(e.n.name)",
        m.domain,
        ϕ
    )
end


function embed(f::AbstractField, e::Embedding)::AbstractField
    fieldtype = typeof(f)
    fieldtype(
        f.name, 
        embed(f.m, e),  # embedding the mfld applies the pushforward to the vec
        f._ψ
    )
end





# ---------------------------------------------------------------------------- #
#                                  PUSHFORWARD                                 #
# ---------------------------------------------------------------------------- #
"""
    pushforward(p::Point, e::Embedding)::Matrix{Float64}

Get the pushforward of a manifold or embedding map ϕ at a point p ∈ M
"""
function pushforward(p::Point, e::Embedding)::Matrix{Float64}
    N = embed(p.m, e)  # get the embedding map N.ϕ
    jacobian(N.ϕ, p.p)
end


pushforward(m::Manifold, p::Vector{Float64}, e::Embedding)::Matrix{Float64} = pushforward(
    Point(m, p), e
)

"""
    pushforward(m::Manifold, p::Point)::Matrix{Float64}

If no embedding is given. assume the manifold is already embedded.
"""
pushforward(m::Manifold, p::Point)::Matrix{Float64} = jacobian(m.ϕ, p.p)
pushforward(p::Point)::Matrix{Float64} = pushforward(p.m, p)
pushforward(m::Manifold, p::Vector{Float64})::Matrix{Float64} = pushforward(m, Point(m, p))

