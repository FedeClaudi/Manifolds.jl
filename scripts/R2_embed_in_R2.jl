using Manifolds
using Plots

e = Embedding("test", R2, R2, (x, y)->[2x+2, -1y+2])
eR2 = embed(R2, e)
g = ManifoldGrid(R2)

p = Point(R2, [.75, .2])
fn = ParametrizedFunction("fn", R2, t -> [t, sin(2t)])

plot(R2)
plot!(fn)
plot!(g)



plot!(eR2)
plot!(embed(fn, e))
plot!(embed(g, e))
