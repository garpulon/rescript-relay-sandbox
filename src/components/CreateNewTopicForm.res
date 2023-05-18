module CreateTopicMutation = %relay(`
  mutation CreateNewTopicForm_CreateTopicMutation(
    $input: CreateTopicInput!
    $connections: [ID!]!
  ) {
    createTopic(input: $input) {
      topic @appendNode(connections: $connections, edgeTypeName: "TopicsEdge") {
        id
        title
        body
        forumId
        ...TopicItem_topic
      }
    }
  }
`)

module ForumFragment = %relay(`
  fragment CreateNewTopicForm_forum on Forum {
    rowId
  }
`)

@react.component
let make = (~connectionID, ~fragmentRefs) => {
  let (mutate, isMutating) = CreateTopicMutation.use()
  let forum = ForumFragment.use(fragmentRefs)

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
            input: RelaySchemaAssets_graphql.make_CreateTopicInput(
              ~topic=RelaySchemaAssets_graphql.make_TopicInput(
                ~title=name.value,
                ~body=description.value,
                ~forumId=forum.rowId,
                (),
              ),
              (),
            ),
            connections: [connectionID],
          },
        )()
      }}>
      <table>
        <tbody>
          <tr>
            <th> {`Topic Name`->React.string} </th>
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
        {(canSubmit ? `Create Topic` : `Not filled out`)->React.string}
      </button>
    </form>
  </React.Fragment>
}
