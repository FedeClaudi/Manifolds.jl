using Manifolds

# TODO dim(m::Manifold)
# TODO Embedding: check for dimensionality match



f = ParametrizedFunction("test", R2, (t) -> [t, t])


e = Embedding("R2 rot", R2, R2, (x, y) -> [.5x*.5y, x])

embed(f, e)