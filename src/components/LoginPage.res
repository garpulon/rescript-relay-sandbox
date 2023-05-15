module UserFragment = %relay(`
  fragment LoginPage_query on Query {
    currentUser {
      id
    }
  }
`)
module LoginMutation = %relay(`
  mutation LoginPage_LoginMutation($input: LoginInput!) {
    login(input: $input) {
      jwtToken
    }
  }
`)

@react.component
let make = (~fragmentRefs) => {
  let fragment = UserFragment.use(fragmentRefs)
  let (mutate, isMutating) = LoginMutation.use()
  //  let data = Query.use(~variables=(), ())

  let (email, setEmail) = React.useState(() => "")
  let (password, setPassword) = React.useState(() => "")
  let onChange = (set, e) => ReactEvent.Form.currentTarget(e)["value"] |> set
  let isBlank = s => s->Js.String2.trim == ""

  isMutating
    ? <Spinner />
    : switch fragment.currentUser {
      | None =>
        <Main>
          <h1> {`Log in`->React.string} </h1>
          <h3> {`Log in with email`->React.string} </h3>
          <form
            onSubmit={e => {
              e->JsxEvent.Form.preventDefault
              let _ = mutate(
                ~variables={
                  input: RelaySchemaAssets_graphql.make_LoginInput(~email, ~pass=password, ()),
                },
              )(
                ~updater=(store, _) => {
                  store->RescriptRelay.RecordSourceSelectorProxy.invalidateStore
                },
                ~onCompleted=(v1, _) => {
                  switch v1.login {
                  | Some({jwtToken: Some(jwtToken)}) => {
                      let _ = Common.InsecureJWTStorage.set(jwtToken)
                      // this is not a best practice, let's say... but
                      // figuring out exactly which data is staled and should be replaced is a task for later
                      %raw(`location.reload()`)
                    }
                  | _ => ()
                  }
                },
                (),
              )
            }}>
            <table>
              <tbody>
                <tr>
                  <th> {`Username / email:`->React.string} </th>
                  <td>
                    <input type_="text" value={email} onChange={setEmail->onChange} />
                  </td>
                </tr>
                <tr>
                  <th> {`Password:`->React.string} </th>
                  <td>
                    <input type_="password" value={password} onChange={setPassword->onChange} />
                  </td>
                </tr>
              </tbody>
            </table>
            //{this.state.error ? <p> {this.state.error} </p> : null}
            <button type_="submit" disabled={email->isBlank || password->isBlank}>
              {`Log in`->React.string}
            </button>
          </form>
        </Main>
      | Some(_) => `Logged in`->React.string
      }
}
