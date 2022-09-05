# Manifolds

A small julia package to play around with ideas of Topology and Differential Geometry.

The core element is the `Manifold <: AbstractManifold` type which defines a maifold. A manifold is simply defined by a name (used to refer to it if necessary) and a *domain* $D \subseteq \mathbb R^n$.

A few standard manifolds are defined:
* $\mathbb R$: line with $D=[0,1]$.
* $\mathbb R^2$ plane with $D=[0,1]\times [0,1]$ 
* $C$ circle, $D=[0, 2\pi]$.
* $S$ sphere, $D=[0, 2\pi] \times [0, \pi]$.
* $Cy$ cylinder, $D=[0, 2\pi] \times [0,1]$.
* $T$ torus, $D = [0, 2\pi] \times [0, 2\pi]$. 

A few convenience methods are defined for manifolds such as:
* `boundary` which samples points on the boundary of a manifold's domain (e.g. on the unit square for the plane).
* `sample`, similar to boundary but also samples points in the interior of the domain. 


## AbstractManifoldObject
A variety of "objects" defined on a manifold can be defined, all subtypes of `AbstractManifoldObject`. 

### `Point`
Defines a point in the domain of a `Manifold`. 

```julia
p = Point(ℝ², [.4, .4])  # pass point coordinates as a vector
```

### `Normal`
The unit vector normal on a `Manifold` at a `Point`. Only works for *embedded* manifolds, see below. 

### `Parametrized Function`
Defines a function $f: [0, 1] \to \mathcal M$ from the unit interval to a `Manifold`('s domain).

```julia
fn = ParametrizedFunction("fn",  ℝ², x -> [sin(x), cos(x)])
```

The inner function (which can be anonymous) must return a `Vector` pointing a coordinates in `m`'s domain. 


### `ManifoldGrid`
A grid of equally spaced orthogonal parametrized functions spanning a `Manifold`'s domain. 


# Fields
In addition to `AbstractManifoldObject`, it's possible to defined (scalar/vector) fields on a `Manifold`. 

`ScalarField` objects are defined by a function $\psi(p) \to \mathbb R$ for $p \in \mathcal M$. 

`VectorField` objects have maps $\psi(p) \to \mathbb R^d$ assigning a d-dimensional vector at every point, with $d = dim(\mathcal M)$. 


# Embedding
Manifolds and objects/fields on them are defined and conceptualized as topological manifold, not as embedded in another (possibly larger) manifold such as Euclidean space $\mathbb R^n$. 

To embed a manifold (and all objects defined on it) in an another, one can use the `Embedding` type with the `embed` function. `Embed` defines the embedding map $\phi: \mathcal M \to \mathcal N$ and `embed(x, e)` applies the embedding `e` to an object `x`. 

It's also possible to **pushforward** tangent vectors (fields) on a manifold to tangent vector (fields) on an embedded manifold using a pushforward function $\phi^\star: T_p \mathcal M \to T_p \mathcal N$. The `pushforward(p, e)` gives $\phi^\star_p$ for a point $p \in \mathcal M$. 


# Others
The package also defines useful plotting recipies for visualizing almost everything that is used within the package. 

`./scripts` has a few examples illustrating how to use this package. 