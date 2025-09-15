# Gauss-Legendrova kvadratura (2-točkovna)

Avtor: Ariana Kržan <ak1193@student.uni-lj.si>

Program približno izračuna določene integrale z uporabo dvotočkovne Gauss-Legendrove kvadrature.  
Najprej se pravilo izpelje na intervalu \([-1, 1]\) in nato preslika na poljuben interval \([a, b]\).  
Za izračun integralov na daljšem intervalu se uporablja sestavljeno pravilo, kjer se osnovno pravilo uporabi na več podintervalih.  
Za oceno napake se rezultat primerja z rezultatom pri dvakrat več podintervalih.  

Program omogoča tudi samodejno izbiro števila podintervalov za dosego želene natančnosti.

## Delovanje paketa
Pred pričetkom izvajanja naslednjih odsekov kod se je najprej potrebno premakniti v mapo Naloga2 in nato pognati naslednje ukaze:
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
include("./src/Naloga2.jl")
using .Naloga2
f(x) = x == 0 ? 1.0 : sin(x) / x
rezultat, n, klici = integriraj_do_tocnosti(f, 0, 5; tol=1e-10)
```


## Testi

Teste poženemo z naslednjim ukazom:

```julia
Pkg.test()
```

## Poročilo

Zgenerirano poročilo v obliki PDF se že nahaja na lokaciji 'pdf/porocilo.pdf'. Zgenerirati ga je možno z naslednjim ukazom:
```julia
include("./doc/makedocs.jl")
```
