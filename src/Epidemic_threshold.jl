"""
Initializes agents for the epidemic threhsold model
"""
function initialize_etm(N::Int64,I::Int64)
    agents = Agent[]

    for i = 1:N
        push!(agents, Agent(i,1,[0],rand(Dirac(1)),false))
    end

    for i = 1:I
        agents[i].type = 2
        agents[i].dose[1] = agents[i].threshold
    end

    return agents
end


"""
Performs a time step for the epidemic threshold model
"""
function timestep_etm(agents::Vector{Agent},N::Int64,S::Array{Int64},I::Array{Int64},R::Array{Int64},p::Float64,T::Int64,r::Float64,ρ::Float64)

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
            d = rand(Dirac(1));
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
Plots a simulation of the epidemic threshold model
"""
function plot_model_etm(t::Int64,N::Int64,S::Int64,I::Int64,R::Int64,p::Float64,T::Int64,r::Float64,ρ::Float64) 
    agents = initialize_etm(N,I)
    f(x) = 1-(r*(1-p*x)^T)/(1-(1-p*x)*(1-r))-x
    ϕ1 = find_zero(f,0.5)
    Sus = [S]
    Infec = [I]
    Recov = [R]
    for i=1:t
        timestep_etm(agents,N,Sus,Infec,Recov,p,T,r,ρ)
    end
    x = 1:t+1
    Plots.plot(x,[Sus,Infec,Recov],ylims = (0,N),label=["S" "I" "R"],linecolor = [:blue :red :green],xlabel = "time t", ylabel = "number of individuals", legend = :outertopright)
    y1 = fill(N*ϕ1,t+1)
    p = Plots.plot!(x,y1,label=L"\phi^{*}")
    display(p)
    return [Sus[t+1],Infec[t+1],Recov[t+1]], p, ϕ1
end


"""
# plots the stable fixed point curve of the Epidemic threshold model
"""
function fixed_point_curve_etm(T::Int64,r::Float64)
    b = zeros(100,2)
    p = range(0,1,100)
    p[2]
    for i = 1:100
        f(x) = 1-(r*(1-p[i]*x)^T)/(1-(1-p[i]*x)*(1-r))-x
        ϕ = find_zero(f,0.5)
        b[i,1] = p[i]
        b[i,2] = ϕ
    end

    p_c = 1/(T+1/r-1)
    g(x) = 1-(r*(1-p_c*x)^T)/(1-(1-p_c*x)*(1-r))-x
    ϕ2 = find_zero(g,0.5)

    h(x) = 0*x
    x = range(p_c,1,100)

    Plots.plot(b[:,1],b[:,2],ls=:dot, xlabel="p", ylabel=L"\phi^{*}", title= "Stable fixed point curve", label = "Stable fixed points")
    Plots.scatter!([p_c],[ϕ2],color="red",label=String("Critical Value = $p_c"))
    p = Plots.plot!(x,h(x),color="red",label="Unstable fixed point")
    display(p)
    return [p_c,ϕ2], p
end

"""
# plots the corresponding ODE to the epidemic threshold model
"""
function plot_ode(N::Int64,p::Float64,r::Float64)
    function sir_ode2(du,u,p,t)
        S,I = u
        b,g = p
        du[1] = -b*S*I+g*I
        du[2] = b*S*I-g*I
    end
    parms = [p,(1-p)/(1-r)*r]
    init = [0.5,0.5]
    tspan = (0.0,10^3)
    sir_prob2 = ODEProblem(sir_ode2,init,tspan,parms)
    sir_sol = solve(sir_prob2,saveat = 0.1)
    sir_sol = N*sir_sol
    Plots.plot([sir_sol[1,:]],ylims=(0,N))
    p = Plots.plot!([sir_sol[2,:]])

    return p
end