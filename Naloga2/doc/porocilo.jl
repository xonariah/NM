#' # Gauss-Legendre kvadratura
#' Ariana Kržan (<ak1193@student.uni-lj.si>)
#'
#' ## Opis naloge
#'
#' V nalogi obravnavamo **Gauss-Legendre kvadraturo**, ki je ena izmed najbolj
#' učinkovitih metod za numerično integracijo. Ideja metode je, da približamo
#' določen integral oblike
#'
#' $$\int_a^b f(x)\,dx$$
#'
#' z uteženo vsoto funkcijskih vrednosti v skrbno izbranih točkah
#' (t. i. Gaussove točke).
#'
#' V primeru **dveh točk** (dvotočkovna Gauss-Legendre kvadratura) pravilo na
#' intervalu $[0,h]$ lahko zapišemo kot
#'
#' $$\int_0^h f(x)\,dx \;=\; A f(x_1) + B f(x_2) + R_f,$$
#'
#' kjer sta $x_1$ in $x_2$ ustrezni Gaussovi točki, $A$ in $B$ pa pripadajoči
#' uteži. Člen $R_f$ predstavlja napako pravila.
#'
#' Na intervalu $[-1,1]$ pa pravilo dobi posebno enostavno obliko:
#'
#' $$\int_{-1}^1 f(x)\,dx \;\approx\; f\!\left(-\tfrac{1}{\sqrt{3}}\right)
#' \;+\; f\!\left(\tfrac{1}{\sqrt{3}}\right).$$
#'
#' Če integral računamo na poljubnem intervalu $[a,b]$, uporabimo afino preslikavo
#'
#' $$x = \frac{b-a}{2}\,\xi + \frac{a+b}{2}, \quad \xi \in [-1,1],$$
#'
#' kar da pravilo:
#'
#' $$\int_a^b f(x)\,dx \;\approx\; \frac{b-a}{2}\Big[f(x_1) + f(x_2)\Big].$$
#'
#' Teoretična napaka tega pravila je
#'
#' $$R_f = -\frac{(b-a)^5}{90 \cdot 2^4}\,f^{(4)}(\xi), \quad \xi\in[a,b].$$
#'
#' To pomeni, da je pravilo **točno za vse polinome do stopnje 3**.

#'
#' ## Izpeljava sestavljenega pravila
#'
#' Da bi integrirali na večjem intervalu $[a,b]$, ga razdelimo na $n$ enakih
#' podintervalov dolžine $h = (b-a)/n$. Na vsakem podintervalu uporabimo
#' dvotočkovno Gaussovo pravilo in rezultate seštejemo:
#'
#' $$\int_a^b f(x)\,dx \;\approx\; \sum_{i=0}^{n-1}
#' \frac{h}{2}\Big[f(x_{i,1}) + f(x_{i,2})\Big].$$
#'
#' Tako dobimo **sestavljeno Gauss-Legendre kvadraturo**.
#'
#' Pri tem je število klicev funkcije $f$ enako $2n$, saj na vsakem podintervalu
#' potrebujemo dve vrednosti.
#'
#' ## Opis rešitve
#'
#' Reševanje naloge poteka v več korakih:
#'
#' 1. **Dvotočkovna Gauss-Legendrova kvadratura** 
#'    Najprej smo implementirali osnovno pravilo `gauss_legendre_2pt(f,a,b)`.  
#'    Uporabili smo znane Gaussove točke na intervalu $[-1,1]$ in uteži $A=B=1$.  
#'    Točke preslikamo na poljuben interval $[a,b]$ z **afino preslikavo**
#'    Funkcija vrne en sam približek integrala na celem intervalu.
#'
#' 2. **Sestavljena Gauss-Legendrova kvadratura**  
#'    Ker osnovno pravilo ni dovolj natančno na daljših intervalih, smo ga
#'    razširili. Interval $[a,b]$ razdelimo na $n$ podintervalov enake dolžine
#'    $h=(b-a)/n$. Na vsakem podintervalu uporabimo `gauss_legendre_2pt` in
#'    rezultate seštejemo.  
#'    Implementacija je v funkciji `sestavljena_gauss_legendre(f,a,b,n)`, ki
#'    vrača tudi število klicev funkcije $f$. To število je vedno $2n$, ker na
#'    vsakem od $n$ podintervalov potrebujemo dve funkcijski vrednosti.
#'
#' 3. **Adaptivna integracija do točnosti**  
#'    Da bi dosegli zahtevano natančnost, smo implementirali funkcijo
#'    `integriraj_do_tocnosti(f,a,b; tol)`. Ideja je naslednja:
#'    - začnemo z $n=1$ podintervalom in izračunamo približek,
#'    - nato podvojimo število podintervalov ($n=2,4,8,\ldots$) in vsakič
#'      primerjamo nov rezultat s prejšnjim,
#'    - če se zaporedna približka razlikujeta za manj kot podana toleranca
#'      (relativna napaka), ustavimo postopek in rezultat vrnemo kot dovolj
#'      natančen.  
#'    S tem postopkom se približek izboljšuje, dokler ne dosežemo zahtevane
#'    točnosti. Funkcija vrača končni rezultat, uporabljeno število intervalov
#'    $n$ in skupno število klicev funkcije $f$.
#'
#' 4. **Uporaba na danem integralu**  
#'    V skladu z navodili naloge smo definirali funkcijo
#' ```math
#' f(x) = \begin{cases}
#'   1, & x=0,\\
#'   \tfrac{\sin x}{x}, & x\neq 0,
#' \end{cases}
#' ```
#' da se izognemo nedoločenosti v $x=0$.
#' 
#' Nato smo z `integriraj_do_tocnosti` izračunali integral
#'
#' ```math
#' I = \int_0^5 \frac{\sin x}{x}\,dx
#' ```
#'    do zahtevane natančnosti $10^{-10}$. Rezultat skupaj s številom klicev
#'    funkcije vrne pomožna funkcija `test_integral()`.
#'
#' S tem pristopom smo najprej matematično izpeljali pravilo, ga nato prevedli
#' v kodo, razširili na sestavljeno in adaptivno različico ter ga na koncu
#' uporabili za konkreten integral iz naloge.
#' ## Rezultati
#'
#' Za preverjanje konvergence smo pripravili datoteko `demo.jl`, kjer na
#' intervalu $[0,5]$ računamo integral
#'
#' ```math
#' I = \int_0^5 \frac{\sin x}{x}\,dx.
#' ```
#'
#' Program izračuna približke za zaporedne vrednosti $n$ (število podintervalov)
#' ter prikaže tabelo s primerjavo aproksimacije in relativne napake glede na
#' znano referenčno vrednost $I \approx 1.549931244944\dots$.
#'
#' Poleg tabele izrišemo tudi graf konvergence: na log-log skali prikažemo
#' relativno napako v odvisnosti od števila podintervalov $n$.
#'
include("demo.jl")
