import GLMakie

using DifferentialGeometry
using DifferentialGeometry.Embeddings
import DifferentialGeometry.Manifolds: sample
import LinearAlgebra: ⋅

GLMakie.inline!(true)
# GLMakie.activate!() # just in case

shape = (24, 48)


m = DifferentialGeometry.Manifolds.Sphere
φ = SphereEmbedding

N = φ(m; n=shape)




X = [1, 0]
Y = [1, 1]
W = []
for p in sample(m; n=shape)
    j = J(φ, p)
    # g = X' .* (𝐈(φ, p) * Y)
    g = (j*X)' * (j*Y)
    push!(W, g)
end
W = reshape(W, shape)

fig, ax = visualize_manifold(N...; color=W, cmap=:inferno, transparency=false)
display(fig)


println("done")

