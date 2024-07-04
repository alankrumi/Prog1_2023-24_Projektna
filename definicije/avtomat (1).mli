
type t = {
  mutable izdelki : (int * Izdelek.t * int) list;
  mutable izbran_izdelek : (Izdelek.t * int) option;
  mutable trenutni_znesek : float;
  mutable ali_je_pokvarjen : bool;
  mutable transakcije : (string * float) list;
  prvotna_zaloga : (int * Izdelek.t * int) list;
}

val p1 : float
val p2 : float
val zaloga : (int * Izdelek.t * int) list
val ustvari : (Izdelek.t * int) list -> t
val izpisi_izdelke : t -> unit
val izberi_izdelek : t -> int -> unit
val ali_se_zatakne : unit -> bool
val zmanjsaj_zalogo : t -> Izdelek.t -> unit
val napolni_avtomat : t -> unit
val vstavi_denar : t -> float -> unit
val prikazi_transakcije : t -> unit
