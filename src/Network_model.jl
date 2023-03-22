include("Epidemic_threshold.jl")
include("Critical_mass.jl")
include("Heterogeneity_model.jl")

"""
Performs a time step for the Dodds-Watts model with a network g
"""
function timestep_network(agents::Vector{Agent},N::Int64,S::Array{Int64},I::Array{Int64},R::Array{Int64},p::Float64,T::Int64,r::Float64,ρ::Float64,g)

    for i=1:N

        n = Graphs.neighbors(g,i)

        if length(n) != 0
            # Determine the contact c of i
            c = n[rand(DiscreteUniform(1,length(n)))];

            # Agent i receives dose
            if p>=1
                p = 1
            end
            if p<=0
                p = 0
            end
            if agents[c].type == 2 && (agents[i].type == 1 || agents[i].type == 2) && rand(Bernoulli(p)) == true 
                d = rand(Dirac(1));
                pushfirst!(agents[i].dose,d);
            else
                pushfirst!(agents[i].dose,0);
            end
        else
            pushfirst!(agents[i].dose,0);
        end
        # updating the dose cout of the individual i
        if length(agents[i].dose) > T
            pop!(agents[i].dose);
        end

        # updating the status of the individual i
        D = sum(agents[i].dose);
        if agents[i].type == 1
            if D < agents[i].threshold 
                agents[i].type = 1; 
            else
                agents[i].type = 2;
            end
        elseif agents[i].type == 2
            if D >= agents[i].threshold 
                agents[i].type = 2;
            elseif D < agents[i].threshold 
                z = rand(Categorical([r*ρ,1-r,r*(1-ρ)]));
                if z == 1 
                    agents[i].type = 1;
                elseif z == 2
                    agents[i].type = 2;
                else 
                    agents[i].type = 3;
                end
            end
        elseif agents[i].type == 3
            if rand(Bernoulli(ρ)) == true
                agents[i].type = 1;
            else
                agents[i].type = 3;
            end
        end
    end

    sus = 0;
    inf = 0;
    rem = 0;
    for j=1:N
        if agents[j].type == 1
            sus = sus+1;
        elseif agents[j].type == 2
            inf = inf+1;
        elseif agents[j].type == 3
            rem = rem+1;
        end
    end
    push!(S,sus);
    push!(I,inf);
    push!(R,rem);
end

"""
Plots a simulation of the model spcified in version for t timesteps with an underlying network
"""
function plot_model_network(t::Int64,N::Int64,S::Int64,I::Int64,R::Int64,p::Float64,T::Int64,r::Float64,ρ::Float64,version,g) 
    Sus = [S]
    Infec = [I]
    Recov = [R]

    if version == "etm"
        agents = initialize_etm(N,I)
        for i=1:t
            timestep_network(agents,N,Sus,Infec,Recov,p,T,r,ρ,g)
        end
    elseif version == "critical"
        agents = initialize_cmm(N,I,3)
        for i=1:t
            timestep_network(agents,N,Sus,Infec,Recov,p,T,r,ρ,g)
        end
    elseif version == "universal"
        agents = initialize_universal(N,I)
        for i=1:t
            timestep_network(agents,N,Sus,Infec,Recov,p,T,r,ρ,g)
        end
    end

    x = 1:t+1
    p = Plots.plot(x,[Sus,Infec,Recov],ylims = (0,N),label=["S" "I" "R"],linecolor = [:blue :red :green],xlabel = "time t", ylabel = "number of individuals", legend = :outertopright)
    display(p)
    return [Sus[t+1],Infec[t+1],Recov[t+1]], p
end


"""
Plots an embedding of the graph g
"""
function plot_network(g)
    G = sgtsnepi(g)
    display(show_embedding(G;A=Adj,mrk_size=10))
end