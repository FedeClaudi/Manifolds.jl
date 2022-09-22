using DifferentialGeometry
using DomainSets

using DifferentialGeometry.Embeddings
import DifferentialGeometry.Manifolds: sample

m = Torus
φ = TorusEmbedding

N = φ(m)
visualize_manifold(N...)
