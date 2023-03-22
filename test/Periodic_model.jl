@testset "Periodic_model.jl" begin
    p(x) = 1/10 .* cos.(2*π/365*x).+0.7

    Random.seed!(1234)
    periodic = plot_model_periodic(10^3,10^5,0,10^5,0,p,1,0.5,1.0,365,"etm")
    @test periodic[1][1] ≈ 44967
    @test periodic[1][2] ≈ 55033
    @test periodic[1][3] ≈ 0

    Random.seed!(1234)
    periodic = plot_model_periodic(10^3,10^5,0,10^5,0,p,10,1.0,1.0,365,"critical")
    @test periodic[1][1] ≈ 254
    @test periodic[1][2] ≈ 99746
    @test periodic[1][3] ≈ 0

    Random.seed!(1234)
    periodic = plot_model_periodic(10^3,10^5,0,10^5,0,p,1,0.3,1.0,365/2,"universal")
    @test periodic[1][1] ≈ 64731
    @test periodic[1][2] ≈ 35269
    @test periodic[1][3] ≈ 0
end