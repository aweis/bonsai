open! Core
open! Bonsai_web
module _ = Tracing_zero

let[@trace "hi"] component = Bonsai.const (Vdom.Node.text "hello world")
let () = Bonsai_web.Start.start component
