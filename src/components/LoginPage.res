module UserFragment = %relay(`
  fragment LoginPage_query on Query {
    currentUser {
      email
    }
  }
`)
module LoginMutation = %relay(`
  mutation LoginPage_LoginMutation($input: LoginInput!) {
    login(input: $input) {
      jwtToken
      messages {
        message
      }
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
                  // stale all the data in the store
                  store->RescriptRelay.RecordSourceSelectorProxy.invalidateStore
                },
                ~onCompleted=(v1, _) => {
                  switch v1.login {
                  | Some({jwtToken: Some(jwtToken)}) => {
                      let _ = Common.InsecureJWTStorage.set(jwtToken)
                      // refresh the store upon renav
                      RescriptReactRouter.push("/")
                    }

                  // note that this pattern match WILL not match multiply errored items, but it is succinct
                  | Some({jwtToken: None, messages: Some([Some({message})])})
                    if message->Js.String2.trim != "" => {
                      open Common.URLSearchParams
                      let qps = [("message", message)]
                      RescriptReactRouter.push(`/error/?${qps->fromArray->toString}`)
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
