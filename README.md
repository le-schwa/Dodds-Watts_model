# Dodds_Watts_model

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://le-schwa.github.io/Dodds-Watts_model.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://le-schwa.github.io/Dodds-Watts_model.jl/dev/)
[![Build Status](https://github.com/le-schwa/Dodds-Watts_model.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/le-schwa/Dodds-Watts_model.jl/actions/workflows/CI.yml?query=branch%3Amain)

This repository contains an implementation of the Dodds-Watts model (see https://www.sciencedirect.com/science/article/abs/pii/S0022519304004515?via%3Dihub). 

The main parameters are:
N           Population of N individuals
S           Number of suscpetible individuals
I           Number of infected individuals
R           Number of removed individuals
p           Exposure probability
T           Memory
r           Probability of moving from infected to recovered state
ρ           Probability of moving from immune to suscpetible state

Different cases are being distinguished:
1.  Epidemic threshold model (d* = 1, ρ = 1)
    Example:    plot_model_etm(10^3,10^5,0,10^5,0,0.6,1,0.5,1.0)
                This plots the epidemic threshold model for t = 10^3, N = 10^5, S = 0, I = 10^5, R = 0, p = 0.6, T = 1, r = 0.5, ρ = 1  
2.  Ciritcal mass model (d* > 1, ρ = 1, r = 1)
    Example:    plot_model_cmm(10^3,10^5,0,10^5,0,0.45,12,1.0,1.0,3)
                This plots the critical mass model for t = 10^3, N = 10^5, S = 0, I = 10^5, R = 0, p = 0.45, T = 12, r = 1, ρ = 1, d* = 3
3.  Heterogeneity model 
    Example:    plot_model_universal(10^3,10^5,0,10^5,0,0.8,1,0.2,1.0)
                This plots the heterogeneity model for t = 10^3, N = 10^5, S = 0, I = 10^5, R = 0, p = 0.8, T = 1, r = 0.2, ρ = 1
                As an example, the threshold distribution is set to Gamma(1,1) and the dose distribution is set to LogNormal()
                The threshold and dose distribution can be changed at the corresponding marked spots in the code of the file Heterogeneity_model.jl
4.  Network model
    Example:    g = barabasi_albert(10^5,7,5)
                This generates a random graph according to the barabasi albert algorithm
                plot_model_network(10^3,10^5,0,10^5,0,0.6,1,0.5,1.0,"etm",g)
                This plots the epidemic threshold model for t = 10^3, N = 10^5, S = 0, I = 10^5, R = 0, p = 0.6, T = 1, r = 0.5, ρ = 1, with underlying network g
5.  Periodic model
    Example:    p(x) = 1/10 .* cos.(2*π/365*x).+0.7
                plot_model_periodic(10^3,10^5,0,10^5,0,p,1,0.5,1.0,365,"etm")
                This plots the epidemic threshold model for t = 10^3, N = 10^5, S = 0, I = 10^5, R = 0, function p, T = 1, r = 0.5, ρ = 1, with the periodic distribution function g with Period 365
6.  Vaccination model
    Example:    plot_model_vacc(10^3,10^5,0,10^5,0,0.4,4,0.3,1.0,0.6,5,"etm")
                This plots the epidemic threshold model for t = 10^3, N = 10^5, S = 0, I = 10^5, R = 0, p = 0.4, T = 4, r = 0.3, ρ = 1, vaccination rate 0.6 and vaccine strength 5
    

[Documentation](https://le-schwa.github.io/Dodds_Watts_model/dev/)