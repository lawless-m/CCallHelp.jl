using Documenter
using CCallHelp
using Dates


makedocs(
    modules = [CCallHelp],
    sitename="CCallHelp.jl", 
    authors = "Matt Lawless",
    format = Documenter.HTML(),
)

deploydocs(
    repo = "github.com/lawless-m/CCallHelp.jl.git", 
    devbranch = "main",
    push_preview = true,
)
