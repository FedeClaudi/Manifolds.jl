abstract type AbstractEmbedding end


struct Embedding 
    name::String
    m::AbstractManifold
    n::AbstractManifold
    ϕ::Function
end

Base.string(e::Embedding) = "Embedding $(e.name): $(e.m.name) → $(e.n.name)"
Base.print(io::IO, e::Embedding) = print(io, string(e))
Base.show(io::IO, ::MIME"text/plain", e::Embedding) = print(io, string(e))



""" Embed """
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
    # ensure all methods for the manifold embedding function exist
    if length(methods(e.ϕ, (Point, ))) < 1
        @eval begin
            $e.ϕ(x::Vector{Point}) = $e.ϕ.(x)
            # $e.ϕ(x::Vector{Float64}) = $e.ϕ(x...)
            $e.ϕ(p::Point) = Point($m, $e.ϕ(p.p...))
        end
    end
    
    # update maniofold embedding function
    ϕ = (e.ϕ ∘ m.ϕ)

    return Manifold(
        "$(m.name) embedded by $(e.name) in $(e.n.name)",
        m.domain,
        ϕ
    )
end
