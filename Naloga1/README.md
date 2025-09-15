# Naravni interpolacijski kubični zlepek

Avtor: Ariana Kržan <ak1193@student.uni-lj.si>

Naloga definira podatkovni tip `Zlepek` za naravni interpolacijski kubični zlepek.  
Zlepek je sestavljen iz kosovnih polinomov tretje stopnje, ki interpolirajo podane točke \((x_i, f_i)\) tako, da so funkcija in njeni prvi ter drugi odvodi zvezni po celotnem intervalu. Na robovih velja naravni pogoj \(S''(x_1) = S''(x_n) = 0\).  

Glavna funkcija `interpoliraj(x, y)` vrne objekt tipa `Zlepek`, ki ga nato lahko uporabimo za izračun vrednosti zlepka ali za vizualizacijo.

## Delovanje paketa
Pred pričetkom izvajanja naslednjih odsekov kod se je najprej potrebno premakniti v mapo Naloga1 in nato pognati naslednje ukaze:
```julia
import Pkg
Pkg.activate(".")
```

## Primer uporabe

Primer uporabe je prikazan v datoteki 'doc/demo.jl'. Poženemo ga z naslednjim ukazom:

```julia
include("./doc/demo.jl")
```

Uporabimo pa lahko paket tudi na naslednji način:
```julia
include("./src/Naloga1.jl")
using .Naloga1
x = [0.0, 1.0, 2.0, 3.0, 4.0]
y = [0.0, 1.0, 0.0, 1.0, 0.0]
Z = interpoliraj(x, y)
plot_zlepek(Z)
```

## Testi

Teste poženemo z naslednjim ukazom:

```julia
include("./test/runtests.jl")
```

## Poročilo

Zgenerirano poročilo v obliki PDF se že nahaja na lokaciji 'pdf/porocilo.pdf'. Zgenerirati ga je možno z naslednjim ukazom:
```julia
include("./doc/makedocs.jl")
```
