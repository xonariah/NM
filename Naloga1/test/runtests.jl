using Test

include("../src/Naloga1.jl")
import .Naloga1

# Test 1: vrednosti v vozliščih morajo biti točno enake
@testset "Zlepek: vrednosti v vozliščih" begin
    x = Float64.(0:0.5:3)
    y = sin.(x)
    Z = Naloga1.interpoliraj(x, y)

    for i in eachindex(x)
        @test Naloga1.vrednost(Z, x[i]) ≈ y[i] atol=1e-10
    end
end

# Test 2: preverimo napako med vozlišči
@testset "Zlepek: napaka med točkami" begin
    x = Float64.(0:0.5:3)
    y = sin.(x)
    Z = Naloga1.interpoliraj(x, y)

    xfine = Float64.(0:0.1:3)
    y_true = sin.(xfine)
    y_interp = Naloga1.vrednost(Z, xfine)

    napake = abs.(y_true .- y_interp)
    max_napaka = maximum(napake)

    @test max_napaka < 0.05
end

# Test 3: zveznost prvega odvoda (S' mora biti enak levo in desno)
@testset "Zlepek: zveznost prvega odvoda" begin
    x = Float64.(0:0.5:3)
    y = sin.(x)
    Z = Naloga1.interpoliraj(x, y)

    for i in 2:length(x)-1
        h = x[i+1] - x[i]
        # odvod iz levega odseka
        bL = Z.b[i-1]
        cL = Z.c[i-1]
        dL = Z.d[i-1]
        dfL = bL + 2*cL*h + 3*dL*h^2

        # odvod iz desnega odseka
        bR = Z.b[i]
        dfR = bR

        @test dfL ≈ dfR atol=1e-8
    end
end

# Test 4: zveznost drugega odvoda (S'' mora biti enak na stikih)
@testset "Zlepek: zveznost drugega odvoda" begin
    x = Float64.(0:0.5:3)
    y = sin.(x)
    Z = Naloga1.interpoliraj(x, y)

    for i in 2:length(x)-1
        h = x[i+1] - x[i]
        cL = Z.c[i-1]
        dL = Z.d[i-1]
        d2fL = 2*cL + 6*dL*h

        cR = Z.c[i]
        d2fR = 2*cR

        @test d2fL ≈ d2fR atol=1e-8
    end
end

# Test 5: če je funkcija linearna, mora biti zlepek popolnoma enak
@testset "Zlepek: točnost za linearno funkcijo" begin
    x = Float64.(0:1:4)
    y = 3 .+ 2 .* x  #f(x) = 3 + 2x
    Z = Naloga1.interpoliraj(x, y)

    for xx in Float64.(0:0.25:4)
        @test Naloga1.vrednost(Z, xx) ≈ (3 + 2*xx) atol=1e-10
    end
end
