"""
Initializes N agents with threshold d, where I are infected for the critical mass model
"""
function initialize_cmm(N::Int64,I::Int64,d::Int64)
    agents = Agent[]

    for i = 1:N
        push!(agents, Agent(i,1,[0],rand(Dirac(d)),false))
    end

    for i = 1:I
        agents[i].type = 2
        agents[i].dose[1] = agents[i].threshold
    end

    return agents
end

"""
Performs a time step for the critical mass model
"""
function timestep_cmm(agents::Vector{Agent},N::Int64,S::Array{Int64},I::Array{Int64},R::Array{Int64},p::Float64,T::Int64,r::Float64,ρ::Float64)

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
Plots a simulation of the critical mass model for t timesteps, N individuals, S suscpetibles, I infected, R recoverd, exposure probability p, memory T, recovery rate r, probabiltiy imunity loss ρ, threshold d
"""
function plot_model_cmm(t::Int64,N::Int64,S::Int64,I::Int64,R::Int64,p::Float64,T::Int64,r::Float64,ρ::Float64,d::Int64) 
    agents = initialize_cmm(N,I,d)
    Sus = [S]
    Infec = [I]
    Recov = [R]
    m = Array{Function}(undef,T-(d-1),1)
    for i=0:T-d
        f(x) = binomial(T,i+d)*(p*x)^(i+d)*(1-p*x)^(T-(i+d))
        m[i+1] = f
    end
    h(x) = sum(m)(x)-x
    try 
        global ϕ = find_zero(h,0.8)
    catch e
        global ϕ = find_zero(h,0.1)
    end
    for i=1:t
        timestep_cmm(agents,N,Sus,Infec,Recov,p,T,r,ρ)
    end
    x = 1:t+1
    Plots.plot(x,[Sus,Infec,Recov],ylims = (0,N),label=["S" "I" "R"],linecolor = [:blue :red :green],xlabel = "time t", ylabel = "number of individuals", legend = :outertopright)
    y1 = fill(N*ϕ,t+1)
    p = Plots.plot!(x,y1,label=L"\phi^{*}")
    display(p)

    return [Sus[t+1],Infec[t+1],Recov[t+1]], p, ϕ
end

"""
Plots the fixed point curve for the critical mass model according to the memory T and threshold d
"""
function fixed_point_curve_cmm(T::Int64,d::Int64)
    m = Array{Function}(undef,T-(d-1),1)
    for i=0:T-d
        f(x) = binomial(T,i+d)*(x)^(i+d-d)*(1-x)^(T-(i+d)-1)*(i+d-1-x*(T-1))
        m[i+1] = f
    end
    h(x) = sum(m)(x)
    z = find_zero(h,0.5)

    n = Array{Function}(undef,T-(d-1),1)
    for i=0:T-d
        g(x) = binomial(T,i+d)*(x)^(i+d)*(1-x)^(T-(i+d))
        n[i+1] = g
    end
    l(x) = sum(n)(x)
    p_b = z/l(z)

 
    c1 = zeros(100,2)
    c2 = zeros(100,2)
    p = range(p_b,1,100)
    

    for i = 1:100
        w = Array{Function}(undef,T-(d-1),1)
        for j=0:T-d
            a(x) = binomial(T,j+d)*(p[i]*x)^(j+d)*(1-p[i]*x)^(T-(j+d))
            w[j+1] = a
        end
        b(x) = sum(w)(x)-x
        ϕ1 = find_zero(b,p_b+0.4)
        ϕ2 = find_zero(b,p_b-0.1)
        c1[i,1] = p[i]
        c2[i,1] = p[i]
        c1[i,2] = ϕ1
        c2[i,2] = ϕ2
    end

    q(x) = 0*x
    x = range(0,1,100)

    Plots.plot(c1[:,1],c1[:,2],ls=:dot, xlabel="p", ylabel=L"\phi^{*}", title= "Stable fixed point curve", label = "Stable fixed points",legend = :outertopright)
    Plots.scatter!([p_b],[l(z)],color="red",label=String("Critical Value = $p_b"))
    Plots.plot!(x,q(x),color="blue",label="Stable fixed point")
    p = Plots.plot!(c2[:,1],c2[:,2],ls=:dot,label="Unstable fixed points",color="red")
    display(p)
    return [p_b,l(z)], p
end