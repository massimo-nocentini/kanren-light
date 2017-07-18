
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

(* ------------------------------------------------------------------------ *)
(* shift, reset, or, and                                                    *)
(* ------------------------------------------------------------------------ *)
let main_prompt : 'a Delimcc.prompt = Delimcc.new_prompt () ;;
let reset = fun thunk -> Delimcc.push_prompt main_prompt thunk 
and shift : ((unit -> int visit) -> int visit) -> unit = 
    fun rcv -> Delimcc.shift main_prompt rcv ;;

let yield (n : int) = shift (fun (k : unit -> int visit) -> Next (n, k)) ;;

let run (walk : 'a -> unit) tree : 'b visit = 
    reset (fun () -> walk tree; Done);;

let rec nur (s : 'a visit) : unit =
    match s with
    | Done -> ()
    | Next (n, k) -> yield n; nur (k ()) 
;;

let orelse f g x = 
    (try f x with Failure _ -> () ); g x
;;

let andalso f g x = 
    let s : int visit = run f x in
    let r = bind s (run g) in
    nur r
;;

(* ------------------------------------------------------------------------ *)
(* Trees                                                                    *)
(* ------------------------------------------------------------------------ *)

type 'a tree = Empty | Node of 'a tree * 'a * 'a tree ;;

let t3 = Node (Empty, 1, Node(Node(Empty, 2, Empty), 3, Node(Empty, 4, Empty))) ;;

let node t = 
    match t with
    | Node (_, x, _) when  x == 2 || x == 4 -> yield x; ()
    | _ -> ()
;;

let left p = function 
    | Node (l, _, _) -> p l
    | _ -> () 
;;

let right p = function 
    | Node (_, _, r) -> p r
    | _ -> ()
;;

let rec walk t = (orelse node (orelse (left walk) (right walk))) t;;

let print_nodes walk tree =
    let rec loop r =
        match r with
        | Done -> ()
        | Next (n, k) -> print_int n; loop (k ()) in
    loop (run walk tree) ;;

let () = print_nodes walk t3;;

let () = print_nodes (andalso walk (function x when x > 3 -> yield x; ()
                                        | _ -> ())) t3;;

