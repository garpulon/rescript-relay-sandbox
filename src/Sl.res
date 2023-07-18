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

  type scrollBehavior = [
    | #auto
    | #smooth
  ]

  type focusOptions = {
    preventScroll?: string,
    focusVisible?: string,
  }

  type updateComplete = Js.Promise.t<unit> => unit

  type validityStateObj

  type validationMessage

  type reactEvent

  type eventHandler = reactEvent => unit
}

/* SlAlert */
module Alert = {
  include Base
  type t

  @send external toast: t => unit = "toast"
  @send external show: t => unit = "show"
  @send external hide: t => unit = "hide"

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~variant: variant=?,
    ~\"open": bool=?,
    ~closable: bool=?,
    ~duration: int=?,
    ~onClick: unit => unit=?,
    ~onSlShow: eventHandler=?,
    ~onSlAfterShow: eventHandler=?,
    ~onSlHide: eventHandler=?,
    ~onSlAfterHide: eventHandler=?,
    ~updateComplete: updateComplete=?,
    ~ref: React.ref<Js.Nullable.t<t>>=?,
  ) => React.element = "SlAlert"
}

/* SlAvatar */
module Avatar = {
  include Base
  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~image: string,
    ~label: string,
    ~initials: string=?,
    ~loading: [#eager | #"lazy"]=?,
    ~onClick: unit => unit=?, // IDK is this necessary?
    ~shape: [#circle | #square | #rounded]=?,
    ~updateComplete: updateComplete=?,
  ) => React.element = "SlAvatar"
}

/* SlBadge */
module Badge = {
  include Base

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~variant: variant=?,
    ~pill: bool=?,
    ~pulse: bool=?,
    ~onClick: unit => unit=?,
    ~updateComplete: updateComplete=?,
  ) => React.element = "SlBadge"
}

/* SlButton */
module Button = {
  include Base
  type t

  @send external click: t => unit = "click"
  @send external blur: t => unit = "blur"
  @send external focus: (t, ~options: focusOptions=?) => unit = "focus"
  @send external getForm: t => option<Dom.htmlFormElement> = "getForm"
  @send external firstUpdated: t => unit = "firstUpdated"
  @send external checkValidity: t => bool = "checkValidity"
  @send external reportValidity: t => bool = "reportValidity"
  @send external setCustomValidity: (t, ~message: string) => unit = "setCustomValidity"

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
    ~onSlBlur: eventHandler=?,
    ~onSlFocus: eventHandler=?,
    ~onSlInvalid: eventHandler=?,
    ~updateComplete: reactEvent=?,
    ~slot: string=?,
  ) => React.element = "SlButton"
}

/* SlButtonGroup */
module ButtonGroup = {
  include Base
  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~label: string=?,
    ~updateComplete: updateComplete=?,
  ) => React.element = "SlButtonGroup"
}

/* SlCarousel */
module Carousel = {
  include Base
  type t
  type s

  type eventDetail = {
    index: int,
    slide: s,
  }

  type slideChangeEvent = {detail: eventDetail}

  @send external previous: (t, ~behavior: scrollBehavior=?) => unit = "previous"
  @send external next: (t, ~behavior: scrollBehavior=?) => unit = "next"
  @send
  external goToSlide: (t, ~index: int, ~behavior: scrollBehavior=?) => unit = "goToSlide"

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~loop: bool=?,
    ~navigation: bool=?,
    ~pagination: bool=?,
    ~autoplay: bool=?,
    ~autoplayInterval: int=?,
    ~slidesPerPage: int=?,
    ~slidesPerMove: int=?,
    ~orientation: [#horizontal | #vertical]=?,
    ~mouseDragging: bool=?,
    ~onSlSlideChange: eventHandler=?,
    ~updateComplete: updateComplete=?,
  ) => React.element = "SlCarousel"
}

/* SlCarouselItem */
module CarouselItem = {
  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (~children: React.element=?) => React.element = "SlCarouselItem"
}

/* SlCheckbox */
module Checkbox = {
  include Base
  type t

