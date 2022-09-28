import GLMakie

using DifferentialGeometry
using DifferentialGeometry.Embeddings
import DifferentialGeometry.Manifolds: sample
import LinearAlgebra: ⋅

GLMakie.inline!(false)
# GLMakie.activate!() # just in case

shape = (48, 48)


m = DifferentialGeometry.Manifolds.Plane
φ = PlaneEmbedding
N = φ(m; n=shape)

# get metric beteween X, Y
X = [1, 0] # ∈ TₚM
Y = [1, 1]
W = apply(m, g, φ, X, Y; n=shape)
W = reshape(W, shape)

# define constant vector fields on m
tf_x = TangentVectorField(m, X) |> φ
tf_y = TangentVectorField(m, Y) |> φ


# visualize metric and vector fields
fig, ax = visualize_manifold(N...; color=W, cmap=:inferno, transparency=false)
visualize_tangent_vectorfield(ax, φ.(P), tf_x; lengthscale=0.02, linewidth=0.01, color=:red)
visualize_tangent_vectorfield(ax, φ.(P), tf_y; lengthscale=0.02, linewidth=0.01, color=:green)
display(fig)


println("done")

