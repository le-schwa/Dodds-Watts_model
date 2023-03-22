using Dodds_Watts_model
using Documenter

DocMeta.setdocmeta!(Dodds_Watts_model, :DocTestSetup, :(using Dodds_Watts_model); recursive=true)

makedocs(;
    modules=[Dodds_Watts_model],
    authors="Leander Schwarzmeier <leander-schwarzmeier@web.de>",
    repo="https://github.com/le-schwa/Dodds_Watts_model.jl/blob/{commit}{path}#{line}",
    sitename="Dodds_Watts_model.jl Documentation",
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
    repo = "github.com/le-schwa/Dodds_Watts_model.git",
)