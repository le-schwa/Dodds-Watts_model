# Dodds-Watts with vacciantion
include("Epidemic_threshold.jl")
include("Critical_mass.jl")
include("Heterogeneity_model.jl")

"""
Plots a simulation of the vaccination model for t timesteps, N individuals, S suscpetibles, I infected, R recoverd, exposure probability p, memory T, recovery rate r, probabiltiy imunity loss ρ, vaccination rate v and strength s
The vaccination rate determines how many of the agents are being vaccinated. Their threshold will be raised by the vaccine strength s.
The variable version determines the underlying model:
"etm" = epidemic threshold model
"ciritical" = critical mass model
"universal" = heterogeneity model
"""
function plot_model_vacc(t::Int64,N::Int64,S::Int64,I::Int64,R::Int64,p::Float64,T::Int64,r::Float64,ρ::Float64,v::Float64,s::Int64,version) 
    Sus = [S]
    Infec = [I]
    Recov = [R]

    if version == "etm"
        agents = initialize_etm(N,I)
        for i=1:t
            if i == t/2
                for j=1:convert(Int,round(N*v))
                    agents[j].vaccine = true
                    agents[j].threshold = agents[j].threshold + s
                end
            end
            timestep_etm(agents,N,Sus,Infec,Recov,p,T,r,ρ)
        end
    elseif version == "critical"
        agents = initialize_cmm(N,I,3)
        for i=1:t
            if i == t/2
                for j=1:convert(Int,round(N*v))
                    agents[j].vaccine = true
                    agents[j].threshold = agents[j].threshold + s
                end
            end
            timestep_cmm(agents,N,Sus,Infec,Recov,p,T,r,ρ)
        end
    elseif version == "universal"
        agents = initialize_universal(N,I)
        for i=1:t
            if i == t/2
                for j=1:convert(Int,round(N*v))
                    agents[j].vaccine = true
                    agents[j].threshold = agents[j].threshold + s
                end
            end
            timestep_universal(agents,N,Sus,Infec,Recov,p,T,r,ρ)
        end
    end

    x = 1:t+1
    p = Plots.plot(x,[Sus,Infec,Recov],ylims = (0,N),label=["S" "I" "R"],linecolor = [:blue :red :green],xlabel = "time t", ylabel = "number of individuals", legend = :outertopright)
    display(p)
    return [Sus[t+1],Infec[t+1],Recov[t+1]], p
end