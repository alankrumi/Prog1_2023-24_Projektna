open Izdelek

type t = {
  izdelki : Izdelek.t list;
  mutable izbran_izdelek : Izdelek.t option;
  mutable trenutni_znesek : float;
  mutable ali_je_pokvarjen : bool;
}

let p1 = 0.1
(*Ker je avtomat zelo star, je velikokrat pokvarjen. Zato se z verjetnostjo p1 na začetku izpiše, da je avtomat pokvarjen.*)

let p2 = 0.4
(*Izdelki se velikokrat zataknejo. Vsakič, ko kupimo izdelek, se ta zatakne z verjetnostjo p2.*)

let ustvari izdelki =
  {
    izdelki;
    izbran_izdelek = None;
    trenutni_znesek = 0.0;
    ali_je_pokvarjen = Random.float 1.0 < p1;
  }

let izpisi_izdelke avtomat =
  Printf.printf "Razpoložljivi izdelki:\n";
  List.iter
    (fun izdelek -> Printf.printf "%s\n" (Izdelek.v_niz izdelek))
    avtomat.izdelki

let izberi_izdelek avtomat ime_izdelka =
  match
    List.find_opt (fun izdelek -> izdelek.ime = ime_izdelka) avtomat.izdelki
  with
  | Some izdelek ->
      avtomat.izbran_izdelek <- Some izdelek;
      avtomat.trenutni_znesek <- 0.0;
      Printf.printf "Izbrali ste %s. Cena: %.2f €\n" ime_izdelka izdelek.cena
  | None -> Printf.printf "Izdelek %s ni na voljo.\n" ime_izdelka

let ali_se_zatakne () = Random.float 1.0 < p2

let vstavi_denar avtomat znesek =
  match avtomat.izbran_izdelek with
  | None -> Printf.printf "Prosimo, najprej izberite izdelek.\n"
  | Some izdelek ->
      if ali_se_zatakne () then (
        Printf.printf "Izdelek %s se je zataknil. Poskusi plačati še enkrat.\n" izdelek.ime;
        avtomat.izbran_izdelek <- Some izdelek)
      else (
        avtomat.izbran_izdelek <- None;
        avtomat.trenutni_znesek <- avtomat.trenutni_znesek +. znesek;
        let preostanek = izdelek.cena -. avtomat.trenutni_znesek in
        if preostanek > 0.0 then (
          Printf.printf "Vstavili ste %.2f €. Potrebujete še %.2f €.\n"
            avtomat.trenutni_znesek preostanek;
          avtomat.izbran_izdelek <- Some izdelek)
        else
          let drobiz = -.preostanek in
          Printf.printf "Transakcija zaključena. Kupili ste %s.\n" izdelek.ime;
          if drobiz > 0.0 then (
            Printf.printf "Vaš drobiž je %.2f €.\n" drobiz;
            avtomat.izbran_izdelek <- None;
            avtomat.trenutni_znesek <- 0.0))
