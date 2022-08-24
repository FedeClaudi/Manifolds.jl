abstract type AbstractField end


Base.string(m::AbstractField) = "Manifold: $(m.name)"
Base.print(io::IO, m::AbstractField) = print(io, string(m))
Base.show(io::IO, ::MIME"text/plain", m::AbstractField) = print(io, string(m))


abstract type AbstractScalarField <: AbstractField end
Base.string(f::AbstractScalarField) = "Scalar field: '$(f.name)' on $(f.m.name)"


abstract type AbstractVectorField <: AbstractField end
Base.string(f::AbstractVectorField) = "Vector field: '$(f.name)' on $(f.m.name)"


macro addmethod(fn)
    @info "a" fn 
    quote
        println(esc(fn))
        function $(esc(fn))(p::Point)
            println("Hello",  p)
        end
    end
end
  

struct ScalarField <: AbstractScalarField
    name::String
    m::Manifold
    _ψ::Function        # original field map
    ψ::Function         # specialized field map

    function ScalarField(name::String, m::Manifold, ψ::Function)
        
        # check ψ's return type
        _args = Tuple(repeat([Float64], dim(m)))
        @assert Base.return_types(ψ, _args)[1] == Float64 "Scalar field's ψ function must return a Float64"


        psi(x) = ψ(x)

        psi(x::Point)::Float64 = ψ(x.p...)

        psi()::Vector{Float64} = psi.(sample(m, 20))
        psi(m::Manifold)::Vector{Float64} = psi.(sample(m, 20))
        psi(mfld::Manifold, n::Int)::Vector{Float64} = psi.(sample(mfld, n))
        psi(n::Int)::Vector{Float64} = psi.(sample(m, n))
        
        new(name, m, ψ, psi)
    end
end




