using Manifolds
using Plots
plotly()
using Plots


e = Embedding("ϕ", R2, R3, (x::Float64, y::Float64)->[x, y, 2sin(y) * .2sin(4x)])

n = embed(R2, e)
g = embed(ManifoldGrid(R2, 100), e)
plot(n)
plot(g)
