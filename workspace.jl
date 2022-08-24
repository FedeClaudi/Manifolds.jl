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



import Manifolds: standard_R2_to_R3

e = Embedding(
    "ϕ", R2, R3, (x, y) -> [x, y, x^2*y^2]
)

ϕ(x) = embed(x, e)

F = ScalarField(
    "𝔽", R2, (x, y) -> x+y
)


p = plot(
    ϕ(R2), label=nothing
)

plot!(
    ϕ(F), 50
)