@react.component
let make = (~to as href: string, ~children) =>
  <a
    href
    onClick={e => {
      let _ = e->JsxEvent.Mouse.preventDefault
      let _ = RescriptReactRouter.push(href)
    }}>
    {children}
  </a>
