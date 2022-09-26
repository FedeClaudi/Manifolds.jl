module TangentVectors
    export TangentVector

    struct TangentVector
        p::Vector{Float64}  # point on M at which tangent vector is anchored
        α::Vector{Float64}  #  vector of weights of TpM bases for linear combination
    end

end