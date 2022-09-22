module DifferentialGeometry
    include("manifolds.jl")
    using .Manifolds
    export Ring, Torus, Cylinder, Sphere, Mobius, Plane, Line

    include("embeddings.jl")
    using .Embeddings
    export Embedding

    include("geometry.jl")
    export J, ∂φ∂x, 𝐈, 𝐈𝐈, normal, metric_deformation

    include("visuals.jl")
    export visualize_manifold

end
