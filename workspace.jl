import GLMakie

using DifferentialGeometry
using DifferentialGeometry.Embeddings
import DifferentialGeometry.Manifolds: sample

GLMakie.inline!(true)


m = Torus
φ = TorusEmbedding

N = φ(m)
visualize_manifold(N...)
