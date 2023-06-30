module QueryFragment = %relay(`
  fragment RegisterPage_query on Query {
    id
    currentUser {
      email
    }
  }
`)

module RegisterMutation = %relay(`
  mutation RegisterPage_RegisterMutation($input: RegisterInput!) {
    register(input: $input) {
      boolean
      messages {
        message
      }
    }
  }
`)

@react.component
let make = (~fragmentRefs) => {
  let fragment = QueryFragment.use(fragmentRefs)
  let (mutate, isMutating) = RegisterMutation.use()

  let email = Common.State.useState(() => "")
  let password = Common.State.useState(() => "")

  isMutating
    ? <Spinner />
    : switch fragment.currentUser {
      | None =>
        <Main>
          <h1> {`Register`->React.string} </h1>
          <h3> {`Register with email`->React.string} </h3>
          <form
            onSubmit={e => {
              e->JsxEvent.Form.preventDefault
              let _ = mutate(
                ~variables={
                  input: RelaySchemaAssets_graphql.make_RegisterInput(
                    ~email=email.value,
                    ~pass=password.value,
                    (),
                  ),
                },
              )(
                ~updater=(store, _) => {
                  // stale all the data in the store
                  store->RescriptRelay.RecordSourceSelectorProxy.invalidateStore
                },
                ~onCompleted=(v1, _) => {
                  switch v1.register {
                  | Some({boolean: Some(true)}) =>
                    // refresh the store upon renav
                    RescriptReactRouter.push("/login")

                  // note that this pattern match WILL not match multiply errored items, but it is succinct
                  | Some({boolean: Some(false), messages: Some([Some({message})])})
                    if message->RescriptCore.String.trim != "" => {
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
                    <input type_="text" value={email.value} onChange={email.onChange} />
                  </td>
                </tr>
                <tr>
                  <th> {`Password:`->React.string} </th>
                  <td>
                    <input type_="password" value={password.value} onChange={password.onChange} />
                  </td>
                </tr>
              </tbody>
            </table>
            //{this.state.error ? <p> {this.state.error} </p> : null}
            <button
              type_="submit"
              disabled={email.value->Common.isBlank || password.value->Common.isBlank}>
              {`Register`->React.string}
            </button>
          </form>
        </Main>
      | Some(_) => `You are already registered and logged in!`->React.string
      }
}
