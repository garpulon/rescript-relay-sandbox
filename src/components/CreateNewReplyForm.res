module CreatePostMutation = %relay(`
  mutation CreateNewReplyForm_CreatePostMutation(
    $input: CreatePostInput!
    $connections: [ID!]!
  ) {
    createPost(input: $input) {
      post @appendNode(connections: $connections, edgeTypeName: "PostsEdge") {
        id
        body
        topicId
        ...PostItem_post
      }
    }
  }
`)

module TopicFragment = %relay(`
  fragment CreateNewReplyForm_topic on Topic {
    __id
    id
    rowId
  }
`)

@react.component
let make = (~fragmentRefs, ~connectionID) => {
  let (mutate, isMutating) = CreatePostMutation.use()
  let topic = TopicFragment.use(fragmentRefs)
  let body = Common.State.useState(() => "")
  RescriptCore.Console.log(topic.__id)

  <React.Fragment>
    <form
      onSubmit={e => {
        e->JsxEvent.Form.preventDefault
        let _ = mutate(
          ~variables={
            input: RelaySchemaAssets_graphql.make_CreatePostInput(
              ~post=RelaySchemaAssets_graphql.make_PostInput(
                ~body=body.value,
                ~topicId=topic.rowId,
                (),
              ),
              (),
            ),
            connections: [connectionID],
          },
          ~onCompleted={
            (_, _) => {
              let _ = body.set(_ => "")
            }
          },
        )()
      }}>
      <table>
        <tbody>
          <tr>
            <th> {`Reply`->React.string} </th>
            <td>
              <input type_="text" value={body.value} onChange={body.onChange} />
            </td>
          </tr>
        </tbody>
      </table>
      <button disabled={isMutating} type_="submit"> {`Submit`->React.string} </button>
    </form>
  </React.Fragment>
}
