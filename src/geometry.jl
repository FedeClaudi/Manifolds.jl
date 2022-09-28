using ForwardDiff: jacobian
import LinearAlgebra: norm, eigen
import LinearAlgebra: cross as ×


# -------------------------------- coordinates ------------------------------- #
# TODO implement u₁, x₁ on `Manifold` and `Matrix`

"""
    uᵢ(x::Vector, i)::Float64

Given x ∈ M get the i-th coordinate
"""
uᵢ(p::Vector, i::Int)::Float64 = p[i]

u1(p::Vector)::Float64 = uᵢ(p, 1)
u2(p::Vector)::Float64 = uᵢ(p, 2)
u3(p::Vector)::Float64 = uᵢ(p, 3)

"""
    xᵢ(φ::Embedding, x::Vector, i::Int)

Given x ∈ M get the i-th coordinate of φ(x) ∈ N
"""
xᵢ(φ::Embedding, p::Vector, i::Int)::Float64 = φ(p)[i]

x1(φ::Embedding, p::Vector)::Float64 = xᵢ(φ, p, 1)
x2(φ::Embedding, p::Vector)::Float64 = xᵢ(φ, p, 2)
x3(φ::Embedding, p::Vector)::Float64 = xᵢ(φ, p, 3)


# ----------------------------- derivatives stuff ---------------------------- #

""" 
    J

Jacobian matrix of a function `f` at a point `p`.
See ForwardDiff.jacobian
"""
function J end
J(φ::Embedding, p::AbstractVector)::Matrix = jacobian(φ.φ, p)

"""
    ∂φ∂x(φ::Embedding, i::Int, x::AbstractVector)

Evalute the i-th partial derivative of an
embedding map φ: M → N ⊆ ℝᵏ at a point p ∈ M (the manifold).
Equivalent to the i-th column of the Jacobian of φ
"""
∂φ∂x(φ::Embedding, i::Int, p::AbstractVector) = J(φ, p)[:, i]


""" 
    𝐈
First canonical form of a surface parametrization

Written: \bfI
"""
function 𝐈 end

function 𝐈(φ::Embedding, p::AbstractVector)::Matrix
    @assert φ.d == 2 && φ.k == 3 "First canonical form works only on 2->3 embeddings, not $φ"
    _J = J(φ, p)
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

function normal(φ::Embedding, p::AbstractVector)::Vector
    @assert φ.d == 2 && φ.k == 3 "Cannot compute normal vector for embedding: $φ"
    j = J(φ, p)
    n = ×(eachcol(j)...)
    -n ./ (norm(n) + eps())
end

"""
    metric_deformation(φ::Embedding, p::AbstractVector)::Tuple{Number, Number}

Return the eigenvalues of the first canonical form of an embedding 
(or surface parametrization) map.
"""
function metric_deformation(φ::Embedding, p::AbstractVector)::Tuple{Number, Number}
    λ₁, λ₂ = eigen(𝐈(φ, p)).values
    return λ₁, λ₂
end

"""
    area_deformation(φ::Embedding, p::AbstractVector)::Float64

Compute area deformation of an embedding (parametrization) map as
the product of the eigenvalues of the first canonical form.
"""
function area_deformation(φ::Embedding, p::AbstractVector)::Float64
    λ₁, λ₂ = metric_deformation(φ, p)
    λ₁ * λ₂
end