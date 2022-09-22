module Embeddings
    import ..Manifolds: DomainManifold, sample

    export Embedding, TorusEmbedding, SphereEmbedding, CylinderEmbedding, MobiusEmbedding

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
            d = first(methods(φ)).nargs
            k = length(φ(zeros(d)))

            @assert k >= d "Embedding dimensionaliy $k too small for manifold with d=$d"
            new(d, k, φ)
        end
    end

    Base.string(e::Embedding) = "φ: ℝᵈ ⊃ M → N ⊂ ℝᵏ| d=$(e.d), k=$(e.k)"
    Base.print(io::IO, e::Embedding) = print(io, string(e))
    Base.show(io::IO, ::MIME"text/plain", e::Embedding) = print(io, e)



    """ get embedding coordinates of all points in a manifold """
    function (e::Embedding)(m::DomainManifold)::Vector{Matrix}
        @assert m.d == e.d "Attempting to embed $m with incompatible embedding $e"
        @debug "Embedding" m e
        m.d != 2 && error("Make it generalize")

        # get embedded points
        M = sample(m)
        @debug "M" M eltype(M)

        pts = e.φ.(
            M
        )

        @debug "Got points" pts size(pts) eltype(pts) size(pts[1])
        return map(
            d ->  [p[d] for p in pts],
            1:length(pts[1])
        )
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