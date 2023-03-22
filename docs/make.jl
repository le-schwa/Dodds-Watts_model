using Dodds-Watts_model
using Documenter

DocMeta.setdocmeta!(Dodds-Watts_model, :DocTestSetup, :(using Dodds-Watts_model); recursive=true)

makedocs(;
    modules=[Dodds-Watts_model],
    authors="Leander Schwarzmeier <leander-schwarzmeier@web.de>",
    repo="https://github.com/le-schwa/Dodds-Watts_model.jl/blob/{commit}{path}#{line}",
    sitename="Dodds-Watts_model.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(
    repo = "github.com/le-schwa/Dodds-Watts_model.git",
)