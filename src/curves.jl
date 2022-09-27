struct Curve
    d::Int
    γ::Function

    function Curve(γ::Function)
        @assert nargs(γ) == 1 "γ can only have one argument i ∈ [0, 1] | $(nargs(γ))"
        
        x = γ(1.0)
        @assert x isa AbstractVector "γ should output vectors"
        new(length(x), γ)
    end
end

(curve::Curve)(x)::Vector = curve.γ(x)

Base.string(γ::Curve) = "Curve onto M with d=$(γ.d)"
Base.print(io::IO, γ::Curve) = print(io, string(γ))
Base.show(io::IO, ::MIME"text/plain", γ::Curve) = print(io, string(γ))


