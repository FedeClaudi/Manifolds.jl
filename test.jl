using CairoMakie, GLMakie
using LinearAlgebra
GLMakie.activate!() # just in case

# example mesh
using FileIO
m = FileIO.load(Makie.assetpath("cat.obj"))

# CairoMakie has a (internal) surface -> mesh conversion function you can use
# m = CairoMakie.surface2mesh(xs, ys, zs)

# grow mesh
m2 = deepcopy(m)
scale = 0.0001 * m.position |> norm |> maximum
@. m2.position += scale * m.normals

f, a, p = mesh(m, color = :orange)
mesh!(a, m2, color = :black, depth_shift = -0.05f0)
display(f)