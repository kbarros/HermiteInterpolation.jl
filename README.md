# HermiteInterpolation

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://kbarros.github.io/HermiteInterpolation.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kbarros.github.io/HermiteInterpolation.jl/dev/)
[![Build Status](https://github.com/kbarros/HermiteInterpolation.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/kbarros/HermiteInterpolation.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/kbarros/HermiteInterpolation.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/kbarros/HermiteInterpolation.jl)

This Julia package implements [Hermite
interpolation](https://en.wikipedia.org/wiki/Hermite_interpolation) for a scalar
function $y(x)$. Specifically, for a given list of interpolation points $[x_1,
x_2, …, x_n]$, assume we have data for the function $y(x_i)$ and some number
$m-1$ of its derivatives $y'(x_i), y''(x_i), …$. Hermite interpolation provides the
unique interpolating polynomial, up to order $m n$, which exactly matches this
data.

Example:

```jl
import HermiteInterpolation

x = [1.5, 2.5, 3.5] # interpolating points
y = [1, 0, -1] # values
yp = [0, 0, 0] # derivatives

f = HermiteInterpolation.fit(x, y, yp)

# Evaluate the interpolating polynomial numerically
@assert f(1.5) ≈ 1
@assert f(2.5) ≈ 0
@assert f(3.5) ≈ -1

# Evaluate in a symbolic variable X

import DynamicPolynomials as DP

DP.@polyvar X
f_sym = f(X) # -107.421875 + 246.09375X - 215.625X² + 91.25X³ - 18.75X⁴ + 1.5X⁵
fp_sym = DP.differentiate(f_sym, X) # 246.09375 - 431.25X + 273.75X² - 75.0X³ + 7.5X⁴
@assert f_sym(1.5) ≈ 1
@assert fp_sym(1.5) ≈ 0
```

