# HermiteInterpolation

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://kbarros.github.io/HermiteInterpolation.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kbarros.github.io/HermiteInterpolation.jl/dev/)
[![Build Status](https://github.com/kbarros/HermiteInterpolation.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/kbarros/HermiteInterpolation.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/kbarros/HermiteInterpolation.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/kbarros/HermiteInterpolation.jl)

This Julia package implements [Hermite interpolation](https://en.wikipedia.org/wiki/Hermite_interpolation). It takes a list of interpolation points $[x_1, x_2, …, x_n]$ and corresponding labels for $y(x)$. Derivative data $d^j y/dx^j$ may also be provided up to arbitrary order, $j = 1, …, m-1$. Hermite interpolation yields the unique polynomial less than order $m n$ that exactly matches the data. Without derivatives, the method is known as Lagrange interpolation.

### Usage example

Build an interpolation function with `fit`:

```jl
x = [1.5, 2.5, 3.5]
y = [1, 0, -1]
yp = [0, 0, 0]

import HermiteInterpolation
f = HermiteInterpolation.fit(x, y, yp)

@assert f(1.5) ≈ 1.0
```

See that the interpolation function matches the data for both $y$ and $y'$:

```jl
using GLMakie
x_range = 1.2:0.02:3.8
lines(x_range, f.(x_range))
plot!(x, y; markersize=12, color=:red)
```

<img src="./assets/hermite_fit.svg"></img>


The interpolation function can be evaluated on any type that supports addition and multiplication. For example, [DynamicPolynomials.jl](https://github.com/JuliaAlgebra/DynamicPolynomials.jl) can build the polynomial symbolically:

```jl
using DynamicPolynomials
@polyvar X

f_sym = f(X)
# -107.421875 + 246.09375X - 215.625X² + 91.25X³ - 18.75X⁴ + 1.5X⁵

fp_sym = differentiate(f_sym, X)
# 246.09375 - 431.25X + 273.75X² - 75.0X³ + 7.5X⁴

@assert f_sym(1.5) ≈ 1
@assert fp_sym(1.5) ≈ 0
```

