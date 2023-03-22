"""
Initializes N agents, where I are infected for the epidemic threhsold model. The threshold distribution is set to Gamma(1,1)
"""
function initialize_universal(N::Int64,I::Int64)
    agents = Agent[]

    for i = 1:N
        push!(agents, Agent(i,1,[0],rand(Gamma(1,1)),false))    # Set here the distribution which determines the thresholds for the agents
    end

    for i = 1:I
        agents[i].type = 2
        agents[i].dose[1] = agents[i].threshold
    end

    return agents
end


"""
Performs a time step for the heterogeneity model. The dose distribution is set to LogNormal()
"""
function timestep_universal(agents::Vector{Agent},N::Int64,S::Array{Int64},I::Array{Int64},R::Array{Int64},p::Float64,T::Int64,r::Float64,ρ::Float64)

    for i=1:N

        # Determine the contact c of i
        c = rand(DiscreteUniform(1,N-1));
        if c == i
            c = N
        end

        # Agent i receives dose
        if p>=1
            p = 1
        end
        if p<=0
            p = 0
        end
        if agents[c].type == 2 && (agents[i].type == 1 || agents[i].type == 2) && rand(Bernoulli(p)) == true 
            d = rand(LogNormal());         # Set here the distribution which determines the dose sizes
            pushfirst!(agents[i].dose,d);
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
Plots a simulation of the heterogeneity model for t timesteps, N individuals, S suscpetibles, I infected, R recoverd, exposure probability p, memory T, recovery rate r, probabiltiy imunity loss ρ
"""
function plot_model_universal(t::Int64,N::Int64,S::Int64,I::Int64,R::Int64,p::Float64,T::Int64,r::Float64,ρ::Float64) 
    agents = initialize_universal(N,I)
    Sus = [S]
    Infec = [I]
    Recov = [R]
    for i=1:t
        timestep_universal(agents,N,Sus,Infec,Recov,p,T,r,ρ)
    end
    x = 1:t+1
    p = Plots.plot(x,[Sus,Infec,Recov],ylims = (0,N),label=["S" "I" "R"],linecolor = [:blue :red :green],xlabel = "time t", ylabel = "number of individuals", legend = :outertopright)
    display(p)
    return [Sus[t+1],Infec[t+1],Recov[t+1]], p
end