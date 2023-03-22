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

type 1: Susceptible
type 2: Infected
type 3: Removed

dose: Count of received dosages

threshold: individual dose threshold; if the agents exceeds its threshold, it becomes infected

vaccine: Vaccinated yes or no
"""
mutable struct Agent
    id::Int
    type::Int                
    dose::Array{Float64}       
    threshold::Float64          
    vaccine::Bool              
end

include("Epidemic_threshold.jl")
include("Critical_mass.jl")
include("Heterogeneity_model.jl")
include("Vaccination_model.jl")
include("Periodic_model.jl")
include("Network_model.jl")

end
