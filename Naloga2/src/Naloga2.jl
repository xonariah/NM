module Naloga2

export gauss_legendre_2pt, sestavljena_gauss_legendre, integriraj_do_tocnosti, test_integral


"""
    gauss_legendre_2pt(f, a, b)

Dvotočkovno Gauss-Legendrovo integracijsko pravilo:

    ∫ₐᵇ f(x) dx ≈ (b-a)/2 * [ f((a+b)/2 - (b-a)/(2√3)) + f((a+b)/2 + (b-a)/(2√3)) ].

To pravilo je natančno za vse polinome do stopnje 3.

Za dovolj gladke f velja napaka

    R_f = -((b-a)^5 / 2880) * f⁽⁴⁾(ξ),   ξ ∈ (a,b).

"""
function gauss_legendre_2pt(f, a, b)
    # Gaussove točke in uteži na [-1,1]
    G1 = -1 / sqrt(3)
    G2 =  1 / sqrt(3)
    w1 = 1.0
    w2 = 1.0

    # Afina preslikava iz [-1,1] na [a,b]
    x1 = ((b - a) / 2) * G1 + (a + b) / 2
    x2 = ((b - a) / 2) * G2 + (a + b) / 2

    # Izračun integrala
    integral = (b - a) / 2 * (w1 * f(x1) + w2 * f(x2))
    return integral
end


"""
    sestavljena_gauss_legendre(f, a, b, n)

Razdeli interval [a, b] na n enakih podintervalov in uporabi dvotočkovno Gauss-Legendrovo pravilo
na vsakem podintervalu.

Vrne `(aproks, klici)`, kjer je:
- `aproks`: približek integrala,
- `klici`: število klicev funkcije f (2 * n).
"""
function sestavljena_gauss_legendre(f, a, b, n)
    vsota = 0.0
    h = (b - a) / n  # dolžina podintervala

    for i in 0:(n-1)
        a_i = a + i * h
        b_i = a_i + h
        vsota += gauss_legendre_2pt(f, a_i, b_i)
    end

    stevilo_klicev = 2 * n
    return vsota, stevilo_klicev
end

"""
    integriraj_do_tocnosti(f, a, b; tol=1e-10)

Uporabi sestavljeno Gauss-Legendrovo kvadraturo z zaporednim podvajanjem intervalov,
dokler se približka ne razlikujeta za manj kot `tol`.

Vrne `(aproks, n, klici)`:
- `aproks`: približek integrala,
- `n`: število podintervalov,
- `klici`: skupno število klicev funkcije f.
"""
function integriraj_do_tocnosti(f, a, b; tol=1e-10)
    n = 1
    I_prev, klici_prev = sestavljena_gauss_legendre(f, a, b, n)
    skupno_klicev = klici_prev

    while true
        n *= 2
        I_curr, klici_curr = sestavljena_gauss_legendre(f, a, b, n)
        skupno_klicev += klici_curr

        if abs(I_curr - I_prev) < tol * abs(I_curr)
            return I_curr, n, skupno_klicev
        end

        I_prev = I_curr
    end
end

"""
    test_integral()

Izračuna integral ∫₀⁵ sin(x)/x dx z Gauss-Legendrovim pravilom
in vrne rezultat skupaj s številom klicev funkcije.

Zahtevana natančnost 1e-10.
"""
function test_integral()
    f(x) = x == 0 ? 1.0 : sin(x)/x   #definicija sin(x)/x, urejena pri 0
    I, n, klici = integriraj_do_tocnosti(f, 0, 5; tol=1e-10)
    return I, n, klici
end

end 
