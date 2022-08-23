getcoord(x::Vector{Point}, coord::Symbol)::Vector{Float64} = begin
    idx = if coord == :x
        1
    elseif coord == :y
        2
    else
        3
    end
    return map(p->p.p[idx], x) |> collect
end

getcoord(x::Point, coord::Symbol)::Float64 = begin
    idx = if coord == :x
        1
    elseif coord == :y
        2
    else
        3
    end
    return x.p[idx]
end