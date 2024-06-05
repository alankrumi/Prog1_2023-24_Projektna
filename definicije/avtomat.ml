open Izdelek

type t = {
  izdelki : Izdelek.t list;
  mutable izbran_izdelek : Izdelek.t option;
  mutable trenutni_znesek : float;
}

let ustvari izdelki = {izdelki; izbran_izdelek = None; trenutni_znesek = 0.0 }

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
      Printf.printf "Izbrali ste %s. Cena: %.2f €\n" izdelek.ime izdelek.cena
  | None -> Printf.printf "Izdelek %s ni na voljo.\n" ime_izdelka

let vstavi_denar avtomat znesek =
  match avtomat.izbran_izdelek with
  | None -> Printf.printf "Prosimo, najprej izberite izdelek.\n"
  | Some izdelek ->
      avtomat.izbran_izdelek <- None;
      avtomat.trenutni_znesek <- avtomat.trenutni_znesek +. znesek;
      let preostanek = izdelek.cena -. avtomat.trenutni_znesek in
      if preostanek > 0.0 then (
        Printf.printf "Vstavili ste %.2f €. Preostanek: %.2f €\n"
          avtomat.trenutni_znesek preostanek;
        avtomat.izbran_izdelek <- Some izdelek)
      else
        let drobiz = -.preostanek in
        Printf.printf "Kupili ste %s.\n" izdelek.ime;
        if drobiz > 0.0 then (
          Printf.printf "Vaš drobiž je %.2f €.\n" drobiz;
          avtomat.izbran_izdelek <- None;
          avtomat.trenutni_znesek <- 0.0)
