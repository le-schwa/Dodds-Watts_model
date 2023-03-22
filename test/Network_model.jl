@testset "Network_model.jl" begin
    Random.seed!(1234)
    g = SimpleGraph(10^5,2*10^5)

    Random.seed!(1234)
    network = plot_model_network(10^3,10^5,0,10^5,0,0.6,1,0.5,1.0,"etm",g)
    @test network[1][1] ≈ 91869
    @test network[1][2] ≈ 8131
    @test network[1][3] ≈ 0

    Random.seed!(1234)
    network = plot_model_network(10^3,10^5,0,10^5,0,0.45,12,1.0,1.0,"critical",g)
    @test network[1][1] ≈ 11278
    @test network[1][2] ≈ 88722
    @test network[1][3] ≈ 0

    Random.seed!(1234)
    network = plot_model_network(10^3,10^5,0,10^5,0,0.8,1,0.2,1.0,"universal",g)
    @test network[1][1] ≈ 60584
    @test network[1][2] ≈ 39416
    @test network[1][3] ≈ 0


    Random.seed!(1234)
    g = barabasi_albert(10^5,7,5)
    Random.seed!(1234)
    network = plot_model_network(10^3,10^5,0,10^5,0,0.6,1,0.5,1.0,"etm",g)
    @test network[1][1] ≈ 74267
    @test network[1][2] ≈ 25733
    @test network[1][3] ≈ 0

    Random.seed!(1234)
    network = plot_model_network(10^3,10^5,0,10^5,0,0.45,12,1.0,1.0,"critical",g)
    @test network[1][1] ≈ 7094
    @test network[1][2] ≈ 92906
    @test network[1][3] ≈ 0

    Random.seed!(1234)
    network = plot_model_network(10^3,10^5,0,10^5,0,0.8,1,0.2,1.0,"universal",g)
    @test network[1][1] ≈ 54430
    @test network[1][2] ≈ 45570
    @test network[1][3] ≈ 0
end