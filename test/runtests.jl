using Test
using HermiteInterpolation: HermiteInterpolation
using ForwardDiff: ForwardDiff

@testset "HermiteInterpolation.jl" begin
    x = [1, 2, 3]
    y = x .^ 2
    yp = [2, 4, 7]

    f = HermiteInterpolation.fit(x, y, yp)

    for i in 1:3
        @test f(x[i]) ≈ y[i]
        @test ForwardDiff.derivative(f, x[i]) ≈ yp[i]
    end
end
