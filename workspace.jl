using Manifolds
using Term
install_term_logger()
install_term_repr()

using Plots
plotly()

# TODO make tests for functionality implemented so far
# TODO Embedding: check for dimensionality match
# TODO parameterized function check signature
# TODO paramtrized function give good errors
# TODO ensure embedded fn are typed

# TODO viz
"""
- point 3D
- func 3D
- mfld 3D as surface

"""


using Plots


e = Embedding("ϕ", R2, R3, (x::Float64, y::Float64)->[x, y, 2sin(y) * -.2sin(4x)])

n = embed(R2, e)
g = embed(ManifoldGrid(R2, 25), e)
plot(n)
plot(g)
