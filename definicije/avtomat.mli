
type t = {
  izdelki : Izdelek.t list;
  mutable izbran_izdelek : Izdelek.t option;
  mutable trenutni_znesek : float;
  mutable ali_je_pokvarjen : bool;
}

val ustvari : Izdelek.t list -> t
val izpisi_izdelke : t -> unit
val izberi_izdelek : t -> string -> unit
val ali_se_zatakne : unit -> bool
val vstavi_denar : t -> float -> unit
