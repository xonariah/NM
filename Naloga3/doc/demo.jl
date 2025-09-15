include("../src/Naloga3.jl")
import .Naloga3

using Plots

g = 9.81
l = 1.0
h = 0.01
tmax = 10.0

# Začetni pogoji
theta0 = 0.8   # večji odmik -> manjše ujemanje
omega0 = 0.0
y0 = [theta0, omega0]

# matematično nihalo)
ts, ys = Naloga3.DOPRI(Naloga3.f, y0, (0.0, tmax), h, g, l)
thetas_num = [y[1] for y in ys]

# harmonično nihalo
thetas_harm = Naloga3.harmonicno_resitev(theta0, omega0, g, l, ts)

# narisana primerjava
plt1 = plot(ts, thetas_num, label="Matematično nihalo (DOPRI5)", lw=2)
plot!(plt1, ts, thetas_harm, label="Harmonično nihalo (analitično)", lw=2, ls=:dot)
xlabel!("Čas [s]")
ylabel!("Kot [rad]")
title!("Primerjava matematičnega in harmoničnega nihala")
display(plt1)
#savefig(plt1, "primerjava_nihal.png")


# 2. Graf kota skozi čas
#plt2 = plot(ts, thetas_num, label="θ(t)", color=:blue)
#xlabel!("Čas [s]")
#ylabel!("Kot [rad]")
#title!("Odmik nihala skozi čas (matematično nihalo)")
#display(plt2)
#savefig(plt2, "odmik_vs_cas.png")

# 3. Graf T(E) 
plt3 = Naloga3.narisi_T_E()
display(plt3)
#savefig(plt3, "nihajni_cas_vs_energija.png")
