using Manifolds
using Term
install_term_logger()
install_term_repr()

using Plots
plotly()


# TODO Embedding: check for dimensionality match
# TODO ensure embedded fn are typed

# TODO parameterized function check signature
# TODO paramtrized function give good errors

# TODO allow for different sampling density in each direction

# TODO figure out how to plot arrows in 3D


import Manifolds: standard_torus


ϕ(x) = embed(x, standard_torus)

vf = VectorField(
    "v", T, (x, y) -> [0, sin(y)]
)


p = plot(xlim=[-1, 1], ylim=[-1, 1], zlim=[-1, 1])
plot!(ϕ(ManifoldGrid(T, 40)), label=nothing)

plotvfield(ϕ(vf), 40; vscale=.2)
p

# TODO fix torus squished
# TODO move vfield vecs pushforward to embedding func
