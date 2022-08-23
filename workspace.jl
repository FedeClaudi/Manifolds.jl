using Manifolds
using Term
install_term_logger()
install_term_repr()
# install_term_stacktrace()

# TODO make tests for functionality implemented so far
# TODO Embedding: check for dimensionality match
# TODO parameterized function check signature
# TODO paramtrized function give good errors

# TODO embedding
    # - apply embedding to mfld's ϕ
    # - viz

using Plots


plot(R)
plot!(R2)

e = Embedding("ϕ", R, R2, (x)->[x, 2x])
n = embed(R, e)
plot!(n)