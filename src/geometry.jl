using ForwardDiff: jacobian
import LinearAlgebra: norm, eigen
import LinearAlgebra: cross as ×

"""
    ∂φ∂x(φ::Embedding, i::Int, x::Vector)

Evalute the i-th partial derivative of an
embedding map φ: M → N ⊆ ℝᵏ at a point x ∈ M (the manifold).
Equivalent to the i-th column of the Jacobian of φ
"""
∂φ∂x(φ::Embedding, i::Int, x::Vector) = jacobian(φ.φ, x)[:, i]


"""
Compute the normal vector at a point x ∈ M
given an embedding map φ: M → N ⊆ ℝᵏ
"""
function normal end

# function normal(φ::Embedding, x::Vector)