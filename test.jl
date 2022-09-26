using GLMakie, GeometryBasics

function torus(R, r, N, n)
    ps = Vector{Point3f}(undef, N*n)
    idx = 1
    for i in 1:N
        c = cos(2pi * i/N)
        s = sin(2pi * i/N)
        M = Mat3f(
            c, s, 0,
            -s, c, 0,
            0, 0, 1
        )
        center = Point3f(R*c, R*s, 0)
        for j in 1:n
            ps[idx] = center + M * Point3f(r*cos(2pi * j/n), 0, r*sin(2pi * j/n))
            idx += 1
        end
    end

    faces = Vector{GLTriangleFace}(undef, 2N*n)
    for i in 1:N*n
        faces[2i-1] = GLTriangleFace(
            i, 
            mod1(i+n, N*n),
            mod1(i+1, N*n) 
        )
        faces[2i] = GLTriangleFace(
            mod1(i+1, N*n), 
            mod1(i+n, N*n),
            mod1(i+n+1, N*n) 
        )
    end

    return normal_mesh(ps, faces)
end

mesh(
    torus(1f0, 0.3f0, 100, 30), color = RGBf(1, 1, 1),
    specular = Vec3f(-1e-3), shininess = -4f0
)