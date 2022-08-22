using Plots
import MyterialColors: indigo_dark, indigo_light

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