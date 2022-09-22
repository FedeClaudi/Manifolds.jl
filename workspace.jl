import GLMakie

using DifferentialGeometry
using DifferentialGeometry.Embeddings

GLMakie.inline!(true)


m = Torus
φ = TorusEmbedding


N = φ(m)


W = apply(m, x3, φ)


visualize_manifold(N...; color=W, cmap=:bwr)
