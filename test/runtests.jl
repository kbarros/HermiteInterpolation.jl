using Test
using HermiteInterpolation: HermiteInterpolation
using ForwardDiff: ForwardDiff

@testset "Basic fits" begin
    # y = x²
    f = HermiteInterpolation.fit([0, 1, 2], [0, 1, 4])
    @test f(3) ≈ 9

    # y = x²
    f = HermiteInterpolation.fit([0], [0], [0], [2])
    @test f(3) ≈ 9

    # Example from Wikipedia, y = x⁸ + 1
    f = HermiteInterpolation.fit([-1, 0, 1], [2, 1, 2], [-8, 0, 8], [56, 0, 56])
    @test f.d ≈ [2, -8, 28, -21, 15, -10, 4, -1, 1]
    @test f(π) ≈ π^8 + 1
end

@testset "FiniteDiff compatibility" begin
    x = [1, 2, 3]
    y = x .^ 2
    yp = [2, 4, 7]
    f = HermiteInterpolation.fit(x, y, yp)
    for i in 1:3
        @test f(x[i]) ≈ y[i]
        @test ForwardDiff.derivative(f, x[i]) ≈ yp[i]
    end
end

@testset "Over rationals" begin
    f = HermiteInterpolation.fit([-1, 0, 1] // 1, [2, 1, 2], [-8, 0, 8], [56, 0, 56])
    @test f(1//3) == (1//3)^8 + 1
end

@testset "Errors" begin
    @test_throws "Inputs arrays must have equal length" HermiteInterpolation.fit([1, 2], [3])
    @test_throws "Input must be non-empty" HermiteInterpolation.fit([], [])
    @test_throws "Sample points must be unique" HermiteInterpolation.fit([0, 1, 0], [0, 1, 2])
end