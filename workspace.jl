import GLMakie

using DifferentialGeometry
using DifferentialGeometry.Embeddings

GLMakie.inline!(true)


m = DifferentialGeometry.Manifolds.Sphere
φ = SphereEmbedding

γ = Curve(
    # x -> [2π*x, 4π*x + 1]
    x -> [2π*x, x]
)
γ = φ(γ; Δ=-0.01)

N = φ(m)
W = apply(m, normal, φ)


fig, ax = visualize_manifold(N...; color=nothing, cmap=:inferno, transparency=false)
visualize_curve!(ax, γ...; transparency=true)

display(fig)
println("done")