module Manifolds

"""
    pushforward

Compute the pushforward of a vector on 
an embedded manifold.

Defined here so that it's available to fields.jl.
"""
function pushforward end
ϕ̂ = pushforward

include("mflds.jl")
include("fields.jl")
include("embeddings.jl")

include("viz.jl")
include("utils.jl")

export Manifold, Point, ParametrizedFunction, boundary, ManifoldGrid
export R, R2, R3, C, S, Cy, T, largeR
export Embedding, embed
export ScalarField, VectorField, pushforward
export plotvfield
export Normal

end
