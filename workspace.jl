using Manifolds
using Term
install_term_logger()
install_term_repr()

using Plots
plotly()


# TODO Embedding: check for dimensionality match
# TODO ensure embedded fn are typed

# TODO parameterized function check signature
# TODO parametrized function give good errors

# TODO allow for different sampling density in each direction
# TODO sampling -> scale by domain's extent for uniform sampling


# TODO fix plot(ϕ(T))

import Manifolds: standard_torus


ϕ(x) = embed(x, standard_torus)

vf = VectorField(
    "v", T, (x, y) -> [1, sin(y)]
)


p = plot(xlim=[-1, 1], ylim=[-1, 1], zlim=[-1, 1])
plot!(ϕ(ManifoldGrid(T, (100, 4))), label=nothing)

plotvfield(ϕ(vf), (10, 20); vscale=.2)
p


