@react.component
let make = (~to as href: string, ~children) => {
  let isExternal = switch href->Common.URL.parse {
  | Some({host}) if host != "localhost" => true
  | _ => false
  }
  <a
    href
    onClick={e => {
      if !isExternal {
        let _ = e->JsxEvent.Mouse.preventDefault
        let _ = RescriptReactRouter.push(href)
      }
    }}
    target={isExternal ? "_blank" : ""}>
    {children}
  </a>
}
