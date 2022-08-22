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
    f̂ = e.ϕ ∘ fn.f
    ParametrizedFunction(
        fn.name * " embedded by $(e.name) in $(e.n.name)", 
        fn.domain, 
        e.n, 
        f̂, 
        fn.x,
        ŷ
    )
end

