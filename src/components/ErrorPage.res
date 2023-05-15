@react.component
let make = (~urlSearch) => {
  let err = {
    open Common.URLSearchParams
    urlSearch->parse->get("message")->Option.getWithDefault("unspecific error")
  }
  <Main>
    <h1> {`Error`->React.string} </h1>
    <p> {`The following error was emitted. Hit back or otherwise deal with it.`->React.string} </p>
    <pre
      style={ReactDOM.Style.make(
        ~backgroundColor="lightgoldenrodyellow",
        ~fontSize="1.5em",
        ~paddingLeft="12px",
        ~paddingTop="12px",
        ~paddingBottom="18px",
        (),
      )}>
      {err->React.string}
    </pre>
    <button onClick={_ => %raw(`history.back()`)}> {`Go back`->React.string} </button>
  </Main>
}
