open Izdelek

type t = {
  mutable izdelki : (int * Izdelek.t * int) list; (*Številka izdelka, izdelek, zaloga izdelka*)
  mutable izbran_izdelek : (Izdelek.t * int) option;
  mutable trenutni_znesek : float;
  mutable ali_je_pokvarjen : bool; 
  mutable transakcije : (string * float) list;
  prvotna_zaloga : (int * Izdelek.t * int) list;
}

let p1 = 0.2 (*Verjetnost, da je na začetku avtomat pokvarjen. V tem primeru znova poženemo program.*)
let p2 = 0.4 (*Verjetnost, da se izdelek pri nakupu zatakne. V tem primeru moramo plačati še enkrat.*)

(*Standarna zaloga vsakega avtomata, ki jo pripelje serviser, ko ga pokličemo.*)
let zaloga =
  [
    (1, Izdelek.ustvari "Espresso" 0.40, 100);
    (2, Izdelek.ustvari "Espresso Podaljšan" 0.40, 100);
    (3, Izdelek.ustvari "Macchiato" 0.45, 100);
    (4, Izdelek.ustvari "Choco Espresso" 0.45, 100);
    (5, Izdelek.ustvari "Cappuccino" 0.45, 100);
    (6, Izdelek.ustvari "Cappuccino Podaljšan" 0.45, 100);
    (7, Izdelek.ustvari "Bela Kava" 0.50, 100);
    (8, Izdelek.ustvari "Choco Cappuccino" 0.50, 100);
    (9, Izdelek.ustvari "Latte Macchiato" 0.50, 100);
    (10, Izdelek.ustvari "Choco Bela Kava" 0.50, 100);
    (11, Izdelek.ustvari "Kakav" 0.45, 100);
    (12, Izdelek.ustvari "Choco Milk" 0.45, 100);
    (13, Izdelek.ustvari "Toplo Pivo" 2.00, 100);
  ]

(*Ustvari avtomat*)
let ustvari izdelki_kolicine =
  let ostevilceni_izdelki = List.mapi (fun i (izdelek, kolicina) -> (i + 1, izdelek, kolicina)) izdelki_kolicine in
  {
    izdelki = ostevilceni_izdelki;
    izbran_izdelek = None;
    trenutni_znesek = 0.0;
    ali_je_pokvarjen = Random.float 1.0 < p1;
    transakcije = [];
    prvotna_zaloga = zaloga;
  }

(*Izpiše seznam izdelkov*)
let izpisi_izdelke avtomat =
  Printf.printf "\nRAZPOLOŽLJIVI IZDELKI:\n";
  List.iter
    (fun (st, izdelek, kolicina) ->
      Printf.printf "%d. %s - Količina: %d\n" st (Izdelek.v_niz izdelek) kolicina)
    avtomat.izdelki;
  Printf.printf "\n"


(*Na podlagi vnesene številke, avtomat izbere izdelek*)
let izberi_izdelek avtomat stevilka =
  match List.find_opt (fun (st, _, _) -> st = stevilka) avtomat.izdelki with
  | Some (_, izdelek, kolicina) when kolicina > 0 ->
      avtomat.izbran_izdelek <- Some (izdelek, kolicina);
      Printf.printf "Izbral si %s. Cena: %.2f €\n" izdelek.ime izdelek.cena;
      Printf.printf "\n"
  | Some (_, _, _) -> 
      Printf.printf "Izdelek s številko %d je razprodan.\n" stevilka;
      avtomat.izbran_izdelek <- None
  | None -> 
      Printf.printf "Izdelka s številko %d ni v avtomatu.\n" stevilka;
      avtomat.izbran_izdelek <- None

      
(*Funkcija, ki simulira ali se izdelek ob nakupu zatakne*)
let ali_se_zatakne () = Random.float 1.0 < p2


(*Funkcija, ki posodablja zalogo*)
let zmanjsaj_zalogo avtomat izdelek =
  avtomat.izdelki <- List.map (fun (st, iz, kol) -> if iz = izdelek then (st, iz, kol - 1) else (st, iz, kol)) avtomat.izdelki

(*Ob klicu serviserja, se avtomat napolne*)
let napolni_avtomat avtomat =
  avtomat.izdelki <- avtomat.prvotna_zaloga;
  Printf.printf "Avtomat je bil napolnjen.\n"

(*Ob končanem nakupu se prikaže pregled vseh nakupov od zagona avtomata naprej*)
let prikazi_transakcije avtomat =
Printf.printf "Dnevnik transakcij:\n";
List.iter (fun (ime, cena) ->
  Printf.printf "Izdelek: %s, Cena: %.2f €\n" ime cena) avtomat.transakcije
(*Glavna funkcija*)
let vstavi_denar avtomat znesek =
  match avtomat.izbran_izdelek with
  | None -> Printf.printf "Najprej izberi izdelek.\n"
  | Some (izdelek, kolicina) ->
      if ali_se_zatakne () then (
        Printf.printf "Izdelek %s se je zataknil. Poskusi plačati še enkrat.\n" izdelek.ime;
        avtomat.izbran_izdelek <- Some (izdelek, kolicina))
      else (
        avtomat.trenutni_znesek <- avtomat.trenutni_znesek +. znesek;
        let preostanek = izdelek.cena -. avtomat.trenutni_znesek in
        if preostanek > 0.0 then (
          Printf.printf "Vstavil si %.2f €. Potrebuješ še %.2f €.\n"
            avtomat.trenutni_znesek preostanek;
          avtomat.izbran_izdelek <- Some (izdelek, kolicina))
        else
          let drobiz = -.preostanek in
          Printf.printf "Transakcija zaključena. Kupil si %s.\n" izdelek.ime;
          if drobiz > 0.0 then (
            Printf.printf "Drobiž je %.2f €.\n" drobiz);
         
          zmanjsaj_zalogo avtomat izdelek;
       
          avtomat.transakcije <- (izdelek.ime, izdelek.cena) :: avtomat.transakcije;
          avtomat.izbran_izdelek <- None;
          avtomat.trenutni_znesek <- 0.0;
          Printf.printf "\n";
          prikazi_transakcije avtomat
      )

