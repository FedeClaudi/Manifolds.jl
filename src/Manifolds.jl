module Manifolds

include("mflds.jl")
include("embeddings.jl")
include("viz.jl")

export Manifold, Point, ParametrizedFunction, sample, boundary
export R, R2, R3, C, S, Cy, T

export Embedding, embed

end
