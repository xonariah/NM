# Matematično nihalo

Avtor: Ariana Kržan <ak1193@student.uni-lj.si>

Ta naloga numerično rešuje gibanje matematičnega nihala, ki ga opisuje nelinearna diferencialna enačba drugega reda. Enačbo pretvorimo v sistem dveh enačb prvega reda in jo rešujemo z metodo Dormand–Prince 5. reda (DOPRI5).  

Program omogoča tudi primerjavo gibanja matematičnega nihala s harmoničnim (linearnim) približkom ter vizualizacijo vpliva začetne energije na nihajni čas.

## Delovanje paketa
Pred pričetkom izvajanja naslednjih odsekov kod se je najprej potrebno premakniti v mapo Naloga3 in nato pognati naslednje ukaze:
```julia
import Pkg
Pkg.activate(".")
```

## Primer uporabe

Primer uporabe je prikazan v datoteki 'doc/demo.jl'. Poženemo ga z naslednjim ukazom:

```julia
include("./doc/demo.jl")
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
