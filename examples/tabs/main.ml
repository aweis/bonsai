open! Core
open! Bonsai_web
open Bonsai.Let_syntax
module Tabs = Bonsai_web_ui_tabs

module T = struct
  type t =
    | A
    | B
    | C
  [@@deriving sexp, equal, compare, enumerate]
end

let component =
  let%sub tab_state = Tabs.tab_state (module T) ~initial:T.A ~equal:[%equal: T.t] in
  let%sub contents =
    Tabs.tab_ui
      (module T)
      ~equal:[%equal: T.t]
      tab_state
      ~all_tabs:(Value.return T.all)
      ~f:(fun ~change_tab tab ->
        Bonsai.enum
          (module T)
          ~match_:tab
          ~with_:(function
            | A ->
              let%arr change_tab = change_tab in
              Vdom.Node.button
                ~attrs:[ Vdom.Attr.on_click (fun _ -> change_tab T.C) ]
                [ Vdom.Node.text "jump to c" ]
            | B -> Bonsai.const (Vdom.Node.text "why are you even here")
            | C -> Bonsai.const (Vdom.Node.text "hello!")))
  in
  let%arr contents = contents in
  Tabs.Result.combine_trivially contents
;;

let () = Bonsai_web.Start.start component
