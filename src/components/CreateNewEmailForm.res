module SendSimpleEmailMutation = %relay(`
  mutation CreateNewEmailForm_SendSimpleEmailMutation(
    $input: SendSimpleEmailInput!
  ) {
    sendSimpleEmail(input: $input) {
      boolean
      messages {
        message
        path
      }
    }
  }
`)

@react.component
let make = (~userEmail) => {
  let (mutate, isMutating) = SendSimpleEmailMutation.use()
  let email = Common.State.useState(() => "")
  let subject = Common.State.useState(() => "")
  let text = Common.State.useState(() => "")

  let error = Common.State.useState(() => "")
  let success = Common.State.useState(() => false)

  switch userEmail {
  | Some(userEmail) =>
    <div>
      <h1> {`Hi ${userEmail}!`->React.string} </h1>
      <form
        onSubmit={e => {
          e->JsxEvent.Form.preventDefault
          let html = `<p>${text.value}</p>`
          error.set(_ => "")
          let _ = mutate(
            ~variables={
              input: RelaySchemaAssets_graphql.make_SendSimpleEmailInput(
                ~email=email.value,
                ~subject=subject.value,
                ~body=text.value,
                ~html,
                (),
              ),
            },
            ~onCompleted=(resp, err) => {
              if err == None {
                switch resp.sendSimpleEmail {
                | Some({boolean: Some(true)}) => {
                    Js.Console.log("Email sent")
                    success.set(_ => true)
                    email.set(_ => "")
                    subject.set(_ => "")
                    text.set(_ => "")
                    let _ = Js.Global.setTimeout(() => success.set(_ => false), 3000)
                  }
                | Some({boolean: Some(false), messages: Some([Some({message})])}) =>
                  error.set(_ => message)
                | _ => ()
                }
              } else {
                Js.Console.log(err)
              }
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
      {switch error.value {
      | "" => <div />
      | error => <div style={ReactDOM.Style.make(~color=`red`, ())}> {error->React.string} </div>
      }}
      {switch success.value {
      | false => <div />
      | true =>
        <div style={ReactDOM.Style.make(~color=`green`, ())}> {`Success!`->React.string} </div>
      }}
    </div>
  | None => <div> {"Not logged in"->React.string} </div>
  }
}
