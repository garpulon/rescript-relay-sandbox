module Alert = {
  type variant = [
    | #primary
    | #success
    | #neutral
    | #warning
    | #danger
  ]

  type alertInstance

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~variant: variant=?,
    ~\"open": bool=?,
    ~closable: bool=?,
    ~duration: int=?,
    ~onClick: unit => unit=?,
    ~onSlAfterHide: unit => unit=?,
    ~ref: React.ref<Js.Nullable.t<alertInstance>>=?,
  ) => React.element = "SlAlert"

  @send external toast: alertInstance => unit = "toast"
}

module Button = {
  type variant = [
    | #default
    | #primary
    | #success
    | #neutral
    | #warning
    | #danger
    | #text
  ]

  type size = [
    | #small
    | #medium
    | #large
  ]

  type type_ = [
    | #button
    | #submit
    | #reset
  ]

  type target = [
    | #_blank
    | #_parent
    | #_top
    | #_self
  ]

  type rel = [#noreferrer_noopener]

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~variant: variant=?,
    ~size: size=?,
    ~caret: bool=?,
    ~disabled: bool=?,
    ~pill: bool=?,
    ~circle: bool=?,
    ~\"type": type_=?,
    ~loading: bool=?,
    ~outline: bool=?,
    ~name: string=?,
    ~href: string=?,
    ~onClick: unit => unit=?,
    ~target: target=?,
    ~rel: rel=?,
  ) => React.element = "SlButton"
}