  @send external click: t => unit = "click"
  @send external blur: t => unit = "blur"
  @send external focus: (t, ~options: focusOptions=?) => unit = "focus"
  @send external getForm: t => Js.Nullable.t<Dom.htmlFormElement> = "getForm"
  @send external firstUpdated: t => unit = "firstUpdated"
  @send external checkValidity: t => bool = "checkValidity"
  @send external reportValidity: t => bool = "reportValidity"
  @send external setCustomValidity: (t, ~message: string) => unit = "setCustomValidity"

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~name: string=?,
    ~value: string=?,
    ~size: size=?,
    ~disabled: bool=?,
    ~checked: bool=?,
    ~indeterminate: bool=?,
    ~defaultChecked: bool=?,
    ~form: string=?,
    ~required: bool=?,
    ~validity: unit => validityStateObj=?,
    ~validationMessage: unit => validationMessage=?,
    ~updateComplete: updateComplete=?,
    ~onSlBlur: eventHandler=?,
    ~onSlChange: eventHandler=?,
    ~onSlFocus: eventHandler=?,
    ~onSlInput: eventHandler=?,
    ~onSlInvalid: eventHandler=?,
  ) => React.element = "SlCheckbox"
}

/* SlDialog */
module Dialog = {
  include Base
  type t

  @send external show: t => unit = "show"
  @send external hide: t => unit = "hide"

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~\"open": bool,
    ~label: string=?,
    ~noHeader: bool=?,
    ~updateComplete: updateComplete=?,
    ~onSlShow: eventHandler=?,
    ~onSlAfterShow: eventHandler=?,
    ~onSlHide: eventHandler=?,
    ~onSlAfterHide: eventHandler=?,
    ~onSlInitialFocus: eventHandler=?,
    ~onSlRequestClose: eventHandler=?,
  ) => React.element = "SlDialog"
}

/* SlDivider */
module Divider = {
  include Base
  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (~vertical: bool=?, ~updateComplete: updateComplete=?) => React.element =
    "SlDivider"
}

/* SlDropdown */
module Dropdown = {
  include Base
  type t

  type placement = [
    | #top
    | #"top-start"
    | #"top-end"
    | #bottom
    | #"bottom-start"
    | #"bottom-end"
    | #right
    | #"right-start"
    | #"right-end"
    | #left
    | #"left-start"
    | #"left-end"
  ]

  @send external show: t => unit = "show"
  @send external hide: t => unit = "hide"
  @send external reposition: t => unit = "reposition"

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~\"open": bool=?,
    ~placement: placement=?,
    ~disabled: bool=?,
    ~stayOpenOnSelect: bool=?,
    ~containingElement: Dom.htmlElement=?,
    ~distance: int=?,
    ~skidding: int=?,
    ~hoist: bool=?,
    ~updateComplete: updateComplete=?,
    ~onSlShow: eventHandler=?,
    ~onSlAfterShow: eventHandler=?,
    ~onSlHide: eventHandler=?,
    ~onSlAfterHide: eventHandler=?,
  ) => React.element = "SlDropdown"
}

/* SlFormatDate */
module FormatDate = {
  include Base

  type d = Js.Date.t

  type date =
    | Date(d)
    | String(string)

  type shortLong = [
    | #short
    | #long
  ]

  type stringFormats = [
    | #narrow
    | #shortLong
  ]

