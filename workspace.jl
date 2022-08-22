using Manifolds

# TODO make tests for functionality implemented so far
# TODO Embedding: check for dimensionality match
# TODO parameterized function check signature
# TODO paramtrized function give good errors

# TODO embedding
    # - apply embedding to mfld's ϕ
    # - apply mfld's ϕ to points


using Plots

# e = Embedding("test", R2, R2, (x, y)->[x/2, y/2])


g = ManifoldGrid(largeR)




# plot(R2)
plot(largeR)
plot!(Point(R2, [.25, .25]))
plot!(g)
