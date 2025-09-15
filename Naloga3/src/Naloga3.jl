module Naloga3

using LinearAlgebra
using Plots


"""
    f(t, y, g, l)

Desna stran diferencialnega sistema za matematicno nihalo.
Pretvorimo drugo enacbo v sistem dveh enacb prvega reda:

    y[1] = theta (odmik),
    y[2] = omega = dtheta/dt (kotna hitrost)

Sistem:
    dy1/dt = y2
    dy2/dt = -(g / l) * sin(y1)
"""
function f(t, y, g, l)
    return [y[2], -(g / l) * sin(y[1])]
end


"""
    DOPRI(f, y0, tspan, h, g, l)

Resi sistem y' = f(t,y) z metodo Dormand–Prince 5. reda (DOPRI5).
Implementacija uporablja Butcherjevo tabelo in genericno zanko.

Vhodni podatki:
- `f`: funkcija desne strani (mora biti f(t, y, g, l))
- `y0`: zacetni pogoj (vektor dolzine 2)
- `tspan`: casovni interval kot par (t0, t1)
- `h`: dolzina koraka (npr. 0.01)
- `g`, `l`: parametra modela

Vrne:
- seznam casov `ts`
- seznam resitev `ys` (vsaka je vektor dolzine 2)
"""
function DOPRI(f, y0, tspan, h, g, l)
    # koeficienti DormandPrinc, Butcherjeva tabela
    c = [0,
         1//5,
         3//10,
         4//5,
         8//9,
         1]

    a = [
        [],                                         
        [1//5],                                     
        [3//40,         9//40],                     
        [44//45,      -56//15,       32//9],        
        [19372//6561, -25360//2187, 64448//6561, -212//729],   
        [9017//3168,  -355//33,     46732//5247,   49//176, -5103//18656]  
    ]

    b = [35//384, 0, 500//1113, 125//192, -2187//6784, 11//84]  # uteži za 5. red

    # inicializacija trenutni čas in začetno stanje
    t0, t1 = tspan
    t = t0
    y = y0

    ts = [t]
    ys = [y0]

    while t < t1
        #če presegamo konec intervala, prilagodimo korak
        if t + h > t1
            h = t1 - t
        end

        # shrani vektorje k
        ks = Vector{Vector{Float64}}(undef, 6)

        #vmesna stanja izračun
        for i in 1:6
            # sestej prispevke prejsnjih k
            yi = y #zacetna vrednost
            if !isempty(a[i]) #ni prvi korak
                s = zero(y)
                for j in 1:length(a[i])
                    s += a[i][j] * ks[j]
                end
                yi = y + h * s
            end
            ti = t + c[i]*h
            ks[i] = f(ti, yi, g, l)
        end

        # posodobitev rešitve z uteženim povprečjem vmesnih korakov
        s = zero(y)
        for i in 1:6
            s += b[i] * ks[i]
        end
        y = y + h * s
        t += h

        push!(ts, t)
        push!(ys, y)
    end

    return ts, ys
end


"""
    poisci_periodo(ts, ys)

Preprosto oceni periodni cas nihala iz rešitve.
Najde dva zaporedna lokalna maksimuma (vrhova theta) in izracuna razliko casov.

Vrne ocenjen periodni cas (ali NaN, ce ne najde).
"""
function poisci_periodo(ts, ys)
    thetas = [y[1] for y in ys] #koti
    max_indeksi = []

    for i in 2:length(thetas)-1
        if thetas[i-1] < thetas[i] && thetas[i+1] < thetas[i]
            push!(max_indeksi, i)
        end
    end

    if length(max_indeksi) >= 2
        i1, i2 = max_indeksi[1], max_indeksi[2]
        return ts[i2] - ts[i1]  # celotna perioda
    else
        return NaN
    end
end


"""
    energija(theta0, omega0, g, l)

Vrne mehansko energijo nihala (potencialna + kinetična).

    E = m*g*l*(1 - cos(theta)) + 0.5 * m * l^2 * omega^2

Privzamemo m = 1 (saj se skrajsa pri primerjavah).
"""
function energija(theta0, omega0, g, l)
    return g * l * (1 - cos(theta0)) + 0.5 * l^2 * omega0^2
end

"""
    narisi_graf_nihajnega_casa()

Za razlicne zacetne odmike (theta0), pri omega0 = 0, izracuna energijo in nihajni cas.
Nato narise graf odvisnosti nihajnega casa od energije.
"""
function narisi_graf_nihajnega_casa()
    g = 9.81
    l = 1.0
    h = 0.01
    tmax = 20.0

    theta0s = range(0.01, pi - 0.01, length=100)
    energies = Float64[]
    periods = Float64[]

    #za vsak zacetni kot računcamo energijo in obdobje
    for theta0 in theta0s
        y0 = [theta0, 0.0]
        ts, ys = DOPRI(f, y0, (0.0, tmax), h, g, l)
        T = poisci_periodo(ts, ys)
        E = energija(theta0, 0.0, g, l)

        push!(energies, E)
        push!(periods, T)
    end

    plot(energies, periods,
         xlabel="Energija",
         ylabel="Nihajni cas",
         title="Odvisnost nihajnega casa od energije",
         legend=false)
end

"""
    narisi_T_E()

Za razlicne zacetne odmike theta0 (od 0.01 do pi-0.01), pri omega0 = 0,
izracuna energijo in nihajni cas. Nato narise graf T(E).
"""
function narisi_T_E()
    g = 9.81
    l = 1.0
    h = 0.01
    tmax = 20.0

    theta0s = range(0.01, pi - 0.01, length=50)   # 50 tock med 0 in pi
    energies = Float64[]
    periods = Float64[]

    for theta0 in theta0s
        y0 = [theta0, 0.0]
        ts, ys = DOPRI(f, y0, (0.0, tmax), h, g, l)
        T = poisci_periodo(ts, ys)
        E = energija(theta0, 0.0, g, l)

        if !isnan(T) #dodamo samo, če našli periodo
            push!(energies, E)
            push!(periods, T)
        end
    end

    plot(energies, periods,
         xlabel="Energija",
         ylabel="Nihajni cas",
         title="Odvisnost nihajnega casa od energije",
         legend=false)
end

"""
    harmonicno_resitev(theta0, omega0, g, l, ts)

Vrne analitično rešitev harmoničnega nihala za čase `ts`.

Enačba:
    theta(t) = theta0 * cos(sqrt(g/l)*t) + (omega0/sqrt(g/l)) * sin(sqrt(g/l)*t)
"""
function harmonicno_resitev(theta0, omega0, g, l, ts)
    ω = sqrt(g / l)
    return [theta0 * cos(ω * t) + (omega0 / ω) * sin(ω * t) for t in ts]
end


end 
