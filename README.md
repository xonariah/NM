# Naravni interpolacijski kubični zlepek

Avtor: Ariana Kržan <ak1193@student.uni-lj.si>

Naloga definira podatkovni tip `Zlepek` za naravni interpolacijski kubični zlepek.  
Zlepek je sestavljen iz kosovnih polinomov tretje stopnje, ki interpolirajo podane točke \((x_i, f_i)\) tako, da so funkcija in njeni prvi ter drugi odvodi zvezni po celotnem intervalu. Na robovih velja naravni pogoj \(S''(x_1) = S''(x_n) = 0\).  

Glavna funkcija `interpoliraj(x, y)` vrne objekt tipa `Zlepek`, ki ga nato lahko uporabimo za izračun vrednosti zlepka ali za vizualizacijo.

## Primer uporabe

Primer uporabe je prikazan v programu, ki se nahaja v `doc/demo.jl`.  
Poženemo ga v interaktivni zanki Julie z ukazi:

```julia
include("Naloga1/doc/demo.jl")
```

## Testi

Teste poženemo z ukazom:

```julia
include("Naloga1/test/runtests.jl")
```
