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
        A vector field of tangent vectors on a manifold `m`.
        The `TangentVector` v ∈ TₚM is given by ψ(p).
    """
    struct TangentVectorField
        m::DomainManifold
        ψ::Function

        """
            TangentVectorField(m::DomainManifold, ψ::Function)

        Construct a tangent vector field out of a function ψ that returns
        a vector of α weights for each p ∈ M.
        """
        function TangentVectorField(m::DomainManifold, ψ::Function)
            @assert nargs(ψ)==1 "Vector field function should accept a single ::Vector argument"

            x = Base.return_types(ψ, (Vector))[1]
            @assert x == Vector "Vector field function should return a vector, not $(typeof(x))"

            return new(
                m, 
                p -> TangentVector(p, ψ(p))
            )
        end
    end

    Base.string(tf::TangentVectorField) = "Tangent Vector field, ψ: $(tf.ψ))"
    Base.print(io::IO, tf::TangentVectorField) = print(io, string(tf))
    Base.show(io::IO, ::MIME"text/plain", tf::TangentVectorField) = print(io, string(tf))





    """
        TangentVectorField(m::DomainManifold, α::Vector)

    Construct a constant vector field were all vectors have the 
    same weights α. 
    """
    TangentVectorField(m::DomainManifold, α::Vector) = TangentVectorField(
        m,    
        p -> TangentVector(p, α)
    )

end