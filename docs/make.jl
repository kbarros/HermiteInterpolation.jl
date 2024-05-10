using HermiteInterpolation
using Documenter

DocMeta.setdocmeta!(HermiteInterpolation, :DocTestSetup, :(using HermiteInterpolation); recursive=true)

makedocs(;
    modules=[HermiteInterpolation],
    authors="Kipton Barros <kbarros@gmail.com> and contributors",
    sitename="HermiteInterpolation.jl",
    format=Documenter.HTML(;
        canonical="https://kbarros.github.io/HermiteInterpolation.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/kbarros/HermiteInterpolation.jl",
    devbranch="main",
)
