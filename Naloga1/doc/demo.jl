include("../src/Naloga1.jl")
import .Naloga1  
using Plots

#def interpolacijske točke (x) in njihove vrednosti (y)
x = [0.0, 1.0, 2.0, 3.0, 4.0]
y = [0.0, 1.0, 0.0, 1.0, 0.0]

#izračun kubičnega zlepka
Z = Naloga1.interpoliraj(x, y)

#točka kjer želimo oceniti vrednost zlepka
x0 = 2.5
y0 = Naloga1.vrednost(Z, x0)  #vrednost zlepka v točki x0
println("Vrednost zlepka v x = ", x0, " je ", y0)

# Narišemo zlepek 
plt = Naloga1.plot(Z)

#dodamo izbrano točko (x0, y0) kot zeleno zvezdico
scatter!(plt, [x0], [y0], color=:green, marker=:star5, label="Točka x = $x0")

display(plt)
#savefig(plt, "zlepek_demo.png")
#println("Graf shranjen!")
