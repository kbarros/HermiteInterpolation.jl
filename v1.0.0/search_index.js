var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = HermiteInterpolation","category":"page"},{"location":"#HermiteInterpolation","page":"Home","title":"HermiteInterpolation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"See project page at HermiteInterpolation for more examples.","category":"page"},{"location":"","page":"Home","title":"Home","text":"fit","category":"page"},{"location":"#HermiteInterpolation.fit","page":"Home","title":"HermiteInterpolation.fit","text":"fit(x, y, [y′, y″, ...])\n\nBuilds a polynomial fit to the sample points x with labels y. The remaining, optional arguments may provide derivative data, dⁿydxⁿ for n = 1  m-1. The Hermite interpolation procedure returns a unique polynomial of degree less than m n. Absent derivative data (m = 1) the method reduces to Lagrange interpolation. \n\nAs an example, one can infer the function y = x² from three labeled points:\n\nf = HermiteInterpolation.fit([0, 1, 2], [0, 1, 4])\n@assert f(3) ≈ 9\n\nOr from a single point with derivative and curvature data:\n\nf = HermiteInterpolation.fit([0], [0], [0], [2])\n@assert f(3) ≈ 9\n\nThe fitting algorithm involves building a divided difference table, as described on Wikipedia.\n\n\n\n\n\n","category":"function"}]
}
