using Test

include("../src/Naloga3.jl")
import .Naloga3

@testset "Matematicno nihalo: desna stran sistema" begin
    g, l = 9.81, 1.0
    theta, omega = pi/6, 0.5
    y = [theta, omega]
    dy = Naloga3.f(0.0, y, g, l)

    @test length(dy) == 2               
    @test dy[1] ≈ omega atol=1e-12      # dy1/dt = omega
    @test dy[2] ≈ -(g/l) * sin(theta) atol=1e-12   # dy2/dt = -(g/l)sin(theta)
end

@testset "Matematicno nihalo: solver DOPRI" begin
    g, l = 9.81, 1.0
    theta0, omega0 = 0.1, 0.0   # majhen odmik
    tmax, h = 10.0, 0.01

    ts, ys = Naloga3.DOPRI(Naloga3.f, [theta0, omega0], (0.0, tmax), h, g, l)

    @test length(ts) == length(ys)      
    @test ys[1][1] ≈ theta0 atol=1e-12  
    @test ys[1][2] ≈ omega0 atol=1e-12  

    thetas = [y[1] for y in ys]
    @test maximum(abs.(thetas)) < 1.0   
end

@testset "Matematicno nihalo: energija" begin
    g, l = 9.81, 1.0

    @test Naloga3.energija(0.0, 0.0, g, l) ≈ 0.0 atol=1e-12   # ravnovesje

    E = Naloga3.energija(pi/4, 0.0, g, l)
    @test E > 0
    @test E ≈ g*l*(1 - cos(pi/4)) atol=1e-12
end

@testset "Matematicno nihalo: ocena periode" begin
    g, l = 9.81, 1.0
    theta0, omega0 = 0.1, 0.0
    tmax, h = 10.0, 0.01

    ts, ys = Naloga3.DOPRI(Naloga3.f, [theta0, omega0], (0.0, tmax), h, g, l)
    T_est = Naloga3.poisci_periodo(ts, ys)

    T_exact = 2pi*sqrt(l/g)
    @test isapprox(T_est, T_exact; atol=0.05)
end


@testset "DOPRI: enostavna ODE z znano resitvijo" begin
    # y' = -2y, y(0)=1 => y(t)=exp(-2t)
    f(t, y, g, l) = [-2*y[1]]
    tspan = (0.0, 1.0)
    y0 = [1.0]
    ts, ys = Naloga3.DOPRI(f, y0, tspan, 0.01, 0.0, 0.0)
    for (ti, yi) in zip(ts, ys)
        @test yi[1] ≈ exp(-2*ti) atol=1e-3
    end
end

@testset "Nihalo: ohranjanje energije" begin
    g, l = 9.81, 1.0
    theta0, omega0 = 0.5, 0.0
    ts, ys = Naloga3.DOPRI(Naloga3.f, [theta0, omega0], (0.0, 10.0), 0.01, g, l)

    E0 = Naloga3.energija(ys[1][1], ys[1][2], g, l)
    for y in ys
        E = Naloga3.energija(y[1], y[2], g, l)
        @test isapprox(E, E0; rtol=1e-2)   # energija naj ostane skoraj enaka
    end
end
