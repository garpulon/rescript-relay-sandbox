/* Base module for Shoelace ReScript bindings */
module Base = {
  type variant = [
    | #primary
    | #success
    | #neutral
    | #warning
    | #danger
  ]

  type defTextVariant = [
    | #default
    | variant
    | #text
  ]

  type size = [
    | #small
    | #medium
    | #large
  ]
}

/* SlAlert */
module Alert = {
  include Base
  type alert
  type cb

  @send external toast: alert => unit = "toast"
  @send external show: alert => unit = "show"
  @send external hide: alert => unit = "hide"

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~variant: variant=?,
    ~\"open": bool=?,
    ~closable: bool=?,
    ~duration: int=?,
    ~onClick: cb => unit=?,
    ~onSlShow: unit => unit=?,
    ~onSlAfterShow: unit => unit=?,
    ~onSlHide: unit => unit=?,
    ~onSlAfterHide: unit => unit=?,
    ~ref: React.ref<Js.Nullable.t<alert>>=?,
  ) => React.element = "SlAvatar"
}

/* SlAvatar */
module Avatar = {
  type cb

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~image: string,
    ~label: string,
    ~initials: string=?,
    ~loading: [#eager | #"lazy"]=?,
    ~onClick: cb => unit=?, // IDK is this necessary?
    ~shape: [#circle | #square | #rounded]=?,
  ) => React.element = "SlAlert"
}

/* SlBadge */
module Badge = {
  include Base
  type cb

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~variant: variant=?,
    ~pill: bool=?,
    ~pulse: bool=?,
    ~onClick: cb => unit=?,
  ) => // IDK is this necessary?
  React.element = "SlBadge"
}

/* SlButton */
module Button = {
  include Base
  type btn

  type focusOptions = {
    preventScroll?: string,
    focusVisible?: string,
  }

  @send external click: btn => unit = "click"
  @send external blur: btn => unit = "blur"
  @send external focus: (btn, ~options: focusOptions=?) => unit = "focus"
  @send external getForm: btn => option<Dom.htmlFormElement> = "getForm"
  @send external firstUpdated: btn => unit = "firstUpdated"
  @send external checkValidity: btn => bool = "checkValidity"
  @send external reportValidity: btn => bool = "reportValidity"
  @send external setCustomValidity: (btn, ~message: string) => unit = "setCustomValidity"

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~variant: defTextVariant=?,
    ~size: size=?,
    ~caret: bool=?,
    ~disabled: bool=?,
    ~pill: bool=?,
    ~circle: bool=?,
    ~\"type": [#button | #submit | #reset]=?,
    ~loading: bool=?,
    ~outline: bool=?,
    ~name: string=?,
    ~href: string=?,
    ~onClick: unit => unit=?,
    ~target: [#_blank | #_parent | #_top | #_self]=?,
    ~rel: [#noreferrer_noopener]=?,
    ~download: string=?,
    ~form: string=?,
    ~formAction: string=?,
    ~formEnctype: [#"application/x-www-form-urlencoded" | #"multipart/form-data" | #"text/plain"]=?,
    ~formMethod: [#post | #get]=?,
    ~formNoValidate: bool=?,
    ~formTarget: [#_blank | #_parent | #_top | #_self]=?, // or string...
    ~onSlBlur: unit => unit=?,
    ~onSlFocus: unit => unit=?,
    ~onSlInvalid: unit => unit=?,
  ) => React.element = "SlButton"
}

@module("@shoelace-style/shoelace/dist/utilities/base-path.js")
external setBasePath: string => unit = "setBasePath"

@module("@shoelace-style/shoelace/dist/utilities/base-path.js")
external getBasePath: unit => string = "getBasePath"
