using ForwardDiff: jacobian
import LinearAlgebra: norm, eigen
import LinearAlgebra: cross as ×


# ----------------------------- derivatives stuff ---------------------------- #

""" 
    J

Jacobian matrix of a function `f` at a point `x`.
See ForwardDiff.jacobian
"""
function J end
J(φ::Embedding, x::Vector)::Matrix = jacobian(φ.φ, x)

"""
    ∂φ∂x(φ::Embedding, i::Int, x::Vector)

Evalute the i-th partial derivative of an
embedding map φ: M → N ⊆ ℝᵏ at a point x ∈ M (the manifold).
Equivalent to the i-th column of the Jacobian of φ
"""
∂φ∂x(φ::Embedding, i::Int, x::Vector) = J(φ, x)[:, i]


""" 
    𝐈
First canonical form of a surface parametrization

Written: \bfI
"""
function 𝐈 end

function 𝐈(φ::Embedding, x::Vector)::Matrix
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

function normal(φ::Embedding, x::Vector)::Vector
    @assert φ.d == 2 "Cannot compute normal vector for embedding: $φ"
    n = ∂φ∂x(p, 1, x) × ∂φ∂y(p, 1, x)
    n ./ norm(n)
end

"""
    metric_deformation(φ::Embedding, x::Vector)::Tuple{Number, Number}

Return the eigenvalues of the first canonical form of an embedding 
(or surface parametrization) map.
"""
function metric_deformation(φ::Embedding, x::Vector)::Tuple{Number, Number}
    I = 𝐈(φ, x)
    λ₁, λ₂ = eigen(I).values
    return λ₁, λ₂
end