"""
Compute the laplacian of a function on a 2D domain

From: https://www.youtube.com/watch?v=oEq9ROl9Umk

d²/dt²u = Δu

where
Δu is the sum of second partial derivatives
"""

import LinearAlgebra: tr
using GLMakie
GLMakie.inline!(true)
using ForwardDiff: hessian


k(x, y) = sinc(√(x^2 + y^2) / π) + sin(x)
k(u) = sinc(√(u[1]^2 + u[2]^2) / π) +sin(u[1])

D = collect(-8:0.25:8)

f = [ [x, y, k(x,y)] for x in D for y in D]
x = [x[1] for x in f]
y = [x[2] for x in f]
z = [x[3] for x in f]

Δ(x) = -tr(hessian(k, x))
BL = [Δ([x, y]) for x in D for y in D]

surface(
    reshape(x, 65, 65),
    reshape(y, 65, 65),
    reshape(z, 65, 65); 
    color=reshape(BL, 65, 65), axis=(type=Axis3,), colormap=:bwr, shading=false)

