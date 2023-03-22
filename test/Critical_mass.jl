@testset "Critical_mass.jl" begin
    init = initialize_cmm(2,1,3)
    @test init[1].id == 1
    @test init[1].type == 2
    @test init[1].dose == [3.0]
    @test init[1].threshold == 3.0
    @test init[1].vaccine == false
    @test init[2].id == 2
    @test init[2].type == 1
    @test init[2].dose == [0.0]
    @test init[2].threshold == 3.0
    @test init[2].vaccine == false

    Random.seed!(1234)
    cmm = plot_model_cmm(10^3,10^5,0,10^5,0,0.45,12,1.0,1.0,3)
    @test cmm[1][1] ≈ 6381
    @test cmm[1][2] ≈ 93619
    @test cmm[1][3] ≈ 0
    @test cmm[3] ≈ 0.9373491585381798
    cmm = plot_model_cmm(10^3,10^5,0,10^5,0,0.0,12,1.0,1.0,3)
    @test cmm[1][1] ≈ 10^5
    @test cmm[1][2] ≈ 0
    @test cmm[1][3] ≈ 0
    @test cmm[3] ≈ 0
    cmm = plot_model_cmm(10^3,10^5,0,10^5,0,1.0,12,1.0,1.0,3)
    @test cmm[1][1] ≈ 0
    @test cmm[1][2] ≈ 10^5
    @test cmm[1][3] ≈ 0
    @test cmm[3] ≈ 1

    fixed_point = fixed_point_curve_cmm(12,5)
    @test fixed_point[1] ≈ [0.6170221769734058, 0.8537221723887451]
end