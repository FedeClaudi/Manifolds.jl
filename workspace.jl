import GLMakie

using DifferentialGeometry
using DifferentialGeometry.Embeddings

GLMakie.inline!(true)


m = DifferentialGeometry.Manifolds.Torus
φ = TorusEmbedding

γ = Curve(
    x -> [20π*x, 4π*x + 1]
    # x -> [2π*x, x]
)
γ = φ(γ; Δ=0.01)

N = φ(m)
# W = apply(m, normal, φ)




fig, ax = visualize_manifold(N...; color=nothing, cmap=:inferno, transparency=false)
visualize_curve!(ax, γ...; transparency=true)


αs = [1, 1]
for p in sample(m; n=10)
    v = 

    visualize_tangent_vector(
        ax, TangentVector(p, [1, 0]), φ; normalize=true
    )
    visualize_tangent_vector(
        ax, TangentVector(p, [0, 1]), φ; color=:red, normalize=true
    )
end

#TODO vector field


display(fig)
println("done")