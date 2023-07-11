module SendSimpleEmailMutation = %relay(`
  mutation CreateNewEmailForm_SendSimpleEmailMutation(
    $input: SendSimpleEmailInput!
  ) {
    sendSimpleEmail(input: $input) {
      boolean
    }
  }
`)

@react.component
let make = (~fragmentRefs, ~userEmail) => {
  let (mutate, isMutating) = SendSimpleEmailMutation.use()
  let email = Common.State.useState(() => "")
  let subject = Common.State.useState(() => "")
  let text = Common.State.useState(() => "")

  switch userEmail {
  | Some(userEmail) =>
    <div>
      <h1> {`Hi ${userEmail}!`->React.string} </h1>
      <form
        onSubmit={e => {
          e->JsxEvent.Form.preventDefault
          let _ = mutate(
            ~variables={
              input: RelaySchemaAssets_graphql.make_SendSimpleEmailInput(
                ~email=email.value,
                ~subject=subject.value,
                ~body=text.value,
                ~html=`<p>${text.value}</p>`,
                (),
              ),
            },
            ~onError=err => {
              Js.Console.log(err)
            },
            (),
          )
        }}>
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
        <br />
        <button disabled={isMutating} type_="submit"> {"Send email"->React.string} </button>
      </form>
    </div>
  | None => <div> {"Not logged in"->React.string} </div>
  }
}
