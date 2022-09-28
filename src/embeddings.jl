module Embeddings
    import LinearAlgebra: cross as ×
    import LinearAlgebra: norm
    import ForwardDiff: jacobian

    import DifferentialGeometry: Curve, nargs
    import ..Manifolds: DomainManifold, sample
    import ..TangentVectors: TangentVector, TangentVectorField

    export Embedding, TorusEmbedding, SphereEmbedding, CylinderEmbedding, MobiusEmbedding
    export PlaneEmbedding

    ⋅ = *  # for aesthetics

    # ---------------------------------------------------------------------------- #
    #                                   EMBEDDING                                  #
    # ---------------------------------------------------------------------------- #

    abstract type AbstractEmbedding end

    """
        Embedding

        Stores an embedding map φ: M → N ⊆ ℝᵏ
    """
    struct Embedding <: AbstractEmbedding 
        d::Int          # intrinsic manifold dimensionality
        k::Int          # embedding space dimensionality
        φ::Function
        
        function Embedding(φ::Function)
            d = nargs(φ)+1
            k = length(φ(zeros(d)))

            @assert k >= d "Embedding dimensionaliy $k too small for manifold with d=$d"
            new(d, k, φ)
        end
    end

    Base.string(e::Embedding) = "φ: ℝᵈ ⊃ M → N ⊂ ℝᵏ| d=$(e.d), k=$(e.k)"
    Base.print(io::IO, e::Embedding) = print(io, string(e))
    Base.show(io::IO, ::MIME"text/plain", e::Embedding) = print(io, e)



    (e::Embedding)(x::Vector)::Vector = e.φ(x)

    """ get embedding coordinates of all points in a manifold """
    function (e::Embedding)(m::DomainManifold; n=48)::Vector{Matrix}
        @assert m.d == e.d "Attempting to embed $m with incompatible embedding $e"
        @debug "Embedding" m e
        m.d != 2 && error("Make it generalize")

        # get embedded points
        M::Matrix{Vector} = sample(m; n=n)
        @debug "M" M eltype(M)

        pts::Matrix = e.φ.(
            M
        )

        @debug "Got points" pts size(pts) eltype(pts) size(pts[1])
        return map(
            d ->  [p[d] for p in pts],
            1:length(pts[1])
        )
    end

    
    """
        Embed a curve
    """
    function (e::Embedding)(γ::Curve; Δ=0.01)::Vector{Vector}
        curve::Vector{Vector} = γ.(0:0.001:1.0)  # points on manifold
        pts::Vector = e.φ.(curve)                # points on the embedded mfl

        # get normal at all points along the curve
        normal(x) = begin
            j = jacobian(e, x)
            n = ×(eachcol(j)...)
            -n ./ (norm(n) + eps())
        end
        normals = map(
            x -> normal(x), curve    
        )
        return map(
            d ->  [p[d] + Δ * n[d] for (p, n) in zip(pts, normals)],
            1:length(pts[1])
        )
    end

    """
        Embed a tangent vector
    """
    function (e::Embedding)(v::TangentVector)::Vector
        J = jacobian(e, v.p)
        return J * v.α
    end

    """
        Embed a tangent vector field
    """
    function (e::Embedding)(tf::TangentVectorField)::Vector{Vector}
        e.(tf.vecs)
    end


    # ---------------------------------------------------------------------------- #
    #                              STANDARD EMBEDDINGS                             #
    # ---------------------------------------------------------------------------- #
    CylinderEmbedding = Embedding( 
        (p) -> begin
                x, y = p
                return [
                    cos(x),
                    sin(x),
                    y
                ]
            end
    )

    PlaneEmbedding = Embedding( 
        (p) -> begin
                x, y = p
                return [
                    x,
                    y,
                    1-x*y
                ]
            end
    )


    TorusEmbedding = Embedding(
        (p) -> begin
                R, r = 1.0, 0.5
                x, y = p
                return [
                    (R + r⋅cos(x))⋅cos(y),
                    (R + r⋅cos(x))⋅sin(y),
                    r⋅sin(x)
                ]
            end
    )


    SphereEmbedding = Embedding(
        (p) -> begin
                lon, lat = p
                ls = atan(tan(lat)) 
                return [ 
                        cos(ls) ⋅ cos(lon),
                        cos(ls) ⋅ sin(lon),
                        sin(ls),
                ]
        end
    )


    MobiusEmbedding = Embedding(
        (p) -> begin
                x, y = p
                return [ 
                        (1 + y/2⋅cos(x/2))⋅cos(x),
                        (1 + y/2⋅cos(x/2))⋅sin(x),
                        y/2⋅sin(x/2)
                ]
        end
    )

end