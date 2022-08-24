using Plots
import MyterialColors: indigo_dark, indigo_light, indigo_darker, indigo


# ---------------------------------------------------------------------------- #
#                                   MANIFOLD                                   #
# ---------------------------------------------------------------------------- #
@recipe function f(m::Manifold)
    D = extdim(m)

    # seriestype --> (D >= 3 ? :scatter : :path)
    linecolor   --> indigo_dark
    linewidth   --> 3
    markershape :=  :none
    label       -->  m.name
    aspect_ratio := :equal
    grid        --> false

    pts = boundary(m, 40)
    x = getcoord(pts, :x)
    y = if D == 1
        zeros(length(x))
    else
        getcoord(pts, :y)
    end

    if D == 2  # draw area 2D
        @series begin
            linewidth   --> 0
            label       := nothing
            fillcolor   --> indigo_light
            Shape(x, y)
        end
    end

    return if D < 3
        x, y 
    else
        x, y, getcoord(pts, :z)
    end
end


# ---------------------------------------------------------------------------- #
#                                     POINT                                    #
# ---------------------------------------------------------------------------- #

@recipe function f(p::Point)
    seriestype --> :scatter
    markersize --> 10
    markercolor   --> indigo_darker
    label    --> "p"
    aspect_ratio := :equal
    grid        --> false
    markerstrokecolor --> :black
    markerstrokewidth --> 2

    x = [getcoord(p, :x)]
    
    return if dim(p) == 1
        x, [0.0]
    elseif dim(p) == 2
        x, [getcoord(p, :y)]
    else
        x, [getcoord(p, :y)], [getcoord(p, :z)]
    end
end

@recipe function f(vp::Vector{Point})
    seriestype --> :scatter
    markersize --> 10
    markercolor   --> indigo_darker
    aspect_ratio := :equal
    grid        --> false
    markerstrokecolor --> :black
    markerstrokewidth --> 2

    x = map(p -> getcoord(p, :x), vp)
    D = dim(vp[1])
    
    return if D == 1
        x, zeros(length(x))
    elseif D == 2
        x, map(p -> getcoord(p, :y), vp)
    else
        x, map(p -> getcoord(p, :y), vp), map(p -> getcoord(p, :z), vp)
    end
end


# ---------------------------------------------------------------------------- #
#                             ParametrizedFunction                             #
# ---------------------------------------------------------------------------- #

@recipe function f(fn::ParametrizedFunction)
    seriestype --> :path
    label    := fn.name
    aspect_ratio := :equal
    grid        --> false
    linecolor --> indigo_darker
    linewidth --> 2

    return if dim(fn) < 3
        getcoord(fn.y, :x), getcoord(fn.y, :y)
    else
        getcoord(fn.y, :x), getcoord(fn.y, :y), getcoord(fn.y, :z)
    end
end

# ---------------------------------------------------------------------------- #
#                                 MANIFOLD GRID                                #
# ---------------------------------------------------------------------------- #
@recipe function f(g::ManifoldGrid)
    seriestype --> :path
    label    := nothing
    aspect_ratio := :equal
    grid        --> false
    linecolor --> indigo
    linewidth --> 1.5
    linealpha --> 1.0

    D = dim(g)

    for fn in g.v
        @series begin
            x = getcoord(fn.y, :x)
            y = getcoord(fn.y, :y)
            return if D < 3
                x, y
            else
                z = getcoord(fn.y, :z)
                x, y, z
            end
        end
    end

    
    for fn in g.h
        @series begin
            linewidth --> .4
            linealpha --> .8
            x = getcoord(fn.y, :x)
            y = getcoord(fn.y, :y)
            return if D < 3
                x, y
            else
                z = getcoord(fn.y, :z)
                x, y, z
            end
        end
    end
end


# ---------------------------------------------------------------------------- #
#                                    FIELDS                                    #
# ---------------------------------------------------------------------------- #

@recipe function f(F::AbstractScalarField, n::Int=20)
    vp = sample(F.m, n)
    c = F.ψ.(vp)

    vp = F.m.ϕ(vp)  # embed if necessary
    x = map(p -> getcoord(p, :x), vp)
    D = dim(vp[1])

    marker_z := c
    colorbar --> nothing
    label    --> nothing
    seriestype := :scatter
    aspect_ratio := :equal
    grid        --> false
    
    return if D == 1
        x, zeros(length(x))
    elseif D == 2
        x, map(p -> getcoord(p, :y), vp)
    else
        x, map(p -> getcoord(p, :y), vp), map(p -> getcoord(p, :z), vp)
    end
end
