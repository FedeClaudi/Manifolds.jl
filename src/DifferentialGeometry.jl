module DifferentialGeometry

    include("manifolds.jl")
    using .Manifolds
    export Ring, Torus, Cylinder, Sphere, Mobius, Plane, Line

    include("embeddings.jl")
    using .Embeddings
    export Embedding

    include("visuals.jl")
    export visualize_manifold

end
