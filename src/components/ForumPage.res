module QueryFragment = %relay(`
  fragment ForumPage_query on Query
  @argumentDefinitions(slug: { type: "String!" }) {
    currentUser {
      isAdmin
    }
  
    forum: forumBySlug(slug: $slug) {
      ...CreateNewTopicForm_forum
      name
      slug
      description
      topics(last: 1000) @connection(key: "ForumPage_topics") {
        __id
        edges {
          node {
            id
            ...TopicItem_topic
          }
        }
      }
    }
  }
`)

@react.component
let make = (~fragmentRefs) => {
  let fragment = QueryFragment.use(fragmentRefs)
  let forum = fragment.forum
  let currentUser = fragment.currentUser

  switch forum {
  | None => `Forum not found`->React.string

  | Some(forum) =>
    <Main>
      <div className="Forum-header"> {forum.name->React.string} </div>
      <div className="Forum-description">
        {`Welcome to ${forum.name}! ${forum.description}`->React.string}
      </div>
      <table className="Topics-container">
        <thead>
          <tr className="Topics-TopicItemHeader">
            <th> {`Topic`->React.string} </th>
            <th> {`Author`->React.string} </th>
            <th> {`Replies`->React.string} </th>
            <th> {`Last post`->React.string} </th>
          </tr>
        </thead>
        <tbody>
          {forum.topics.edges->Array.length > 0
            ? forum.topics.edges
              ->Array.map(({node: {id: key, fragmentRefs}}) => {
                <React.Fragment key>
                  <TopicItem key fragmentRefs forum={forum} />
                </React.Fragment>
              })
              ->React.array
            : <tr>
                <td>
                  {`There are no topics yet!`->React.string}
                  {switch fragment.currentUser {
                  | Some({isAdmin: true}) => "Create one below..."->React.string
                  | Some({isAdmin: false}) =>
                    "Please check back later or contact an admin."->React.string
                  | None =>
                    <span>
                      {`Perhaps you need to `->React.string}
                      <Link to="/login"> {`log in`->React.string} </Link>
                      {`?`->React.string}
                    </span>
                  }}
                </td>
              </tr>}
        </tbody>
      </table>
      {switch currentUser {
      | Some(_) =>
        <div>
          <h2> {`Create new topic`->React.string} </h2>
          <CreateNewTopicForm fragmentRefs=forum.fragmentRefs connectionID=forum.topics.__id />
        </div>
      | None => React.null
      }}
    </Main>
  }
}
