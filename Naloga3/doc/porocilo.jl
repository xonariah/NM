#' # Matematično nihalo
#' Ariana Kržan <ak1193@student.uni-lj.si>
#'
#' ## Opis naloge
#'
#' Obravnavamo matematično nihalo, to je masa na idealni vrvici dolžine \( l \),
#' ki se giblje pod vplivom gravitacije. Odmik nihala od navpičnice označimo s kotom \( \theta(t) \).
#'
#' Njegovo gibanje opisuje nelinearna diferencialna enačba
#'
#' ```math
#' \ddot{\theta}(t) + \frac{g}{l} \sin(\theta(t)) = 0
#' ```
#'
#' z začetnima pogojema
#'
#' ```math
#' \theta(0) = \theta_0, \quad \dot{\theta}(0) = \omega_0
#' ```
#'
#' Enačbo prevedemo v sistem prvega reda in rešujemo z metodo Dormand-Prince (DOPRI5).
#'
#' ## Opis rešitve
#'
#' Reševanje naloge je razdeljeno na več smiselnih korakov, od postavitve modela do analize rezultatov.
#'
#' 1. **Modeliranje gibanja**
#'
#'    Gibanje matematičnega nihala opišemo s pomočjo drugega Newtonovega zakona, ki vodi do nelinearne diferencialne enačbe. 
#'    Da jo lahko numerično rešimo, jo pretvorimo v sistem dveh enačb prvega reda.
#'    Namesto kota in njegovega drugega odvoda obravnavamo kot in njegovo hitrost kot ločeni spremenljivki. 
#'    Tako dobimo sistem, ki ga lahko rešujemo z numeričnimi metodami.
#'
#' 2. **Numerična rešitev z metodo Dormand-Prince**
#'
#'    Uporabimo metodo Dormand-Prince 5. reda (DOPRI5).
#'    Metoda temelji na zaporednem računanju več vmesnih približkov, ki se potem ustrezno utežijo, da dobimo končni približek rešitve.
#'    V naši implementaciji smo koeficiente metode podali ročno (prek Butcherjeve tabele), reševanje pa poteka znotraj ene same zanke, ki korak za korakom sledi gibanju nihala v času.
#'
#' 3. **Izračun celotne energije**
#'
#'    Za vsak trenutek lahko izračunamo skupno mehansko energijo nihala, ki vključuje potencialno (zaradi višine) in kinetično (zaradi hitrosti) komponento.
#'    Čeprav masa nastopa v obeh delih formule, se zaradi analize brez dimenzij (ali primerjav) lahko izpusti, saj se njena vrednost pri razmerjih izniči.
#'
#' 4. **Ocena nihajnega časa**
#'
#'    Nihajni čas (čas enega nihaja) izračunamo iz numerične rešitve tako, da poiščemo dva zaporedna vrhova (največja odmika) in izračunamo razliko v času med njima.
#'    Ta ocena je dovolj natančna za prikaz odvisnosti nihajnega časa od začetnih pogojev, predvsem od začetnega kota.
#'
#' ## Rezultati
#' Prvi graf prikazuje kotni odmik skozi čas za dva primera:
#'
#' - **Harmonično nihalo** (analitična rešitev)
#' - **Matematično nihalo** (numerična rešitev)
#'
#' Pri manjših začetnih kotih se rešitvi dobro ujemata. Za večji začetni odmik se pojavi **fazen zamik**, kjer matematično nihalo niha počasneje.

#' Numerično izračunamo nihajni čas za različne začetne odmike in s tem različne energije.
#' Na drugem grafu vidimo kako se nihajni čas povečuje z energijo.
#'
#' Rezultat potrjuje teoretična pričakovanja. Pri majhnih energijah (majhni koti) je nihajni čas
#' približno konstanten, pri večjih pa začne hitro naraščati.
#'

include("demo.jl")

