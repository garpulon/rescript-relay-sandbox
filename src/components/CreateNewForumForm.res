module CreateForumMutation = %relay(`
  mutation CreateNewForumForm_CreateForumMutation(
    $input: CreateForumInput!
    $connections: [ID!]!
  ) {
    createForum(input: $input) {
      query {
        ...HomePage_query
      }
      forum @appendNode(connections: $connections, edgeTypeName: "ForumsEdge") {
        ...ForumItem_forum
      }
      messages {
        message
      }
    }
  }
`)

@react.component
let make = (~connectionID) => {
  let (mutate, isMutating) = CreateForumMutation.use()

  let slug = Common.State.useState(() => "")
  let name = Common.State.useState(() => "")
  let description = Common.State.useState(() => "")

  let canSubmit = {
    open Common
    !(slug.value->isBlank || name.value->isBlank || description.value->isBlank)
  }

  <React.Fragment>
    <form
      onSubmit={e => {
        e->JsxEvent.Form.preventDefault
        let _ = mutate(
          ~variables={
            input: RelaySchemaAssets_graphql.make_CreateForumInput(
              ~forum=RelaySchemaAssets_graphql.make_ForumInput(
                ~name=name.value,
                ~description=description.value,
                ~slug=slug.value,
                (),
              ),
              (),
            ),
            connections: connectionID->Option.mapWithDefault([], a => [a]),
          },
        )()
      }}>
      <table>
        <tbody>
          <tr>
            <th> {`Name`->React.string} </th>
            <td>
              <input
                disabled={isMutating} type_="text" value={name.value} onChange={name.onChange}
              />
            </td>
          </tr>
          <tr>
            <th> {`Url`->React.string} </th>
            <td>
              <input
                disabled={isMutating} type_="text" value={slug.value} onChange={slug.onChange}
              />
            </td>
          </tr>
          <tr>
            <th> {`Description`->React.string} </th>
            <td>
              <input
                disabled={isMutating}
                type_="text"
                value={description.value}
                onChange={description.onChange}
              />
            </td>
          </tr>
        </tbody>
      </table>
      <button disabled={isMutating || !canSubmit} type_="submit">
        {(canSubmit ? `Create Forum` : `Not filled out`)->React.string}
      </button>
    </form>
  </React.Fragment>
}
