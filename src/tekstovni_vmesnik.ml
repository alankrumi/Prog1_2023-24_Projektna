open Mylib
open Avtomat

(*testni primer zaloge*)
(*Nekaterih izdelkov ni na zalogi, nekaterih je veliko*)
let seznam_izdelkov =
  [
    (Izdelek.ustvari "Espresso" 0.40, 10);
    (Izdelek.ustvari "Espresso Podaljšan" 0.40, 0);
    (Izdelek.ustvari "Macchiato" 0.45, 1);
    (Izdelek.ustvari "Choco Espresso" 0.45, 5);
    (Izdelek.ustvari "Cappuccino" 0.45, 8);
    (Izdelek.ustvari "Cappuccino Podaljšan" 0.45, 0);
    (Izdelek.ustvari "Bela Kava" 0.50, 7);
    (Izdelek.ustvari "Choco Cappuccino" 0.50, 3);
    (Izdelek.ustvari "Latte Macchiato" 0.50, 6);
    (Izdelek.ustvari "Choco Bela Kava" 0.50, 2);
    (Izdelek.ustvari "Kakav" 0.45, 0);
    (Izdelek.ustvari "Choco Milk" 0.45, 10);
    (Izdelek.ustvari "Toplo Pivo" 2.00, 1);
  ]

(*Glavna zanka*)
let rec zanka avto =
  if avto.ali_je_pokvarjen then
    Printf.printf "Avtomat je pokvarjen. Pojdi na kavo v Mafijo ali ponovno zaženi avtomat!.\n"
  else (
    Avtomat.izpisi_izdelke avto;
    let rec izberi () =
      Printf.printf "Izberi izdelek (vpiši številko): ";
      try
        let stevilka = read_int () in
        Avtomat.izberi_izdelek avto stevilka;
        match avto.izbran_izdelek with
        | Some _ -> () (*Za pravilno vneseno številko je vse v redu*)
        | None -> 
          if stevilka > 0 && stevilka <= List.length seznam_izdelkov then 
          (
          (*Če izberemo razprodan izdelek, lahko pokličemo serviserja, ki obnovi zalogo*)
          Printf.printf "Želiš poklicati serviserja za polnjenje avtomata? (da/ne): ";
          let odgovor = read_line () in
          if odgovor = "da" then (
            Avtomat.napolni_avtomat avto;
            Avtomat.izpisi_izdelke avto;
            izberi ()
          ) else
            izberi ()
          )
          else
            izberi () (*Če vnesemo številko, ki pa ne ustreza nobenemu izdelku, nas avtomat spet vpraša za številko*)
      with
      | Failure _ -> (*Če ne vnesemo številke, nas avtomat opozori in ponovno zahteva številko*)
        Printf.printf "Neveljavna številka. Vnesi veljavno številko!\n";
        izberi ()
    in izberi ();

    let rec vstavi_denar () =
      Printf.printf "Vstavi denar: ";
      try
        let znesek = read_float () in
        Avtomat.vstavi_denar avto znesek;
        Avtomat.izpisi_izdelke avto;
        match avto.izbran_izdelek with
        | Some _ -> vstavi_denar ()
        | None -> 
          Printf.printf "\n"; 
          Printf.printf "Želiš kupiti še kaj? (da/ne): ";
          let odgovor = read_line () in
          if odgovor = "da" then
            zanka avto
          else (
            Printf.printf "Hvala za uporabo avtomata. Adijo!\n";
            Avtomat.prikazi_transakcije avto
          )
      with
      | Failure _ -> (*Če na vstavimo float številke, nas avtomat opozori in ponovno zahteva vnos*)
        Printf.printf "Neveljaven vnos. Vnesi veljavno številko.\n";
        vstavi_denar ()
    in
    vstavi_denar ()
  )

(*Glavna funkcija, zažene avtomat*)
let () =
  Random.self_init ();
  let avto = Avtomat.ustvari seznam_izdelkov in
  zanka avto
