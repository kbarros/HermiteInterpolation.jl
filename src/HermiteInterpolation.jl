module HermiteInterpolation

function divided_differences(x, y, yp)
    T1 = promote_type(eltype(y), eltype(yp))
    T2 = typeof(one(T1) / first(x))
    n = length(x)
    q = zeros(T2, n, n)

    # First column are the y values
    i = 1
    q[:, i] .= y

    # Second column involves derivative data
    i = 2
    for j in i:n
        if x[j] == x[j - 1]
            q[j, i] = yp[j]
        else
            q[j, i] = (y[j] - y[j - 1]) / (x[j] - x[j - i + 1])
        end
    end

    # Remaining columns are the usual divided differences
    for i in 3:n
        for j in i:n
            q[j, i] = (q[j, i - 1] - q[j - 1, i - 1]) / (x[j] - x[j - i + 1])
        end
    end

    return q
end

struct Fit{T1,T2}
    x::Vector{T1}
    d::Vector{T2}
end

"""
    fit(x, y, [yp, ypp, ...])

Builds a polynomial fit to the data at sample points ``x`` with labels ``y``.
The remaining, optional arguments may provide derivative data, ``dⁿy/dxⁿ`` for
``n = 1, … m-1``. The Hermite interpolation procedure returns a unique
polynomial of order ``m n`` or smaller. Without derivative data, ``m = 1``, the
method reduces to Lagrange interpolation. 

## Example

```jl
f = HermiteInterpolation.fit([1, 2], [1, 4])
@assert f(3) ≈ 9
```

A full description of the Hermite interpolation algorithm is described on the
[Wikipedia page](https://en.wikipedia.org/wiki/Hermite_interpolation).
"""
function fit(x, y, yp)
    allequal(length.((x, y, yp))) || error("Inputs arrays must have equal length")
    iszero(length(x)) && error("Input must be non-empty")

    # Double the array length through element duplication, and simultaneously
    # ensure vectors with 1-based indexing
    x = vec(repeat(vec(x)', 2))
    y = vec(repeat(vec(y)', 2))
    yp = vec(repeat(vec(yp)', 2))

    q = divided_differences(x, y, yp)
    d = [q[i, i] for i in axes(q, 1)]

    return Fit(x, d)
end

function (f::Fit)(x0)
    (; x, d) = f
    p = 0
    term = 1
    for (xi, di) in zip(x, d)
        p += term * di
        term *= (x0 - xi)
    end
    return p
end

end
