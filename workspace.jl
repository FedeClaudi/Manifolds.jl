import GLMakie

using DifferentialGeometry
using DifferentialGeometry.Embeddings

GLMakie.inline!(true)


m = Torus
φ = TorusEmbedding


N = φ(m)
W = apply(m, area_deformation, φ)
visualize_manifold(N...; color=nothing, cmap=:inferno)
println("done")