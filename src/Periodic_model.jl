include("Epidemic_threshold.jl")
include("Critical_mass.jl")
include("Heterogeneity_model.jl")

"""
Plots a simulation of the model spcified in version for t timesteps with an periodic distribution function p(t)
"""
function plot_model_periodic(t::Int64,N::Int64,S::Int64,I::Int64,R::Int64,p,T::Int64,r::Float64,ρ::Float64,P,version) 
    Sus = [S]
    Infec = [I]
    Recov = [R]

    if version == "etm"
        agents = initialize_etm(N,I)
        for i=1:t
            timestep_etm(agents,N,Sus,Infec,Recov,p(i),T,r,ρ)
        end
        f1(x) = 1-(r*(1-p(0)*x)^T)/(1-(1-p(0)*x)*(1-r))-x
        ϕ1 = find_zero(f1,0.5)
        f2(x) = 1-(r*(1-p(P/2)*x)^T)/(1-(1-p(P/2)*x)*(1-r))-x
        ϕ2 = find_zero(f2,0.5)
        if T == 1
            f3(x) = (r .- p(x)) ./ (p(x) .* (r-1))
        end
        x = 1:t+1
        Plots.plot(x,[Sus,Infec,Recov],ylims = (0,N),label=["S" "I" "R"],linecolor = [:blue :red :green],xlabel = "time t", ylabel = "number of individuals", legend = :outertopright)
        y1 = fill(N*ϕ1,t+1)
        y2= fill(N*ϕ2,t+1)
        if T == 1
            Plots.plot!(x,N*f3(x),label=L"\phi^{*}",linecolor=:orange)
        end
        Plots.plot!(x,[y1],label=L"\phi^{*}_{max}")
        Plots.plot!(x,[y2],label=L"\phi^{*}_{min}")
        p = Plots.plot!(x,N*p(x),label="p(t)",linecolor=:grey)
        display(p)
    elseif version == "critical"
        agents = initialize_cmm(N,I,3)
        for i=1:t
            timestep_cmm(agents,N,Sus,Infec,Recov,p(i),T,r,ρ)
        end
        d = 3
        pnull = p(0)
        m = Array{Function}(undef,T-(d-1),1)
        for i=0:T-d
            f(x) = binomial(T,i+d)*(pnull*x)^(i+d)*(1-pnull*x)^(T-(i+d))
            m[i+1] = f
        end
        h(x) = sum(m)(x)-x
        try 
            global ϕ11 = find_zero(h,0.8)
        catch e
            global ϕ11 = find_zero(h,0.1)
        end
        y1 = fill(N*ϕ11,t+1)
        phalf = p(P/2)
        m2 = Array{Function}(undef,T-(d-1),1)
        for i=0:T-d
            a(x) = binomial(T,i+d)*(phalf*x)^(i+d)*(1-phalf*x)^(T-(i+d))
            m2[i+1] = a
        end
        h2(x) = sum(m2)(x)-x
        try 
            global ϕ22 = find_zero(h2,0.8)
        catch e
            global ϕ22 = find_zero(h2,0.1)
        end
        y2= fill(N*ϕ22,t+1)
        x = 1:t+1
        Plots.plot(x,[Sus,Infec,Recov],ylims = (0,N),label=["S" "I" "R"],linecolor = [:blue :red :green],xlabel = "time t", ylabel = "number of individuals", legend = :outertopright)
        if T == 1
            Plots.plot!(x,N*f3(x),label=L"\phi^{*}",linecolor=:orange)
        end
        Plots.plot!(x,[y1],label=L"\phi^{*}_{max}")
        Plots.plot!(x,[y2],label=L"\phi^{*}_{min}")
        p = Plots.plot!(x,N*p(x),label="p(t)",linecolor=:grey)
        display(p)
    elseif version == "universal"
        agents = initialize_universal(N,I)
        for i=1:t
            timestep_universal(agents,N,Sus,Infec,Recov,p(i),T,r,ρ)
        end
        x = 1:t+1
        p = Plots.plot(x,[Sus,Infec,Recov],ylims = (0,N),label=["S" "I" "R"],linecolor = [:blue :red :green],xlabel = "time t", ylabel = "number of individuals", legend = :outertopright)
        display(p)
    end

    return [Sus[t+1],Infec[t+1],Recov[t+1]], p
end