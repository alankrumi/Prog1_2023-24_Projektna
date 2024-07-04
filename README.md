# Prog1_2023-24_Projektna
Project in Ocaml

V tem repozitoriju bom implementiral Avtomat za kavo.

# Avtomat za kavo

Ta projekt implementira avtomat za kavo v programskem jeziku Ocaml. Avtomat omogoča izbiro izdelkov, vstavljanje denarja in izvedbo nakupa. Prav tako beleži vse transakcije in omogoča ponoven prikaz vseh transakcij. Avtomat sledi zalogi izdelkov in ima možnost napolnitve zalog, ko določenega izdelka zmanjka.
Ker pa je avtomat star in slabo vzdrževan, se vsake toliko zgodi, da sploh ne dela. Ali pa se kak izdelek zatakne, ko ga poskusimo kupiti.

## Struktura

Projekt je razdeljen v več datotek, da je koda bolj organizirana in modularna:

- `tekstovni_vmesnik.ml`
- `avtomat.ml`
- `avtomat.mli`
- `izdelek.ml`
- `izdelek.mli`


## Primer uporabe

RAZPOLOŽLJIVI IZDELKI:
1. Espresso: 0.40 € - Količina: 10
2. Espresso Podaljšan: 0.40 € - Količina: 0
3. Macchiato: 0.45 € - Količina: 1
...

Izberi izdelek (vpiši številko): 1
Izbral si Espresso. Cena: 0.40 €

Vstavi denar: 0.40
Transakcija zaključena. Kupil si Espresso.

Dnevnik transakcij:
Izdelek: Espresso, Cena: 0.40 €
...

Želiš kupiti še kaj? (da/ne): ne
Hvala za uporabo avtomata. Adijo!


