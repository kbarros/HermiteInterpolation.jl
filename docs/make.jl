using HermiteInterpolant
using Documenter

DocMeta.setdocmeta!(HermiteInterpolant, :DocTestSetup, :(using HermiteInterpolant); recursive=true)

makedocs(;
    modules=[HermiteInterpolant],
    authors="Kipton Barros <kbarros@gmail.com> and contributors",
    sitename="HermiteInterpolant.jl",
    format=Documenter.HTML(;
        canonical="https://kbarros.github.io/HermiteInterpolant.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/kbarros/HermiteInterpolant.jl",
    devbranch="main",
)
