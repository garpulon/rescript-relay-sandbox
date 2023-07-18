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
    ~onSlShow: eventHandler=?,
    ~onSlAfterShow: eventHandler=?,
    ~onSlHide: eventHandler=?,
    ~onSlAfterHide: eventHandler=?,
    ~updateComplete: updateComplete=?,
    ~ref: React.ref<Js.Nullable.t<alert>>=?,
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
  type btn

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
  type carousel
  type slide

  type eventDetail = {
    index: int,
    slide: slide,
  }

  type slideChangeEvent = {detail: eventDetail}

  @send external previous: (carousel, ~behavior: scrollBehavior=?) => unit = "previous"
  @send external next: (carousel, ~behavior: scrollBehavior=?) => unit = "next"
  @send
  external goToSlide: (carousel, ~index: int, ~behavior: scrollBehavior=?) => unit = "goToSlide"

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
  type check

  @send external click: check => unit = "click"
  @send external blur: check => unit = "blur"
  @send external focus: (check, ~options: focusOptions=?) => unit = "focus"
  @send external getForm: check => Js.Nullable.t<Dom.htmlFormElement> = "getForm"
  @send external firstUpdated: check => unit = "firstUpdated"
  @send external checkValidity: check => bool = "checkValidity"
  @send external reportValidity: check => bool = "reportValidity"
  @send external setCustomValidity: (check, ~message: string) => unit = "setCustomValidity"

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
  type dialog

  @send external show: dialog => unit = "show"
  @send external hide: dialog => unit = "hide"

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
  type dropdown

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

  @send external show: dropdown => unit = "show"
  @send external hide: dropdown => unit = "hide"
  @send external reposition: dropdown => unit = "reposition"

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
  type icnBtn

  @send external click: icnBtn => unit = "click"
  @send external blur: icnBtn => unit = "blur"
  @send external focus: (icnBtn, ~options: focusOptions=?) => unit = "focus"

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
  type input

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

  @send external blur: input => unit = "blur"
  @send external select: input => unit = "select"
  @send external focus: (input, ~options: focusOptions=?) => unit = "focus"
  @send
  external setSelectionRange: (
    input,
    ~selectionStart: int,
    ~selectionEnd: int,
    ~selectionDirection: [#forward | #backward | #none],
  ) => unit = "setSelectionRange"
  @send
  external setRangeText: (
    input,
    ~replacement: string,
    ~start: int,
    ~end: int,
    ~selectMode: [#select | #start | #end | #preserve],
  ) => unit = "setRangeText"
  @send external showPicker: input => unit = "showPicker"
  @send external stepUp: input => unit = "stepUp"
  @send external stepDown: input => unit = "stepDown"
  @send external getForm: input => Js.Nullable.t<Dom.htmlFormElement> = "getForm"
  @send external checkValidity: input => bool = "checkValidity"
  @send external reportValidity: input => bool = "reportValidity"
  @send external setCustomValidity: (input, ~message: string) => unit = "setCustomValidity"

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
