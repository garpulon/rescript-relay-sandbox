module SlButton = {
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
  ) => React.element = "SlButton"
}
