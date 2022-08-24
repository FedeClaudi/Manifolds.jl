module Manifolds

include("mflds.jl")
include("fields.jl")
include("embeddings.jl")

include("viz.jl")
include("utils.jl")

export Manifold, Point, ParametrizedFunction, boundary, ManifoldGrid
export R, R2, R3, C, S, Cy, T, largeR
export Embedding, embed
export ScalarField

end
