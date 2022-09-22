using GLMakie
using Colors
# import GLMakie.Makie: Vec3f


function visualize_manifold(
    X::Matrix,
    Y::Matrix,
    Z::Matrix;
    color=nothing,
    cmap=Reverse(:bone_1),
    colorby::Symbol=:d,
    transparency::Bool=false,
)
    
    if isnothing(color)
        if colorby == :d
            color = sqrt.(X .^ 2 .+ Y .^ 2 .+ Z .^ 2)
        elseif colorby == :z
            color = Z
        else
            error("Unrecognized colorby value $colorby")
        end
    else
        colorby=:W
    end

    # plot
    fig = Figure(resolution=(1200, 1200), viewmode = :fitzoom)
    ax = LScene(fig[1, 1], 
            # scenekw = (; limits=Rect3f(Vec3f(-1, -1, -1),Vec3f(2, 2, 2)))
        )

    pltobj = surface!(
        ax,
        X, Y, Z;
        shading=false,
        color=color,
        colormap=cmap,
        transparency=transparency,
    )
    wireframe!(ax, X, Y, Z; transparency=transparency, shading=false, color=:black, linewidth=0.5)

    # colorbar
    

    try
        Colorbar(fig[1, 2], pltobj, height=Relative(0.5),
            label = string(colorby), ticklabelsize = 18,
            ticklabelcolor=:white, tickcolor=:white,
            labelcolor=:white, labelsize=20,
        )
        colsize!(fig.layout, 1, Aspect(1, 0.8))
        colsize!(fig.layout, 2, Aspect(1, 0.1))
    catch
        nothing
    end


    # style
    axis = ax.scene[OldAxis] # you can change more colors here!
    axis[:ticks][:textcolor] = :grey64
    axis[:ticks][:textsize] = 7
    axis[:frame][:linecolor] = :white
    axis[:frame][:axiscolor] = :white
    axis[:frame][:linewidth] = 0.5
    axis[:names][:textcolor] = :white
    axis[:names][:textsize] = 10
    zoom!(ax.scene, cameracontrols(ax.scene), 1.4)

    set_theme!(backgroundcolor=colorant"#23272E")
    display(fig)
end