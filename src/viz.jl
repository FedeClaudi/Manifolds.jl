using Plots
import MyterialColors: indigo_dark, indigo_light, indigo_darker, indigo

@recipe function f(m::Manifold)
    series_type = :path
    linecolor   --> indigo_dark
    linewidth   --> 3
    markershape :=  :none
    label       -->  m.name
    aspect_ratio := :equal
    grid        --> false

    pts = boundary(m, 40)
    x = map(p->p.p[1], pts)
    y = if dim(m) == 1
        zeros(length(x))
    else
        map(p -> p.p[2], pts)
    end

    @series begin
        linewidth   --> 0
        label       := nothing
        fillcolor   --> indigo_light
        Shape(x, y)
    end

    x, y  
end


@recipe function f(p::Point)
    seriestype --> :scatter
    markersize := 10
    markercolor   --> indigo_darker
    label    := "p"
    aspect_ratio := :equal
    grid        --> false
    markerstrokecolor --> :black
    markerstrokewidth --> 2

    [p.p[1]], [p.p[2]]
end

@recipe function f(p::ParametrizedFunction)
    seriestype --> :path
    label    := p.name
    aspect_ratio := :equal
    grid        --> false
    linecolor --> indigo_darker
    linewidth --> 2


    x = map(p -> p.p[1], p.x)
    y = map(p -> p.p[2], p.y)
    x, y
end

@recipe function f(g::ManifoldGrid)
    seriestype --> :path
    label    := nothing
    aspect_ratio := :equal
    grid        --> false
    linecolor --> indigo
    linewidth --> 1.5
    linealpha --> 1.0

    for fn in g.v
        @series begin
            x = map(p -> p.p[1], fn.y)
            y = map(p -> p.p[2], fn.y)
            x, y
        end
    end

    
    for fn in g.h
        @series begin
            linewidth := .4
            linealpha := .8
            x = map(p -> p.p[1], fn.y)
            y = map(p -> p.p[2], fn.y)
            x, y
        end
    end
end