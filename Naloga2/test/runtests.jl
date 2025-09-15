using Test
using Naloga2

# ------------------------------------------------
@testset "Gauss-Legendre 2-točkovno pravilo" begin
    # Integral polinoma 3. stopnje je točen
    f(x) = x^3 + 2x^2 + 3x + 4
    I_exact = (5^4/4 + 2*5^3/3 + 3*5^2/2 + 4*5) - 0  # ∫₀⁵ f(x) dx
    I_num = gauss_legendre_2pt(f, 0.0, 5.0)
    @test I_num ≈ I_exact
end

# ------------------------------------------------
@testset "Sestavljena Gauss-Legendre kvadratura" begin
    # ∫₀¹ x^2 dx = 1/3, točno integrabilno
    f(x) = x^2
    for n in (1, 2, 4, 8)
        I_num, _ = sestavljena_gauss_legendre(f, 0.0, 1.0, n)
        @test I_num ≈ 1/3
    end
end

@testset "Adaptivna integracija" begin
    f(x) = sin(x)/x
    I, n, klici = test_integral()
    @test isapprox(I, 1.549931244944, atol=1e-10)
end

@testset "Testni primer iz naloge" begin
    f(x) = sin(x)/x
    I, n, klici = integriraj_do_tocnosti(f, 0, 5; tol=1e-10)
    # znana referenčna vrednost
    I_ref = 1.549931244944
    @test isapprox(I, I_ref, atol=1e-10)
end



