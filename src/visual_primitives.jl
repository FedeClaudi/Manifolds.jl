using LinearAlgebra
using Makie
using GeometryBasics

nan2zero(x) = !isnan(x) * x

function surface2mesh(xs::Makie.ClosedInterval, ys, zs::AbstractMatrix)
    surface2mesh(range(xs.left, xs.right, length = size(zs, 1)), ys, zs)
end

function surface2mesh(xs, ys::Makie.ClosedInterval, zs::AbstractMatrix)
    surface2mesh(xs, range(ys.left, ys.right, length = size(zs, 2)), zs)
end

function surface2mesh(xs::Makie.ClosedInterval, ys::Makie.ClosedInterval, zs::AbstractMatrix)
    surface2mesh(
        range(xs.left, xs.right, length = size(zs, 1)),
        range(ys.left, ys.right, length = size(zs, 2)),
        zs)
end

function surface2mesh(xs::AbstractVector, ys::AbstractVector, zs::AbstractMatrix)
    ps = [nan2zero.(Point3f0(xs[i], ys[j], zs[i, j])) for j in eachindex(ys) for i in eachindex(xs)]
    idxs = LinearIndices(size(zs))
    faces = [
        QuadFace(idxs[i, j], idxs[i+1, j], idxs[i+1, j+1], idxs[i, j+1])
        for j in 1:size(zs, 2)-1 for i in 1:size(zs, 1)-1
    ]
    normal_mesh(ps, faces)
end

function surface2mesh(xs::AbstractMatrix, ys::AbstractMatrix, zs::AbstractMatrix)
    ps = [nan2zero.(Point3f0(xs[i, j], ys[i, j], zs[i, j])) for j in 1:size(zs, 2) for i in 1:size(zs, 1)]
    idxs = LinearIndices(size(zs))
    faces = [
        QuadFace(idxs[i, j], idxs[i+1, j], idxs[i+1, j+1], idxs[i, j+1])
        for j in 1:size(zs, 2)-1 for i in 1:size(zs, 1)-1
    ]
    normal_mesh(ps, faces)
end
