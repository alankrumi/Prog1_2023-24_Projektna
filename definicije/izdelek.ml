type t = {ime : string; cena : float}

let ustvari ime cena = {ime; cena}
(*ustvari izdelek*)
let v_niz izdelek = Printf.sprintf "%s: %.2f €" izdelek.ime izdelek.cena (*izpise ime izdelka in ceno z evri, centi*)
