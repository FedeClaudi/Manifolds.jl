using GLMakie
using Colors
# import GLMakie.Makie: Vec3f


function shadow(X, Y, Z, ax)
    surface!(
        ax,
        X, Y, Z;
        shading=false,
        transparency=true,
        color=fill((:grey20, 1),100,100),
    )
end

function xshadow(X, Y, Z, ax)
    x0 = abs(minimum(X))
    X = zeros(size(X)) .- x0 * 1.5
    shadow(X, Y, Z, ax)
end

function yshadow(X, Y, Z, ax)
    x0 = abs(minimum(Y))
    Y = zeros(size(Y)) .- x0 * 1.5
    shadow(X, Y, Z, ax)
end

function zshadow(X, Y, Z, ax)
    x0 = abs(minimum(Z))
    Z = zeros(size(Z)) .- x0 * 1.1
    shadow(X .* 0.95 .- .05, Y .* 0.95, Z, ax)
end





function visualize_manifold(
    X::Matrix,
    Y::Matrix,
    Z::Matrix;
    color=nothing,
    cmap=Reverse(:bone_1),
    colorby=nothing,
    transparency::Bool=false,
    Δ::Union{Nothing, Matrix}=nothing,
)
    (!isnothing(color) && !isa(color, Symbol) && isnothing(colorby)) && (colorby=:w)
    color = isnothing(color) ? fill(colorant"#D1D6F6", 100, 100) : fill(color, 100, 100)


    # plot
    fig = Figure(resolution=(1200, 1200), viewmode = :fitzoom)
    ax = LScene(fig[1, 1], 
            scenewk=(; padding=(0, 0,0))
            # scenekw = (; limits=Rect3f(Vec3f(-1, -1, -1),Vec3f(2, 2, 2)))
        )

    !isnothing(Δ) && begin
        Δx = first.(Δ)
        Δy = getindex.(Δ, 2)
        Δz = last.(Δ)
        _X, _Y, _Z = X .+ 0.001*Δx, Y .+ 0.001*Δy, Z .+ 0.001*Δz

        surface!(
            ax,
            _X, _Y, _Z;
            shading=false,
            color=fill(:black, 100, 100),
            transparency=transparency,
            depth_shift = 0.99f0
        )
    end



    pltobj = surface!(
        ax,
        X, Y, Z;
        shading=false,
        color=fill(:white, 100, 100),
        # colormap=cmap,
        transparency=transparency,
        # ssao=true,
        # fxaa=true,
        # depth_shift = 0.01f0
    )

    # wireframe!(ax, X, Y, Z; transparency=transparency, shading=false, color=:grey16, fxaa=true, linewidth=.75, overdraw=false, ssao=true)

    # colorbar
    try
        isnothing(colorby) || Colorbar(fig[1, 2], pltobj, height=Relative(0.5),
            label = string(colorby), ticklabelsize = 25,
            ticklabelcolor=:white, tickcolor=:white,
            labelcolor=:white, labelsize=20,
        )
    catch
        nothing
    end


    # style
    axis = ax.scene[OldAxis] # you can change more colors here!
    axis[:ticks][:textcolor] = :grey64
    axis[:ticks][:textsize] = 9
    axis[:frame][:linecolor] = :white
    axis[:frame][:axiscolor] = :white
    axis[:frame][:linewidth] = 0.5
    axis[:names][:textcolor] = :white
    axis[:names][:textsize] = 12
    zoom!(ax.scene, cameracontrols(ax.scene), 1.4)

    set_theme!(backgroundcolor=colorant"#23272E")
    return fig, ax
end




function visualize_curve!(ax, X::Vector, Y::Vector, Z::Vector; color=:black, lw=5, transparency=false)
    lines!(ax, X, Y, Z; linewidth=lw, color=color, transparency=transparency, fxaa=true,)
end