@testset "Heterogeneity_model.jl" begin
    Random.seed!(1234)

    init = Dodds_Watts_model.initialize_universal(2,1)
    @test init[1].id == 1
    @test init[1].type == 2
    @test init[1].dose == [0.5568317224842397]
    @test init[1].threshold == 0.5568317224842397
    @test init[1].vaccine == false
    @test init[2].id == 2
    @test init[2].type == 1
    @test init[2].dose == [0.0]
    @test init[2].threshold == 0.8499880427536775
    @test init[2].vaccine == false

    Random.seed!(1234)
    universal = plot_model_universal(10^3,10^5,0,10^5,0,0.8,1,0.2,1.0)
    @test universal[1][1] ≈ 33935
    @test universal[1][2] ≈ 66065
    @test universal[1][3] ≈ 0
    universal = plot_model_universal(10^3,10^5,0,10^5,0,0.0,1,0.5,1.0)
    @test universal[1][1] ≈ 10^5
    @test universal[1][2] ≈ 0
    @test universal[1][3] ≈ 0
end