using Manifolds
using Plots
plotly()


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