  type numericFormats = [
    | #numeric
    | #"2-digit"
  ]

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~date: date=?,
    ~weekday: stringFormats=?,
    ~era: stringFormats=?,
    ~year: numericFormats=?,
    ~month: [#stringFormats | #numericFormats]=?,
    ~day: numericFormats=?,
    ~hour: numericFormats=?,
    ~minute: numericFormats=?,
    ~second: numericFormats=?,
    ~timeZoneName: shortLong=?,
    ~timeZone: string=?,
    ~hourFormat: [#auto | #12 | #24]=?,
    ~updateComplete: updateComplete=?,
  ) => React.element = "SlFormatDate"
}

/* SlFormatNumber */
module FormatNumber = {
  include Base

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~value: int=?,
    ~\"type": [#currency | #decimal | #percent]=?,
    ~noGrouping: bool=?,
    ~currency: string=?,
    ~currencyDisplay: [#symbol | #narrowSymbol | #code | #name]=?,
    ~minimumIntegerDigits: int=?,
    ~maximumFractionDigits: int=?,
    ~minimumSignificantDigits: int=?,
    ~maximumSignificantDigits: int=?,
    ~updateComplete: updateComplete=?,
  ) => React.element = "SlFormatDate"
}

/* SlIcon */
module Icon = {
  include Base

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~name: string=?,
    ~src: string=?,
    ~label: string=?,
    ~slot: string=?,
    ~library: string=?,
    ~updateComplete: updateComplete=?,
    ~onSlLoad: eventHandler=?,
    ~onSlError: eventHandler=?,
  ) => React.element = "SlIcon"
}

/* SlIconButton */
module IconButton = {
  include Base
  type t

  @send external click: t => unit = "click"
  @send external blur: t => unit = "blur"
  @send external focus: (t, ~options: focusOptions=?) => unit = "focus"

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~name: string=?,
    ~src: string=?,
    ~label: string=?,
    ~slot: string=?,
    ~target: [#_blank | #_parent | #_top | #_self]=?,
    ~href: string=?,
    ~download: string=?,
    ~library: string=?,
    ~disabled: bool=?,
    ~updateComplete: updateComplete=?,
    ~onSlBlur: eventHandler=?,
    ~onSlFocus: eventHandler=?,
  ) => React.element = "SlIconButton"
}

/* SlInput */
module Input = {
  include Base
  type t

  type inputType = [
    | #date
    | #"datetime-local"
    | #email
    | #number
    | #password
    | #search
    | #tel
    | #text
    | #time
    | #url
  ]

