

(* ------------------------------------------------------------------------ *)
(* Streams and combiners                                                    *) 
(* ------------------------------------------------------------------------ *)
type 'a visit = Done | Next of 'a * (unit -> 'a visit) ;;

let rec mplus (c1: 'a visit) (c2: 'a visit) : 'a visit =
   match c1 with
     Done -> c2
   | Next (x, f) -> Next (x, fun () -> mplus c2 (f ()));;

let rec mplusf (c1: 'a visit) (c2: unit -> 'a visit) : 'a visit =
   match c1 with
     Done -> c2 ()
   | Next (x, f) -> Next (x, fun () -> mplusf (c2 ()) (fun () -> f ()));;

let rec bind (c : 'a visit) (g : 'a -> 'b visit) : 'b visit =
  match c with
    Done -> Done
  | Next (x,f) -> mplusf (g x) (fun () -> bind (f ()) g);;
