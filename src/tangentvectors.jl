module TangentVectors
    import DifferentialGeometry: flatten, nargs
    import ..Manifolds: DomainManifold, sample

    export TangentVector, TangentVectorField


    """
        A single tangent vector at a point p ∈ M.
        Defined as a combination of base vectors eᵢ:
        v = ∑ᵢ αᵢeᵢ
    """
    struct TangentVector
        p::Vector{Float64}  # point on M at which tangent vector is anchored
        α::Vector{Float64}  #  vector of weights of TpM bases for linear combination
    end


    """
        A vector field of tangent vectors on a manifold
    """
    struct TangentVectorField
        vecs::Vector{TangentVector}
    end

    Base.string(tf::TangentVectorField) = "Tangent Vector field ($(length(tf.vecs)) vectors)"
    Base.print(io::IO, tf::TangentVectorField) = print(io, string(tf))
    Base.show(io::IO, ::MIME"text/plain", tf::TangentVectorField) = print(io, string(tf))

    """
        TangentVectorField(m::DomainManifold, α::Vector)

    Construct a constant vector field were all vectors have the 
    same weights α. `P` represent a vector of manifold points.
    """
    function TangentVectorField(P::Vector{Vector}, α::Vector)
        A = repeat([α], length(P))

        return TangentVectorField(
            [TangentVector(p, a) for (p,a) in zip(P, A)]
        )
    end


    """
        TangentVectorField(m::DomainManifold, f::Function)

    Construct a tangent vector field out of a function that returns
    a vector of α weights for each p ∈ M.
    """
    function TangentVectorField(P::Vector{Vector}, f::Function)
        @assert nargs(f)==1 "Vector field function should accept a single ::Vector argument"

        x = f(P[1])
        @assert x isa Vector "Vector field function should return a vector, not $(typeof(x))"

        TangentVectorField(
            [TangentVector(p, a) for (p,a) in zip(P, f.(P))]
        )
    end
end