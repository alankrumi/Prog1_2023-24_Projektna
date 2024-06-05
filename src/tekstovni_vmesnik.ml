open Mylib
open Izdelek
open Avtomat

let izdelki =
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
Random.self_init ();
  let avto = Avtomat.ustvari izdelki in
    try
    Avtomat.izpisi_izdelke avto;

    let rec izberi () =
      Printf.printf "Prosimo, izberite izdelek: ";
      let ime_izdelka = read_line () in
      match
        List.find_opt (fun izdelek -> izdelek.ime = ime_izdelka) izdelki
      with
      | Some _ -> Avtomat.izberi_izdelek avto ime_izdelka
      | None ->
          Printf.printf
            "Izdelek %s ni na voljo. Prosimo, izberite veljaven izdelek.\n"
            ime_izdelka;
          izberi ()
    in
    izberi ();

    let rec zanka () =
      Printf.printf "Vstavite denar: ";
      try
        let znesek = read_float () in
        Avtomat.vstavi_denar avto znesek;
        match avto.izbran_izdelek with
        | Some _ ->
            zanka () 
        | None -> () 
      with Failure _ ->
        Printf.printf "Neveljaven vnos. Prosimo, vnesite veljavno številko.\n";
        zanka ()
    in
    zanka ()
  with End_of_file -> Printf.printf "\nVnos se je nepričakovano končal.\n"
