open Mylib
open Izdelek
open Avtomat

let seznam_izdelkov =
  [
    Izdelek.ustvari "Espresso" 0.40;
    Izdelek.ustvari "Espresso Podaljšan" 0.40;
    Izdelek.ustvari "Macchiato" 0.45;
    Izdelek.ustvari "Choco Espresso" 0.45;
    Izdelek.ustvari "Cappuccino" 0.45;
    Izdelek.ustvari "Cappuccino Podaljšan" 0.45;
    Izdelek.ustvari "Bela Kava" 0.50;
    Izdelek.ustvari "Choco Cappuccino" 0.50;
    Izdelek.ustvari "Latte Macchiato" 0.50;
    Izdelek.ustvari "Choco Bela Kava" 0.50;
    Izdelek.ustvari "Kakav" 0.45;
    Izdelek.ustvari "Choco Milk" 0.45;
    Izdelek.ustvari "Toplo Pivo" 2.00;
  ]

let () =
  Random.self_init (); (*Poskrbi, da je vsakič naključno generirano.*)
  let rec zanka () = 
    let avto = Avtomat.ustvari seznam_izdelkov in
    if avto.ali_je_pokvarjen then
      Printf.printf "Avtomat je pokvarjen. Pojdi na kavo v Mafijo ali ponovno zaženi avtomat!.\n"
    else (
      Avtomat.izpisi_izdelke avto;
      let rec izberi () =
        Printf.printf "Prosimo, izberite izdelek: ";
        let ime_izdelka = read_line () in
        match 
          List.find_opt (fun izdelek -> izdelek.ime = ime_izdelka) seznam_izdelkov with
          | Some _ -> Avtomat.izberi_izdelek avto ime_izdelka
          | None -> 
          Printf.printf "Izdelek %s ni na voljo. Prosimo, izberite veljaven izdelek.\n" ime_izdelka;
          izberi ()
      in izberi ();

      let rec vstavi_denar () =
        Printf.printf "Vstavite denar: ";
        try
          let znesek = read_float () in
          Avtomat.vstavi_denar avto znesek;
          match avto.izbran_izdelek with
          | Some _ -> vstavi_denar ()
          | None -> 
            Printf.printf "\n"; 
            zanka () 
          with
          | Failure _ ->
            Printf.printf "Neveljaven vnos. Prosimo, vnesite veljavno številko.\n";
            vstavi_denar ()
          in
          vstavi_denar ()
    )
    in zanka ()
  
