module Naloga1
using Plots

"""
    struct Zlepek

Struktura, ki predstavlja naravni kubični interpolacijski zlepek.

Polja:
- `x::Vector{Float64}`: interpolacijske točke (mora biti naraščajoče).
- `a::Vector{Float64}`: koeficienti aᵢ (funkcijske vrednosti).
- `b::Vector{Float64}`: koeficienti bᵢ (linearni člen).
- `c::Vector{Float64}`: koeficienti cᵢ (kvadratni člen).
- `d::Vector{Float64}`: koeficienti dᵢ (kubični člen).
"""
struct Zlepek
    x::Vector{Float64}
    a::Vector{Float64}
    b::Vector{Float64}
    c::Vector{Float64}
    d::Vector{Float64}
end

export Zlepek, interpoliraj, vrednost, plot

"""
    interpoliraj(x::Vector, y::Vector) -> Zlepek

Izračuna koeficiente naravnega kubičnega zlepka za podane interpolacijske točke `(x, y)`.

Vrne strukturo `Zlepek`, ki vsebuje vse potrebne koeficiente za vrednotenje in risanje zlepka.
"""
function interpoliraj(x::Vector{Float64}, y::Vector{Float64})::Zlepek
    n = length(x)

    #Preverimo, da imamo dovolj točk
    @assert n >= 2 "Potrebni sta vsaj dve točki za interpolacijo."

    #Koraki med točkami
    h = [x[i+1] - x[i] for i in 1:n-1]

    #Pripravimo desno stran sistema za c-koeficiente
    α = zeros(n)
    for i in 2:n-1
        α[i] = 3 * ((y[i+1] - y[i]) / h[i] - (y[i] - y[i-1]) / h[i-1])
    end

    #Tridiagonalni sistem za c-koeficiente (naravni robni pogoji: c[1] = c[n] = 0)
    l = ones(n)
    μ = zeros(n)
    z = zeros(n)
    c = zeros(n)

    #Decompozicija tridiagonalne matrike (LU)
    for i in 2:n-1
        l[i] = 2 * (x[i+1] - x[i-1]) - h[i-1] * μ[i-1]
        μ[i] = h[i] / l[i]
        z[i] = (α[i] - h[i-1] * z[i-1]) / l[i]
    end

    #Povratni korak za reševanje sistema
    b = zeros(n-1)
    d = zeros(n-1)
    a = copy(y)

    #Pogoj naravnosti: c[n] = 0 že nastavljen
    for j in n-1:-1:1
        c[j] = z[j] - μ[j] * c[j+1]
        b[j] = (a[j+1] - a[j]) / h[j] - h[j] * (2*c[j] + c[j+1]) / 3
        d[j] = (c[j+1] - c[j]) / (3 * h[j])
    end

    return Zlepek(x, a[1:end-1], b, c, d)
end

"""
    vrednost(Z::Zlepek, x0::Float64) -> Float64

Vrne vrednost zlepka `Z` v točki `x0`.

Poišče pravi interval in uporabi ustrezni polinom za izračun vrednosti.
"""
function vrednost(Z::Zlepek, x0::Float64)::Float64
    #Poiščemo, v kateri interval spada x0
    i = searchsortedlast(Z.x, x0)
    i = clamp(i, 1, length(Z.x) - 1)  # Pazimo na robove

    dx = x0 - Z.x[i]
    return Z.a[i] + Z.b[i]*dx + Z.c[i]*dx^2 + Z.d[i]*dx^3
end
"""
    vrednost(Z::Zlepek, xs::AbstractVector) -> ys::Vector

Vrne vrednosti zlepka `Z` v vseh točkah `xs`.
"""
function vrednost(Z::Zlepek, xs::AbstractVector)
    return [vrednost(Z, x) for x in xs]
end


"""
    plot(Z::Zlepek) -> Plot

Nariše graf interpolacijskega zlepka `Z`.

Različne odseke nariše izmenično v rdeči in modri barvi. Uporablja knjižnico `Plots`.
"""
function plot(Z::Zlepek)
    @eval using Plots

    plt = Plots.plot(
        title = "Naravni kubični zlepek",
        xlabel = "x",
        ylabel = "f(x)",
        legend = false
    )

    n = length(Z.x)
    colors = [:red, :blue]

    for i in 1:n-1
        xx = range(Z.x[i], Z.x[i+1], length=100)
        dx = xx .- Z.x[i]
        yy = Z.a[i] .+ Z.b[i]*dx .+ Z.c[i]*dx.^2 .+ Z.d[i]*dx.^3

        Plots.plot!(plt, xx, yy, color=colors[mod1(i, 2)], linewidth=2)
    end

    #interpolacijske točke kot pike
    Plots.scatter!(plt, Z.x, vrednost(Z, Z.x), color=:black, marker=:circle)


    return plt
end

end 
