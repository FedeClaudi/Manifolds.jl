module DifferentialGeometry
    include("utils.jl")

    include("manifolds.jl")
    using .Manifolds
    export Ring, Torus, Cylinder, Sphere, Mobius, Plane, Line
    export apply, sample

    include("curves.jl")
    export Curve

    include("tangentvectors.jl")
    using .TangentVectors: TangentVector
    export TangentVector

    include("embeddings.jl")
    using .Embeddings
    export Embedding

    include("geometry.jl")
    export J, ∂φ∂x, 𝐈, 𝐈𝐈, normal, metric_deformation, area_deformation
    export u1, u2, u3, x1, x2, x3

    include("visuals.jl")
    export visualize_manifold, visualize_curve!, visualize_tangent_vector

end
