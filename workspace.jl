import GLMakie

using DifferentialGeometry
using DifferentialGeometry.Embeddings
import DifferentialGeometry.Manifolds: sample

GLMakie.inline!(true)


m = DifferentialGeometry.Manifolds.Torus
φ = TorusEmbedding

γ = Curve(
    x -> [20π*x, 4π*x + 1]
    # x -> [2π*x, x]
)
γ = φ(γ; Δ=0.01)

N = φ(m; n=(24, 48))
# W = apply(m, normal, φ)




fig, ax = visualize_manifold(N...; color=nothing, cmap=:inferno, transparency=false)
# visualize_curve!(ax, γ...; transparency=true)


# ---------------------- visualize tangent vector field ---------------------- #
# P = sample(m; n=(12, 24), flat=true)
# tf = TangentVectorField(
#     P, (x) -> [sin(1-2x[1]), 0.0]
# ) |> φ
# visualize_tangent_vectorfield(ax, φ.(P), tf)



display(fig)
println("done")