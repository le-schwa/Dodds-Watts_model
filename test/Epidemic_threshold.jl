@testset "Epidemic_threshold.jl" begin
    init = initialize_etm(2,1)
    @test init[1].id == 1
    @test init[1].type == 2
    @test init[1].dose == [1.0]
    @test init[1].threshold == 1.0
    @test init[1].vaccine == false
    @test init[2].id == 2
    @test init[2].type == 1
    @test init[2].dose == [0.0]
    @test init[2].threshold == 1.0
    @test init[2].vaccine == false

    Random.seed!(1234)
    etm = plot_model_etm(10^3,10^5,0,10^5,0,0.6,1,0.5,1.0)
    @test etm[1][1] ≈ 66825
    @test etm[1][2] ≈ 33175
    @test etm[1][3] ≈ 0
    @test etm[3] ≈ 0.33333333333333304
    etm = plot_model_etm(10^3,10^5,0,10^5,0,0.0,1,0.5,1.0)
    @test etm[1][1] ≈ 10^5
    @test etm[1][2] ≈ 0
    @test etm[1][3] ≈ 0
    @test etm[3] ≈ 0
    etm = plot_model_etm(10^3,10^5,0,10^5,0,1.0,1,0.5,1.0)
    @test etm[1][1] ≈ 0
    @test etm[1][2] ≈ 10^5
    @test etm[1][3] ≈ 0
    @test etm[3] ≈ 1

    fixed_point = fixed_point_curve_etm(1,0.5)
    @test fixed_point[1] ≈ [0.5, 4.014300722355872e-8]
end