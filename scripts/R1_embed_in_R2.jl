using Manifolds
using Plots
plotly()

using Plots


p = plot(R)
# plot!(R2)

e = Embedding("ϕ", R, R2, (x::Float64)->[-0.5x, .2x])
n = embed(R, e)
plot!(n)
p