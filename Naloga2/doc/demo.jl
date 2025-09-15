# Vključi modul
include("../src/Naloga2.jl")
using .Naloga2
using Printf
using Plots

#f sin(x)/x
f(x) = abs(x) < 1e-8 ? 1.0 : sin(x)/x

#vrednost integrala ∫₀⁵ sin(x)/x dx
točna_vrednost = 1.549931244944

#Preizkusimo različne n
ns = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512]
aprokses = Float64[]
napake = Float64[]

println(rpad("n", 8), rpad("Aproksimacija", 20), "Rel. napaka")

for n in ns
    aproks, _ = sestavljena_gauss_legendre(f, 0.0, 5.0, n)
    push!(aprokses, aproks)
    rel_napaka = abs(aproks - točna_vrednost) / abs(točna_vrednost)
    push!(napake, rel_napaka)

    @printf("%-8d %-20.12f %.3e\n", n, aproks, rel_napaka)
end

#najmanjši n, ki doseže 10 decimalk?
for (i, n) in enumerate(ns)
    if napake[i] < 1e-10
        println("Za 10 decimalk potrebujemo n = $n, kar pomeni $(2n) klicev funkcije f.")
        break
    end
end

# graf konvergence
plt = plot(ns, napake,
           xscale=:log10, yscale=:log10,
           marker=:o, lw=2,
           xlabel="Število podintervalov n",
           ylabel="Relativna napaka",
           title="Konvergenca za ∫₀⁵ sin(x)/x dx")  

#savefig(plt, "gauss_legendre_konvergenca.png")
display(plt)
