@react.component
let make = () => {
  let primary = React.useRef(Js.Nullable.null)
  let warning = React.useRef(Js.Nullable.null)
  let success = React.useRef(Js.Nullable.null)
  let danger = React.useRef(Js.Nullable.null)

  let (dialogOpen, setDialogOpen) = React.useState(() => false)

  let handleClick = (e: ReactEvent.Form.t) => Js.Console.log(ReactEvent.Form.target(e)["value"])

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
      <h2> {`Dropdown`->React.string} </h2>
      <Sl.Dropdown>
        <Sl.Button slot="trigger" caret={true}> {`Dropdown`->React.string} </Sl.Button>
        <Sl.Menu
          onSlSelect={e => {
            let item = e.detail.item
            Js.Console.log(item)
          }}>
          <Sl.MenuItem value="item-1" onClick={handleClick}> {`Item 1`->React.string} </Sl.MenuItem>
          <Sl.MenuItem value="item-2"> {`Item 2`->React.string} </Sl.MenuItem>
          <Sl.MenuItem value="item-3"> {`Item 3`->React.string} </Sl.MenuItem>
          <Sl.Divider />
          <Sl.MenuItem \"type"={#checkbox} checked={true} value="item-checkbox">
            {`Checkbox`->React.string}
          </Sl.MenuItem>
          <Sl.MenuItem disabled={true} value="item-disabled">
            {`Can't click me`->React.string}
          </Sl.MenuItem>
          <Sl.Divider />
          <Sl.MenuItem value="item-gift">
            {`Free Gift`->React.string}
            <Sl.Icon slot="prefix" name="gift" />
          </Sl.MenuItem>
          <Sl.MenuItem value="item-like">
            {`Like This!`->React.string}
            <Sl.Icon slot="suffix" name="heart" />
          </Sl.MenuItem>
        </Sl.Menu>
      </Sl.Dropdown>
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
      <h2> {`Button Groups and Tooltips`->React.string} </h2>
      <Sl.ButtonGroup label="No Pill">
        <Sl.Tooltip content="Up" trigger="click">
          <Sl.Button size={#medium}> {`Left`->React.string} </Sl.Button>
        </Sl.Tooltip>
        <Sl.Tooltip content="Down" placement={#bottom} trigger="click">
          <Sl.Button size={#medium}> {`Center`->React.string} </Sl.Button>
        </Sl.Tooltip>
        <Sl.Tooltip content="Right" placement={#right} trigger="click">
          <Sl.Button size={#medium}> {`Right`->React.string} </Sl.Button>
        </Sl.Tooltip>
      </Sl.ButtonGroup>
      <br />
      <br />
      <Sl.ButtonGroup label="Pill">
        <Sl.Tooltip content="Up">
          <Sl.Button size={#medium} pill={true}> {`Left`->React.string} </Sl.Button>
        </Sl.Tooltip>
        <Sl.Tooltip content="Down" placement={#bottom}>
          <Sl.Button size={#medium} pill={true}> {`Center`->React.string} </Sl.Button>
        </Sl.Tooltip>
        <Sl.Tooltip content="Right" placement={#right}>
          <Sl.Button size={#medium} pill={true}> {`Right`->React.string} </Sl.Button>
        </Sl.Tooltip>
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
    <h2> {`Number and Date Formatting`->React.string} </h2>
    <h3> {`Relative Time`->React.string} </h3>
    <Sl.RelativeTime date={(Js.Date.now() -. 200000.0)->Js.Date.fromFloat->Js.Date.toISOString} />
    <br />
    <Sl.RelativeTime date={(Js.Date.now() +. 9000000.0)->Js.Date.fromFloat->Js.Date.toISOString} />
    <br />
    <br />
    <Sl.RelativeTime
      date={(Js.Date.now() -. 800000.0)->Js.Date.fromFloat->Js.Date.toISOString} lang="ru-RU"
    />
    <br />
    <Sl.RelativeTime
      date={(Js.Date.now() +. 600000.0)->Js.Date.fromFloat->Js.Date.toISOString} lang="zh-CN"
    />
    <h3> {`Format Time`->React.string} </h3>
    <Sl.FormatDate date={Js.Date.make()->Js.Date.toISOString} />
    <br />
    <Sl.FormatDate
      date={Js.Date.make()->Js.Date.toISOString}
      weekday={#long}
      year={#numeric}
      day={#"2-digit"}
      month={#long}
    />
    <h3> {`Format Number`->React.string} </h3>
    <span>
      {`Currency (USD): `->React.string}
      <Sl.FormatNumber value=177.5 currency="USD" \"type"={#currency} />
    </span>
    <br />
    <span>
      {`Currency (EUR): `->React.string}
      <Sl.FormatNumber value=177.5 currency="EUR" \"type"={#currency} currencyDisplay={#name} />
    </span>
    <br />
    <span>
      {`Currency (JPY): `->React.string}
      <Sl.FormatNumber value=177.5 currency="JPY" \"type"={#currency} currencyDisplay={#symbol} />
    </span>
    <br />
    <span>
      {`Percent: `->React.string}
      <Sl.FormatNumber value=0.5 \"type"={#percent} />
    </span>
    <br />
    <span>
      {`Decimal (FR): `->React.string}
      <Sl.FormatNumber value=5.5 \"type"={#decimal} lang="fr" />
    </span>
    <br />
    <br />
    <Sl.Divider />
    <h2> {`Switch`->React.string} </h2>
    <Sl.Switch name="Clicker" />
    <br />
    <br />
    <Sl.Divider />
    <h2> {`Tree`->React.string} </h2>
    <Sl.Tree
      selection={#multiple}
      onSlSelectionChange={e => {
        let arr = e.detail.selection->Array.map(node => {
          switch node.attributes {
          | Some({value: {value}}) => Some(value)
          | _ => None
          }
        })
        Js.Console.log(arr)
      }}>
      <Sl.TreeItem value="hi">
        {`Item 1`->React.string}
        <Sl.TreeItem value="we">
          {`Item A`->React.string}
          <Sl.TreeItem value="are"> {`Item Z`->React.string} </Sl.TreeItem>
          <Sl.TreeItem value="testing"> {`Item Y`->React.string} </Sl.TreeItem>
          <Sl.TreeItem value="how"> {`Item x`->React.string} </Sl.TreeItem>
        </Sl.TreeItem>
        <Sl.TreeItem value="this"> {`Item B`->React.string} </Sl.TreeItem>
        <Sl.TreeItem value="goes"> {`Item C`->React.string} </Sl.TreeItem>
      </Sl.TreeItem>
      <Sl.TreeItem value="selecting"> {`Item 2`->React.string} </Sl.TreeItem>
      <Sl.TreeItem value="multiple"> {`Item 3`->React.string} </Sl.TreeItem>
    </Sl.Tree>
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
