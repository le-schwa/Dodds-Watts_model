module Dodds_Watts_model

export initialize_cmm,timestep_cmm,plot_model_cmm,fixed_point_curve_cmm,initialize_etm,timestep_etm, plot_model_etm,fixed_point_curve_etm,plot_ode, 
initialize_universal, timestep_universal, plot_model_universal,timestep_network, plot_model_network, plot_network, plot_model_periodic, plot_model_vacc

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
using GraphPlot
using LinearAlgebra

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
