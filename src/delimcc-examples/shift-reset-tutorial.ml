
(* let (reset, shift) : ((unit -> 'a) -> 'a) * ((('a -> 'b) -> 'b) -> 'a) =  *)
let delimited_control =
    fun rcv ->
        let p = Delimcc.new_prompt () in
        let reset = fun thunk -> Delimcc.push_prompt p thunk 
        and shift = fun rcv -> Delimcc.shift p rcv in
        rcv reset shift
;;

let () =
    delimited_control (fun reset shift -> 
        assert (reset (fun () -> 3 + (5 * 2)) - 1 = 12));
    delimited_control (fun reset shift -> 
        assert (5 * reset (fun () -> (2 * 3) + 3 * 4) = 5*18));
    delimited_control (fun reset shift -> 
        assert ((reset (fun () -> if 2 = 3 then "hello" else "hi") ^ " world") = "hi world"));
    delimited_control (fun reset shift -> 
        assert (fst (reset (fun () -> let x = 1 + 2 in (x, 4))) = 3));
    delimited_control (fun reset shift -> 
        assert (String.length (reset (fun () -> "x" ^ string_of_int (3 + 1))) = 2));
    delimited_control (fun reset shift -> 
        assert (reset (fun () -> 3 + shift (fun _ -> 5 * 2) - 1) = 10)); (* instead of 12 *)
    (*delimited_control (fun reset shift -> 
        assert (reset (fun () -> 3 + shift (fun _ -> "hello") - 1) = "hello")); *)
    delimited_control (fun reset shift -> 
        assert (reset (fun () -> 3 + shift (fun _ -> 5 * 2)) - 1 = 9));
    (*delimited_control (fun reset shift -> 
        assert (reset (fun () -> 3 + shift (fun _ -> "hello")) - 1 = "hello")); *)
    delimited_control (fun reset shift -> 
        assert ( 5 * reset (fun () -> shift (fun _ -> 1) + 3 * 4) = 5));
    delimited_control (fun reset shift -> 
        assert (reset (fun () -> if shift (fun _ -> true) then false else false)));
    delimited_control (fun reset shift -> 
        assert (fst (reset (fun () -> let x = shift (fun _ -> (3, 3)) in (x+1, x+2))) = 3));
    delimited_control (fun reset shift -> 
        let rec times = function
            | [] -> 1
            | 0 :: _ -> shift (fun _ -> 0)
            | x :: rest -> x * times rest in
        assert (reset (fun () -> times [1;2;3;4;5;]) = 1*2*3*4*5);
        assert (reset (fun () -> times [1;2;3;0;4;5;]) = 0)); (* 0 indeed, not 1*2*3*0 *)
    delimited_control (fun reset shift -> 
        let k = fun x -> reset (fun () -> 3 + shift (fun k -> k x) - 1) in
        assert (k 10 = 12));
    delimited_control (fun reset shift -> 
        let rec id_gen lst tail = 
            match lst with
            | [] -> shift (fun k -> k tail)
            | x :: rest -> x :: id_gen rest tail in
        let one_two_three_prefix = id_gen [1;2;3;] in
        assert (reset (fun () -> one_two_three_prefix [4;5;6;]) = [1;2;3;4;5;6;]);
        assert (reset (fun () -> one_two_three_prefix [7;8;9;]) = [1;2;3;7;8;9;]));
    delimited_control (fun reset shift -> 
        assert (true));
;;

type 'a tree = Empty | Node of 'a tree * 'a * 'a tree ;;

let rec walk : int tree -> unit = 
    fun tree ->
        match tree with
        | Empty -> ()
        | Node (left, i, right) ->
            walk left;
            print_int i;
            walk right;
            () in
let left = Node (Empty, 1, Empty) in
let right = Node (Empty, 3, Empty) in
let t = Node (left, 2, right) in
walk t
;;

type 'a visit = Done | Next of 'a * (unit -> 'a visit) ;;

delimited_control (fun reset shift ->
    let yield n = shift (fun k -> Next (n, k)) in
    let rec walk = 
        fun tree ->
            match tree with
            | Empty -> ()
            | Node (left, i, right) ->
                walk left;
                yield i;
                walk right;
                () in
    let run tree = reset (fun () -> walk tree; Done) in
    let print_nodes tree =
        let rec loop r =
            match r with
            | Done -> ()
            | Next (n, k) -> print_int n; loop (k ()) in
        loop (run tree) in
    let left = Node (Empty, 1, Empty) in
    let right = Node (Empty, 3, Empty) in
    let t = Node (left, 2, right) in
    print_nodes t)
;;

(* Refactoring and abstraction of operations over all elements within the tree *)
delimited_control (fun reset shift ->
    let yield n = shift (fun k -> Next (n, k)) in
    let rec walk = 
        fun tree ->
            match tree with
            | Empty -> ()
            | Node (left, i, right) ->
                walk left;
                yield i;
                walk right;
                () in
    let run tree = reset (fun () -> walk tree; Done) in
    let printer n rest = print_int n ; rest () in
    let adder n rest = n + rest () in
    let doer op init tree =
        let rec loop r =
            match r with
            | Done -> init 
            | Next (n, k) -> let rest = fun () -> loop (k ()) in op n rest
        in loop (run tree) in
    let left = Node (Empty, 1, Empty) in
    let right = Node (Empty, 3, Empty) in
    let t = Node (left, 2, right) in
    doer printer () t;
    print_int (doer adder 0 t))
;;

(* Attempt to visit the fringe of two trees in parallel *)
let () = delimited_control (fun reset shift ->
    let yield n = shift (fun k -> Next (n, k)) in
    let rec walk_fringe = 
        fun tree ->
            match tree with
            | Empty -> ()
            | Node (Empty, i, right) ->
                yield i ; walk_fringe right; ()
            | Node (left, i, Empty) ->
                walk_fringe left ; yield i; ()
            | Node (left, _, right) ->
                walk_fringe left ; walk_fringe right ; ()
            in
    let run tree = reset (fun () -> walk_fringe tree; Done) in
    let doer t1 t2 =
        let rec loop r s =
            match r, s with
            | Done, Done -> true 
            | Next (m, km), Next (n, kn) when m = n -> loop (km ()) (kn ())
            | _, _ -> false
        in loop (run t1) (run t2) in
    (* trees *)
    let t1 = Node (Node (Empty, 1, Empty), 0, Node(Node(Empty, 3, Empty), 2, Node (Empty, 4, Empty))) in
    let t2 = Node (Node (Node(Empty, 1, Empty), 2, Node(Empty, 3, Empty)), 0, Node (Empty, 4, Empty)) in
    let t3 = Node (Empty, 1, Node(Empty, 3, Node(Empty, 4, Empty))) in
    assert (doer t1 t2 && doer t2 t3 && doer t1 t3))
;;

let () = delimited_control (fun reset shift ->
    let t = fun value -> shift (fun k -> fun y -> k value y) in
    let printf = reset (fun () -> 
        let prefix = t "hello" in 
        fun x -> x ^ prefix ^ "world") in
    let run = fun thunk -> 
        reset (fun () -> let result = thunk () in fun state -> result) "" in
    let result = run (fun () -> printf "good") in   
        assert (print_string result; result = "goodhelloworld");
) ;;

let () = delimited_control (fun reset shift ->
    let t = fun value -> shift (fun k -> fun y -> k value y) in
    let printf = reset (fun () -> 
        let prefix = t "hello" in 
        fun [x;y] -> x ^ prefix ^ "world" ^ y) in
    let run = fun thunk -> 
        reset (fun () -> let result = thunk () in fun state -> result) [] in
    let result = run (fun () -> printf ["good";"day"]) in   
        assert (print_string result; result = "goodhelloworldday");
) ;;


let () = delimited_control (fun reset shift ->
    let get = fun () -> shift (fun k -> fun state -> k state state) in
    let tick = fun () -> shift (fun k -> fun state -> k state (state + 1)) in
    let put = fun value -> shift (fun k -> fun state -> k state value) in
    let run = fun thunk -> 
        reset (fun () -> let result = thunk () in fun state -> result) 0 in
    assert (run (fun () -> 
        tick ();
        tick ();
        let a = get () in 
        tick ();
        get () - a) = 1);
    assert (run (fun () -> 
        let a = tick (); get () in 
        let b = tick (); get () in 
        a - b) = -1);
    assert (run (fun () -> (tick (); get ()) - (tick (); get ())) = 1);
    assert (run (fun () -> 
        tick ();
        tick ();
        tick ();
        put 0;
        tick ();
        get ()) = 1);
) ;;
 
type term_t = Var of string
            | Lam of string * term_t
            | App of term_t * term_t ;;

let () = delimited_control (fun reset shift ->
    assert (reset (fun () -> 1 + (shift (fun k -> 2 * 3))) = 6) ;
    assert (reset (fun () -> 1 + (shift (fun k -> 2 * k 3))) = 8) 
);;

let () = delimited_control (fun reset shift ->
    let either args = shift (fun k -> List.iter k args) in
    reset (fun () -> let x = either [0; 1; 2] in print_int x ) ; print_newline ();
);;

let x = delimited_control (fun reset shift ->
    let either args last = 
        shift (fun k ->
            let rec e = function
                    | [] -> k last (* if `k` is not applied then `last` is not printed *)
                    | x::xs -> k x; e xs; x
            in e args) in
    reset (fun () -> let x = either [1;2;3;] 0 in print_int x ; x)
);;

let () = delimited_control (fun reset shift ->
    let either args = shift (fun k -> List.iter k args) in
    reset (fun () ->
        let p = either [true; false;] in
        let q = either [true; false;] in
        if (p || q) && (p || not q) && (not p || not q)
        then (  print_string (string_of_bool p); 
                print_string ", "; 
                print_string (string_of_bool q); 
                print_newline ()))
);;


let () = delimited_control (fun reset shift ->
    let either args = shift (fun k -> List.iter k args) in
    reset (fun () ->
        let range = [1.;2.;3.;4.;5.;6.;7.;8.;9.;10.;11.] in
        let x = either range in
        let y = either range in
        let z = either range in
        if x**2. +. y**2. = z**2.
        then (  print_string "(" ; 
                print_string (string_of_float x); 
                print_string ", "; 
                print_string (string_of_float y); 
                print_string ", "; 
                print_string (string_of_float z); 
                print_string ")"; 
                print_newline ()))
);;







