open! Core
open! Bonsai_web
open Virtual_dom.Vdom
open Js_of_ocaml

let () = Async_js.init ()

let run ?custom_connector ~id computation =
  (* Because we're iframing into this app from docpub, we look up what the
     current url-hash is, and only run the requested example. *)
  let current_hash = Dom_html.window##.location##.hash |> Js.to_string in
  print_s [%message (current_hash : string) (id : string)];
  if String.equal current_hash ("#" ^ id)
  then Bonsai_web.Start.start ?custom_connector computation
  else ()
;;

let run_vdom ?(include_html = false) vdom =
  let vdom =
    if include_html
    then (
      let as_text =
        let vdom = Node.span [ vdom ] in
        (Node.to_dom vdom)##.innerHTML |> Js.to_string
      in
      Node.div [ Node.pre [ Node.text as_text ]; vdom ])
    else vdom
  in
  run (Bonsai.const vdom)
;;
