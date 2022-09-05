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


e = Embedding("a", T, R3,  (θ₁, θ₂) -> begin
    R, r = 0.75, .25  # radii
    [(R + r * cos(θ₁)) * cos(θ₂), (R + r * cos(θ₁)) * sin(θ₂), r * sin(θ₁),]
end)

ϕ(x) = embed(x, e)

plot(ϕ(ManifoldGrid(T, 10)))

# n = Normal(ϕ(T), [.5, .5])
# plot!(n; vscale=-1)


# # p = Point(T, [.5, .5])
# # m = embed(T, e)
# # j = jacobian(m.ϕ, p.p)


# # plane_embedding = Embedding(
# #     "p", T, R3, (x, y) -> begin
# #         x, y = (0.5-x)/2, (0.5-y)/2
# #         x,y,z = j * [x, y]
# #         [x, y, z] + m.ϕ(p).p
# #     end
# # )

# plot!([-4, 4], [0, 0], [0, 0])
# plot!([0, 0], [-4, 4], [0, 0])
# plot!([0, 0], [0, 0], [-4, 4])
# # plot!(embed(ManifoldGrid(T,30), plane_embedding), linecolor=:green)


