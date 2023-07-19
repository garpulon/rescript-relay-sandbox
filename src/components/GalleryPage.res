@react.component
let make = () => {
  let primary = React.useRef(Js.Nullable.null)
  let warning = React.useRef(Js.Nullable.null)
  let success = React.useRef(Js.Nullable.null)
  let danger = React.useRef(Js.Nullable.null)

  let (dialogOpen, setDialogOpen) = React.useState(() => false)

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
      <Sl.Button variant={#primary} size={#small} onClick={onClickPrimary}>
        {`Click me`->React.string}
      </Sl.Button>
      <Sl.Alert ref={primary} variant={#primary} duration=3000 closable={true}>
        <Sl.Icon slot="icon" library="default" name="info-circle" />
        {`Helpful reminder!`->React.string}
      </Sl.Alert>
      <br />
      <br />
      <Sl.Button variant={#warning} size={#medium} onClick={onClickWarning}>
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
      <br />
      <br />
      <Sl.Divider />
      <h2> {`Multiple Select`->React.string} </h2>
      <Sl.Select
        label="Select a Few"
        value={String("option-1 option-2 option-3")}
        onSlChange={e => {
          let v = ReactEvent.Form.target(e)["value"]
          Js.Console.log(v)
        }}
        multiple={true}
        clearable={true}>
        <Sl.Option value="option-1"> {"Option 1"->React.string} </Sl.Option>
        <Sl.Option value="option-2"> {"Option 2"->React.string} </Sl.Option>
        <Sl.Option value="option-3"> {"Option 3"->React.string} </Sl.Option>
        <Sl.Option value="option-4"> {"Option 4"->React.string} </Sl.Option>
        <Sl.Option value="option-5"> {"Option 5"->React.string} </Sl.Option>
        <Sl.Option value="option-6"> {"Option 6"->React.string} </Sl.Option>
      </Sl.Select>
      <br />
      <br />
      <Sl.Divider />
      <h2> {`Badges`->React.string} </h2>
      <span>
        <Sl.Badge> {`Default`->React.string} </Sl.Badge>
        {` `->React.string}
        <Sl.Badge variant={#success} pill={true}> {`Success`->React.string} </Sl.Badge>
        {` `->React.string}
        <Sl.Badge variant={#danger} pulse={true}> {`Danger`->React.string} </Sl.Badge>
      </span>
      <br />
      <br />
      <Sl.Divider />
      <h2> {`Button Groups`->React.string} </h2>
      <Sl.ButtonGroup label="No Pill">
        <Sl.Button size={#medium}> {`Left`->React.string} </Sl.Button>
        <Sl.Button size={#medium}> {`Center`->React.string} </Sl.Button>
        <Sl.Button size={#medium}> {`Right`->React.string} </Sl.Button>
      </Sl.ButtonGroup>
      <br />
      <br />
      <Sl.ButtonGroup label="Pill">
        <Sl.Button size={#medium} pill={true}> {`Left`->React.string} </Sl.Button>
        <Sl.Button size={#medium} pill={true}> {`Center`->React.string} </Sl.Button>
        <Sl.Button size={#medium} pill={true}> {`Right`->React.string} </Sl.Button>
      </Sl.ButtonGroup>
      <br />
      <br />
      <Sl.ButtonGroup label="Split Button Example">
        <Sl.Button variant={#success} outline={true}> {`Save`->React.string} </Sl.Button>
        <Sl.Dropdown placement={#"bottom-end"}>
          <Sl.Button slot="trigger" variant={#success} caret={true} outline={true} />
          <Sl.Menu>
            <Sl.MenuItem> {`Save`->React.string} </Sl.MenuItem>
            <Sl.MenuItem> {`Save as`->React.string} </Sl.MenuItem>
            <Sl.MenuItem> {`Save all`->React.string} </Sl.MenuItem>
          </Sl.Menu>
        </Sl.Dropdown>
      </Sl.ButtonGroup>
    </div>
    <br />
    <br />
    <Sl.Divider />
    <h2> {`Dialog`->React.string} </h2>
    <Sl.Dialog
      label="Dialog Engaged" \"open"={dialogOpen} onSlAfterHide={_ => setDialogOpen(_ => false)}>
      {`We're discoursing here in this dialog. Discourse discourse discourse.`->React.string}
      <Sl.Button slot="footer" variant={#primary} onClick={_ => setDialogOpen(_ => false)}>
        {`Close`->React.string}
      </Sl.Button>
    </Sl.Dialog>
    <Sl.Button onClick={_ => setDialogOpen(_ => true)}>
      {`Engage in Dialog`->React.string}
    </Sl.Button>
    <br />
    <br />
    <Sl.Divider />
    <p style={ReactDOM.Style.make(~textAlign=`right`, ())}>
      <Link to="/">
        <Sl.Button variant={#primary}>
          {`Return home`->React.string}
          <Sl.Icon slot="suffix" name="arrow-up-right" />
        </Sl.Button>
      </Link>
    </p>
  </Main>
}
