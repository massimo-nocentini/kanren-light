
#use "streams.ml";;

(* ------------------------------------------------------------------------ *)
(* shift, reset, or, and                                                    *)
(* ------------------------------------------------------------------------ *)
let main_prompt : 'a Delimcc.prompt = Delimcc.new_prompt () ;;
let reset = fun thunk -> Delimcc.push_prompt main_prompt thunk 
and shift : ((unit -> 'a visit) -> 'a visit) -> unit = 
    fun rcv -> Delimcc.shift main_prompt rcv ;;

let yield (n : 'a) = shift (fun (k : unit -> 'a visit) -> Next (n, k)) ;;

let run (walk : 'a -> 'b) (x : 'a) : 'b visit = 
    reset (fun () -> walk x; Done);;

let rec nur (s : 'a visit) : 'a =
    match s with
    | Done -> failwith "no more solutions"
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