  type stepType = [#int(int) | #any]

  @send external blur: t => unit = "blur"
  @send external select: t => unit = "select"
  @send external focus: (t, ~options: focusOptions=?) => unit = "focus"
  @send
  external setSelectionRange: (
    t,
    ~selectionStart: int,
    ~selectionEnd: int,
    ~selectionDirection: [#forward | #backward | #none],
  ) => unit = "setSelectionRange"
  @send
  external setRangeText: (
    t,
    ~replacement: string,
    ~start: int,
    ~end: int,
    ~selectMode: [#select | #start | #end | #preserve],
  ) => unit = "setRangeText"
  @send external showPicker: t => unit = "showPicker"
  @send external stepUp: t => unit = "stepUp"
  @send external stepDown: t => unit = "stepDown"
  @send external getForm: t => Js.Nullable.t<Dom.htmlFormElement> = "getForm"
  @send external checkValidity: t => bool = "checkValidity"
  @send external reportValidity: t => bool = "reportValidity"
  @send external setCustomValidity: (t, ~message: string) => unit = "setCustomValidity"

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~\"type": inputType=?,
    ~name: string=?,
    ~value: string=?,
    ~defaultValue: string=?,
    ~size: size=?,
    ~filled: bool=?,
    ~pill: bool=?,
    ~label: string=?,
    ~slot: string=?,
    ~helpText: string=?,
    ~clearable: bool=?,
    ~disabled: bool=?,
    ~readonly: bool=?,
    ~passwordToggle: bool=?,
    ~noSpinButtons: bool=?,
    ~form: string=?,
    ~required: bool=?,
    ~pattern: string=?,
    ~minlength: int=?,
    ~maxlength: int=?,
    ~min: int=?,
    ~max: int=?,
    ~step: stepType=?,
    ~autocapitalize: [#off | #on | #none | #sentences | #words | #characters]=?,
    ~autocorrect: [#on | #off]=?,
    ~autocomplete: string=?,
    ~autofocus: bool=?,
    ~spellcheck: bool=?,
    ~inputmode: [#none | #text | #decimal | #numeric | #tel | #search | #email | #url]=?,
    ~valueAsDate: Js.Nullable.t<Js.Date.t>=?,
    ~valueAsNumber: float=?,
    ~validity: unit => validityStateObj=?,
    ~validationMessage: unit => validationMessage=?,
    ~target: [#_blank | #_parent | #_top | #_self]=?,
    ~href: string=?,
    ~download: string=?,
    ~library: string=?,
    ~updateComplete: updateComplete=?,
    ~onSlBlur: eventHandler=?,
    ~onSlChange: eventHandler=?,
    ~onSlClear: eventHandler=?,
    ~onSlInput: eventHandler=?,
    ~onSlFocus: eventHandler=?,
    ~onSlInvalid: eventHandler=?,
  ) => React.element = "SlInput"
}

/* SlMenu */
module Menu = {
  include Base
  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (~children: React.element=?, ~onSlSelect: eventHandler=?) => React.element =
    "SlMenu"
}

/* SlMenuItem */
module MenuItem = {
  include Base
  type t

  @send external getTextLabel: t => string = "getTextLabel"

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~\"type": [#normal | #checkbox]=?,
    ~checked: bool=?,
    ~value: string=?,
    ~disabled: bool=?,
    ~updateComplete: updateComplete=?,
  ) => React.element = "SlMenuItem"
}

/* SlMenuLabel */
module MenuLabel = {
  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (~children: React.element=?) => React.element = "SlMenuLabel"
}

/* SlOption */
module Option = {
  include Base
  type t

  @send external getTextLabel: t => string = "getTextLabel"

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~value: string=?,
    ~disabled: bool=?,
    ~updateComplete: updateComplete=?,
  ) => React.element = "SlOption"
}

/* SlRadio */
module Radio = {
  include Base
  type t

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~value: string=?,
    ~size: size=?,
    ~disabled: bool=?,
    ~onSlBlur: eventHandler=?,
    ~onSlFocus: eventHandler=?,
    ~updateComplete: updateComplete=?,
  ) => React.element = "SlRadio"
}

/* SlRadioButton */
module RadioButton = {
  include Base
  type t

  @send external focus: (t, ~options: focusOptions=?) => unit = "focus"
  @send external blur: t => unit = "focus"

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~value: string=?,
    ~size: size=?,
    ~disabled: bool=?,
    ~pill: bool=?,
    ~onSlBlur: eventHandler=?,
    ~onSlFocus: eventHandler=?,
    ~updateComplete: updateComplete=?,
  ) => React.element = "SlRadio"
}

/* SlRadioGroup */
module RadioGroup = {
  include Base
  type t

  @send external getForm: t => Js.Nullable.t<Dom.htmlFormElement> = "getForm"
  @send external checkValidity: t => bool = "checkValidity"
  @send external reportValidity: t => bool = "reportValidity"
  @send external setCustomValidity: (t, ~message: string) => unit = "setCustomValidity"

  @module("@shoelace-style/shoelace/dist/react/") @react.component
  external make: (
    ~children: React.element=?,
    ~label: string=?,
    ~helpText: string=?,
    ~name: string=?,
    ~value: string=?,
    ~size: size=?,
    ~form: string=?,
    ~required: bool=?,
    ~validity: unit => validityStateObj=?,
    ~validationMessage: unit => validationMessage=?,
    ~onSlChange: eventHandler=?,
    ~onSlInput: eventHandler=?,
    ~onSlInvalid: eventHandler=?,
    ~updateComplete: updateComplete=?,
  ) => React.element = "SlRadioGroup"
}

/* Registration Functions */
type img
type registerOptions = {
  resolver: string => string,
  mutator?: img => unit,
}

@module("@shoelace-style/shoelace/dist/utilities/base-path.js")
external setBasePath: string => unit = "setBasePath"

@module("@shoelace-style/shoelace/dist/utilities/base-path.js")
external getBasePath: unit => string = "getBasePath"

@module("@shoelace-style/shoelace/dist/utilities/icon-library.js")
external registerIconLibrary: (string, registerOptions) => unit = "registerIconLibrary"
