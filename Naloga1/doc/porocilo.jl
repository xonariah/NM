#' # Naravni interpolacijski kubični zlepek
#' Ariana Kržan <ak1193@student.uni-lj.si>
#'
#' ## Opis naloge
#'
#' V nalogi obravnavamo **naravni interpolacijski kubični zlepek**, ki je posebna oblika
#' interpolacijske funkcije. Cilj je za dane interpolacijske točke $(x_i, f_i)$, kjer
#' $i = 1, 2, \ldots, n$, določiti funkcijo $S$, ki izpolnjuje naslednje pogoje:
#'
#' 1. $S(x_i) = f_i$ za vse točke $i = 1, \ldots, n$.
#' 2. Na vsakem podintervalu $[x_i, x_{i+1}]$ je $S$ polinom tretje stopnje ali manj.
#' 3. Funkcija $S$ je dvakrat zvezno odvedljiva na celotnem intervalu $[x_1, x_n]$.
#' 4. Na robovih velja naravni pogoj: $S''(x_1) = S''(x_n) = 0$.
#'
#' Zlepek določimo tako, da na vsakem intervalu uporabimo polinom oblike
#' $$
#' S_i(x) = a_i + b_i(x - x_i) + c_i(x - x_i)^2 + d_i(x - x_i)^3,
#' $$
#' kjer koeficiente $a_i, b_i, c_i, d_i$ določimo iz zgornjih pogojev. S tem problem
#' prevedemo na reševanje sistema linearnih enačb, ki določa vrednosti drugega odvoda
#' v vozliščih. Koeficiente nato uporabimo za izračun posameznih polinomov in sestavimo
#' celoten zlepek.
#'
#'
#' ## Opis rešitve
#'
#' Reševanje problema razdelimo v več korakov:
#'
#' 1. **Priprava podatkov**  
#'    Najprej pogledamo, kako daleč narazen so interpolacijske točke. Za vsak par
#'    sosednjih točk izračunamo dolžino intervala (razdaljo po osi x). Te dolžine
#'    povemo, kako ``širok'' bo vsak kos polinoma, in jih uporabimo v vseh nadaljnjih
#'    korakih.

#' 2. **Sestava sistema enačb**  
#'    Nato pripravimo enačbe, ki zagotavljajo, da se bodo polinomi lepo stikovali.
#'    Pogoji so naslednji: vrednosti v vozliščih se morajo ujemati, prvi in drugi odvod
#'    pa morata biti zvezna. Poleg tega na robovih določimo naravne pogoje (drugi odvod
#'    na začetku in koncu je enak nič). Iz vseh teh pogojev dobimo tridiagonalni sistem
#'    enačb, ki ga moramo rešiti.

#' 3. **Reševanje sistema**  
#'    Tridiagonalni sistem rešimo s postopkom, ki najprej prehodi enačbe v smeri
#'    naprej in izračuna pomožne vrednosti, nato pa v povratnem koraku izračuna
#'    končne rešitve. Na ta način učinkovito dobimo vrednosti drugega odvoda
#'    v vseh vozliščih.

#' 4. **Izračun koeficientov**  
#'    Ko poznamo vrednosti drugega odvoda, lahko za vsak interval sestavimo celoten
#'    kubični polinom. Izračunamo linearni, kvadratni in kubični člen, tako da polinom
#'    pravilno opisuje obnašanje funkcije med dvema točkama. S tem dobimo natančen opis
#'    zlepka na vseh delih intervala.

#' 5. **Uporaba zlepka**  
#'    Ko imamo vse koeficiente, lahko zlepek uporabimo. Če želimo vrednost v neki točki,
#'    jo enostavno vstavimo v ustrezen polinom. Prav tako lahko narišemo celoten graf
#'    zlepka, ki bo gladko povezoval vse podane točke brez ostrih prelomov.

#'
#' Takšen pristop omogoča stabilno in gladko interpolacijo, ki je uporabna pri numeričnih
#' izračunih in vizualizaciji podatkov.
#'
#'
#' ## Rezultati
#'
#' V spodnjem primeru konstruiramo zlepek za funkcijo $\sin(x)$ na intervalu $[0, 3]$
#' z razmikom $0.5$ med točkami. Rezultat pokaže, da se zlepek lepo prilega podatkom
#' in da interpolacija poteka gladko brez prelomov.
#'

include("demo.jl")