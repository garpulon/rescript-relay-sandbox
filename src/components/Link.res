@react.component
let make = (~to: string, ~children) =>
  <a
    href={to}
    onClick={e => {
      let _ = e->JsxEvent.Mouse.preventDefault
      let _ = RescriptReactRouter.push(to)
    }}>
    {children}
  </a>
