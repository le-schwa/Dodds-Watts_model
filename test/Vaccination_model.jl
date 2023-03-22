@testset "Vaccination_model.jl" begin

    Random.seed!(1234)
    vacc = plot_model_vacc(10^3,10^5,0,10^5,0,0.4,4,0.3,1.0,0.6,5,"etm")
    @test vacc[1][1] ≈ 98998
    @test vacc[1][2] ≈ 1002
    @test vacc[1][3] ≈ 0

    Random.seed!(1234)
    vacc = plot_model_vacc(10^3,10^5,0,10^5,0,0.4,4,1.0,1.0,0.6,5,"critical")
    @test vacc[1][1] ≈ 100000
    @test vacc[1][2] ≈ 0
    @test vacc[1][3] ≈ 0

    Random.seed!(1234)
    vacc = plot_model_vacc(10^3,10^5,0,10^5,0,0.4,4,1.0,1.0,0.6,5,"universal")
    @test vacc[1][1] ≈ 100000
    @test vacc[1][2] ≈ 0
    @test vacc[1][3] ≈ 0
end