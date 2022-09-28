using GLMakie
using Colors

# using CairoMakie


include("visual_primitives.jl")

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
)
    (!isnothing(color) && !isa(color, Symbol) && isnothing(colorby)) && (colorby=:w)
    
    color isa Symbol && (color = fill(color, 100, 100))
    isnothing(color) && ( color = fill(colorant"#D1D6F6", 100, 100)) 
    @assert color isa Matrix "Color should be a matrix with shape: $(size(X))"

    # plot
    fig = Figure(resolution=(1200, 1200), viewmode = :fitzoom)
    ax = LScene(fig[1, 1], 
            scenewk=(; padding=(0, 0,0))
            # scenekw = (; limits=Rect3f(Vec3f(-1, -1, -1),Vec3f(2, 2, 2)))
        )

    # m = CairoMakie.surface2mesh(X, Y, Z)
    # m2 = deepcopy(m)
    # scale = 0.001 * m.position |> norm |> maximum
    # @. m2.position -= scale * m.normals


    # mesh!(ax, m2, color = :black, 
    #         shading=false, overdraw=false,
    #         ssao=false, depth_shift=.1,
    #         )

    # mesh!(ax, m, color = colorant"#D1D6F6", 
    #         shading=false, overdraw=false,
    #         ssao=false, depth_shift=0,
    #     )
        

    n = ()
    pltobj = surface!(
        ax,
        X, Y, Z;
        shading=false,
        color=color,
        colormap=cmap,
        transparency=transparency,
        fxaa=false, ssao=false,
    )

    w= wireframe!(ax, X, Y, Z; 
            transparency=transparency, shading=false, 
            color=:black, fxaa=false, linewidth=1, 
            overdraw=false, ssao=false
    )

    
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


# ---------------------------------------------------------------------------- #
#                                TANGENT VECTORS                               #
# ---------------------------------------------------------------------------- #

"""
Visualize a tangent vector v at a point p. 
Can be already embedded
"""
function visualize_tangent_vector(ax, p::Vector, v::Vector; 
        lengthscale=0.2,
        linewidth=0.025,    
        color=:black,
        normalize=false,
        arrowsize=Vec3f0(0.05, 0.05, 0.05),
    )

    v = normalize ? v ./ norm(v) : v
    arrows!(
        ax,
        collect2vecs(p)...,
        collect2vecs(v)...,
        shading=false,
        lengthscale=lengthscale,
        linewidth=linewidth,
        linecolor=color,
        arrowcolor=color,
        arrowsize=arrowsize,
    )
end



function visualize_tangent_vectorfield(ax, P::Vector, V::Vector; 
        kwargs...
    )
    visualize_tangent_vector.(ax, P, V; kwargs...)
end