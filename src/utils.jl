nargs(f::Function)::Int = first(methods(f)).nargs -1 


# ---------------------------------- vectors --------------------------------- #
collect2vecs(X::Vector)::Vector{Vector} = [
    [x] for x in X
]

flatten(X::Matrix)::Vector{Vector} = eachcol(hcat(X...)) |> collect