@react.component
let make = (~fragmentRefs, ~userEmail) => {
  let email = Common.State.useState(() => "")
  let subject = Common.State.useState(() => "")
  let text = Common.State.useState(() => "")

  switch userEmail {
  | Some(userEmail) =>
    <div>
      <h1> {`Hi ${userEmail}!`->React.string} </h1>
      <form>
        <label> {"Email: "->React.string} </label>
        <input type_="text" value={email.value} onChange={email.onChange} />
        <br />
        <label> {"Subject: "->React.string} </label>
        <input type_="text" value={subject.value} onChange={subject.onChange} />
        <br />
        <label> {"Text: "->React.string} </label>
        <textarea
          rows=4
          cols=50
          value={text.value}
          style={ReactDOM.Style.make(~resize=`none`, ())}
          onChange={text.onChange}
        />
      </form>
    </div>
  | None => <div> {"Not logged in"->React.string} </div>
  }
}
