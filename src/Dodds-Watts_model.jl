module Dodds-Watts_model

import Base.+  
+(f::Function, g::Function) = (x...) -> f(x...) + g(x...)  

using Distributions
using Plots
using Random
using Roots
using LaTeXStrings
using DifferentialEquations
using Graphs
using GraphPlot
using Compose
using GraphRecipes
using SGtSNEpi
using GLMakie
using GraphPlot
using LinearAlgebra

export plot_model_cmm, plot_model_etm, plot_model_universal, plot_model_vacc, plot_model_network, plot_model_periodic

"""
Definition of the individual agents
"""
mutable struct Agent
    id::Int
    type::Int                   # 1-Susceptible 2-Infected 3-Removed
    dose::Array{Float64}        # dose count
    threshold::Float64          # dose threshold
    vaccine::Bool               # vaccinated yes or no
end

include("Epidemic_threshold.jl")
include("Critical_mass.jl")
include("Heterogeneity_model.jl")
include("Vaccination_model.jl")
include("Periodic_model.jl")
include("Network_model.jl")

end
