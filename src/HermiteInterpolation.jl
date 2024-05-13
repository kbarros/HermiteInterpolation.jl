module HermiteInterpolation

function divided_differences(x, y, dy)
    T1 = promote_type(eltype(y), eltype.(dy)...)
    T2 = typeof(one(T1) / first(x))
    L = length(x)
    q = zeros(T2, L, L)

    # First column contains the y values
    q[:, 1] .= y

    # Remaining columns contain the divided differences or derivatives
    for i in 2:L, j in i:L
        if x[j] == x[j - i + 1]
            @assert i - 1 <= length(dy)
            q[j, i] = dy[i - 1][j] / factorial(i - 1)
        else
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
    fit(x, y, [y′, y″, ...])

Builds a polynomial fit to ``n`` sample points ``x`` with labels ``y``. The
remaining, optional arguments may provide derivative data, ``dʲy/dxʲ`` for ``j =
1, … m-1``. The Hermite interpolation procedure returns a unique polynomial of
degree less than ``m n``. Absent derivative data (``m = 1``) the method reduces
to Lagrange interpolation. 

As an example, one can infer the function ``y = x²`` from three labeled points:

```jl
f = HermiteInterpolation.fit([0, 1, 2], [0, 1, 4])
@assert f(3) ≈ 9
```

Or from a single point with derivative and curvature data:

```jl
f = HermiteInterpolation.fit([0], [0], [0], [2])
@assert f(3) ≈ 9
```

The fitting algorithm involves building a divided difference table, as
[described on Wikipedia](https://en.wikipedia.org/wiki/Hermite_interpolation).
"""
function fit(x, y, dy...)
    allequal(length.((x, y, dy...))) || error("Inputs arrays must have equal length")
    iszero(length(x)) && error("Input must be non-empty")
    allunique(x) || error("Sample points must be unique")

    # Duplicate each array element c times, corresponding to the order of
    # derivatives available. The call to `repeat` also ensures that we are
    # working in a 1-based indexing scheme (i.e., undo any special indexing if
    # the argument is an OffsetArray).
    c = 1 + length(dy)
    x = vec(repeat(vec(x)', c))
    y = vec(repeat(vec(y)', c))
    dy = [vec(repeat(vec(dyi)', c)) for dyi in dy]

    q = divided_differences(x, y, dy)
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
