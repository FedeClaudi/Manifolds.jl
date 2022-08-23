using Manifolds
using Plots
plotly()

import Manifolds: standard_torus

fn = ParametrizedFunction(
    "γ", T, t -> [2π*t, 2π*t]; δ=0.01
)
fn2 = ParametrizedFunction(
    "γ", T, t -> [0, 2π*t]; δ=0.01
)

fn3 = ParametrizedFunction(
    "γ", T, t -> [2π*t, 0]; δ=0.01
)


ϕ(x) = embed(x, standard_torus)


plt0 = plot( title="T ≃ C × C")
plot!(plt0, T)
plot!(plt0, ManifoldGrid(T, 12))
plot!(plt0, fn, lw=8, linecolor=:red)
plot!(plt0, fn2, lw=8, linecolor=:blue)
plot!(plt0, fn3, lw=8, linecolor=:black)


plt = plot(xlim=[-1, 1], ylim=[-1, 1], zlim=[-1, 1], xticks=[0, 1], title="T ⊂ ℝ³")
plot(plt, ϕ(T))


plot!(plt, ϕ(ManifoldGrid(T, 12)), linewidth=2)
plot!(plt, ϕ(fn), linewidth=8, linecolor=:red)
plot!(plt, ϕ(fn2), linewidth=8, linecolor=:blue)
plot!(plt, ϕ(fn3), linewidth=8, linecolor=:black)

plot(plt0, plt, legend=nothing, size=(800, 600))