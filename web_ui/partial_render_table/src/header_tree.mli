open! Core
open! Bonsai_web

type t = private
  | Leaf of leaf
  | Group of group
  | Organizational_group of t list
  | Spacer of t

and leaf = private
  { leaf_header : Vdom.Node.t
  ; initial_width : Css_gen.Length.t
  ; visible : bool
  }

and group = private
  { children : t list
  ; group_header : Vdom.Node.t
  }
[@@deriving sexp]

val leaf : header:Vdom.Node.t -> initial_width:Css_gen.Length.t -> visible:bool -> t
val group : header:Vdom.Node.t -> t list -> t
val org_group : t list -> t
val colspan : t -> int
val height : t -> int
val leaves : t -> leaf list

(** For each leaf, [column_names] returns a list like [group_header; group_header; ...;
    leaf_header], where the group labels are that leaf's ancestors, ordered left to right
    from most to least distant. Used for rendering column groups in tests. *)
val column_names : t -> Vdom.Node.t list list
