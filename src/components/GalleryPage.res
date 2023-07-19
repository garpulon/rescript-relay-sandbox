@react.component
let make = () => {
  let primary = React.useRef(Js.Nullable.null)
  let warning = React.useRef(Js.Nullable.null)
  let success = React.useRef(Js.Nullable.null)
  let danger = React.useRef(Js.Nullable.null)

  open Sl.Alert

  let onClickPrimary = _ => {
    primary.current->Js.Nullable.toOption->Belt.Option.forEach(toast)
  }

  let onClickWarning = _ => {
    warning.current->Js.Nullable.toOption->Belt.Option.forEach(toast)
  }

  let onClickSuccess = _ => {
    success.current->Js.Nullable.toOption->Belt.Option.forEach(toast)
  }

  let onClickDanger = _ => {
    danger.current->Js.Nullable.toOption->Belt.Option.forEach(toast)
  }
  <Main>
    <h1> {`Component Gallery`->React.string} </h1>
    <div>
      <h2> {`Buttons and Alerts`->React.string} </h2>
      <Sl.Button variant={#primary} size={#large} onClick={onClickPrimary}>
        {`Click me`->React.string}
      </Sl.Button>
      <Sl.Alert ref={primary} variant={#primary} duration=3000 closable={true}>
        <Sl.Icon slot="icon" library="default" name="info-circle" />
        {`Helpful reminder!`->React.string}
      </Sl.Alert>
      <br />
      <br />
      <Sl.Button variant={#warning} size={#large} onClick={onClickWarning}>
        {`Click me`->React.string}
      </Sl.Button>
      <Sl.Alert ref={warning} variant={#warning} duration=3000 closable={true}>
        <Sl.Icon slot="icon" library="default" name="exclamation-triangle" />
        {`Hmm... Seems suspicious...`->React.string}
      </Sl.Alert>
      <br />
      <br />
      <Sl.Button variant={#success} size={#large} onClick={onClickSuccess}>
        {`Click me`->React.string}
      </Sl.Button>
      <Sl.Alert ref={success} variant={#success} duration=3000 closable={true}>
        <Sl.Icon slot="icon" library="default" name="check2-circle" />
        {`Success!`->React.string}
      </Sl.Alert>
      <br />
      <br />
      <Sl.Button variant={#danger} size={#large} onClick={onClickDanger}>
        {`Click me`->React.string}
      </Sl.Button>
      <Sl.Alert ref={danger} variant={#danger} duration=3000 closable={true}>
        <Sl.Icon slot="icon" library="default" name="exclamation-octagon" />
        {`Uh oh!`->React.string}
      </Sl.Alert>
      <h2> {`Multiple Select`->React.string} </h2>
      <Sl.Select
        label="Select a Few"
        value={String("option-1 option-2 option-3")}
        multiple={true}
        clearable={true}>
        <Sl.Option value="option-1"> {"Option 1"->React.string} </Sl.Option>
        <Sl.Option value="option-2"> {"Option 2"->React.string} </Sl.Option>
        <Sl.Option value="option-3"> {"Option 3"->React.string} </Sl.Option>
        <Sl.Option value="option-4"> {"Option 4"->React.string} </Sl.Option>
        <Sl.Option value="option-5"> {"Option 5"->React.string} </Sl.Option>
        <Sl.Option value="option-6"> {"Option 6"->React.string} </Sl.Option>
      </Sl.Select>
    </div>
    <p>
      <Link to="/"> {`Return home`->React.string} </Link>
    </p>
  </Main>
}
