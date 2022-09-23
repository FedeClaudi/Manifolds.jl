using ForwardDiff: jacobian
import LinearAlgebra: norm, eigen
import LinearAlgebra: cross as ×


# -------------------------------- coordinates ------------------------------- #
# TODO implement u₁, x₁ on `Manifold` and `Matrix`

"""
    uᵢ(x::Vector, i)::Float64

Given x ∈ M get the i-th coordinate
"""
uᵢ(x::Vector, i::Int)::Float64 = x[i]

u1(x::Vector)::Float64 = uᵢ(x, 1)
u2(x::Vector)::Float64 = uᵢ(x, 2)
u3(x::Vector)::Float64 = uᵢ(x, 3)

"""
    xᵢ(φ::Embedding, x::Vector, i::Int)

Given x ∈ M get the i-th coordinate of φ(x) ∈ N
"""
xᵢ(φ::Embedding, x::Vector, i::Int)::Float64 = φ(x)[i]

x1(φ::Embedding, x::Vector)::Float64 = xᵢ(φ, x, 1)
x2(φ::Embedding, x::Vector)::Float64 = xᵢ(φ, x, 2)
x3(φ::Embedding, x::Vector)::Float64 = xᵢ(φ, x, 3)


# ----------------------------- derivatives stuff ---------------------------- #

""" 
    J

Jacobian matrix of a function `f` at a point `x`.
See ForwardDiff.jacobian
"""
function J end
J(φ::Embedding, x::AbstractVector)::Matrix = jacobian(φ.φ, x)

"""
    ∂φ∂x(φ::Embedding, i::Int, x::AbstractVector)

Evalute the i-th partial derivative of an
embedding map φ: M → N ⊆ ℝᵏ at a point x ∈ M (the manifold).
Equivalent to the i-th column of the Jacobian of φ
"""
∂φ∂x(φ::Embedding, i::Int, x::AbstractVector) = J(φ, x)[:, i]


""" 
    𝐈
First canonical form of a surface parametrization

Written: \bfI
"""
function 𝐈 end

function 𝐈(φ::Embedding, x::AbstractVector)::Matrix
    @assert φ.d == 2 && φ.k == 3 "First canonical form works only on 2->3 embeddings, not $φ"
    _J = J(φ, x)
    return _J' * _J
end

"""
    𝐈𝐈

Second canonical form of a surface parametrization

Written: \bfI\bfI
"""
function 𝐈𝐈(args...)
    error("Not implemented")
end


# ------------------------------ geometry stuff ------------------------------ #
"""
Compute the normal vector at a point x ∈ M
given an embedding map φ: M → N ⊆ ℝᵏ
"""
function normal end

function normal(φ::Embedding, x::AbstractVector)::Vector
    @assert φ.d == 2 && φ.k == 3 "Cannot compute normal vector for embedding: $φ"
    j = J(φ, x)
    n = ×(eachcol(j)...)
    -n ./ (norm(n) + eps())
end

"""
    metric_deformation(φ::Embedding, x::AbstractVector)::Tuple{Number, Number}

Return the eigenvalues of the first canonical form of an embedding 
(or surface parametrization) map.
"""
function metric_deformation(φ::Embedding, x::AbstractVector)::Tuple{Number, Number}
    λ₁, λ₂ = eigen(𝐈(φ, x)).values
    return λ₁, λ₂
end

"""
    area_deformation(φ::Embedding, x::AbstractVector)::Float64

Compute area deformation of an embedding (parametrization) map as
the product of the eigenvalues of the first canonical form.
"""
function area_deformation(φ::Embedding, x::AbstractVector)::Float64
    λ₁, λ₂ = metric_deformation(φ, x)
    λ₁ * λ₂
end