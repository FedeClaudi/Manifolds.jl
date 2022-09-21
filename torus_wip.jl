using Manifolds



struct TorusAtlas <: AbstractAtlas{ℝ} end



"""
Charts are cubes in parameter space of side π. 
The "paramter" representation of the Torus is a N-cube with sides 2π (from -π, π).
For each side of the cube there's two charts ([-π, 0] and (0, π)).
A point p ∈ T is an n-vector with nᵢ ∈ [-π, π] and nᵢ>0 is used to get the chart
on that i-th side of the cube.

For example for the 2-Torus there's 4 charts and the point p = [1, -1] is in the
chart indexed by [1, 0]  (chart indexing starts at 0).

Thus charts are indexed by a binary vector if integers.
"""
function Manifolds.get_chart_index(::Torus{n}, ::TorusAtlas, p::Vector)::Vector{Int} where {n}
    return Int.(p .> 0)
end


"""
Converts a point to its parameters with respect to the chart in a chart.

Given a point p ∈ M where M is [-π, π] × … × [-π, π]. 
Each chart U is mapped to [0, π] × … × [0, π].
To get p's coordinates in the chart U (with p ∈ U), we use 
the chart index vector i given by `get_chart_index(::Torus{n}, ::TorusAtlas, p)`
and define the transformation f: T → U ( ⊆[0, π] × … × [0, π] ) as p + π * (1 - i).
"""
function Manifolds.get_parameters!(::Torus{n}, x, ::TorusAtlas, i::Vector, p::Vector)::Vector where {n}
    return x .= p .+ π*(1 .- i)
end

"""
Given parameters x ∈ U (U being the chart indexed by `i` and U⊆[0, π] × … × [0, π]), 
we get the point p ∈ [-π, π] × … × [-π, π].

This is equivalent to the inverse of the chart map implemented by Manifolds.get_parameters!.

"""
function Manifolds.get_point!(::Torus{n}, p, ::TorusAtlas, i::Vector, x)::Vector where {n}
    return p .= x .- π.*( 1 .- i)
end



# ----------------------------------- test ----------------------------------- #
A = TorusAtlas()
t = Torus(2)
p = rand(t)

i = Manifolds.get_chart_index(t, A, p)
x = Manifolds.get_parameters(t, A, i, p)
p̂ = Manifolds.get_point(t, A, i, x)

print("\n")
println("""
    Point: $p
    Chart idx: $i
    Chart coordinates: $x
    Reconstructed point: $p̂
""")