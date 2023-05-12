module QueryFragment = %relay(`
  fragment ForumPage_query on Query
  @argumentDefinitions(slug: { type: "String!" }) {
    currentUser {
      id
      isAdmin
      #...ForumItem_CurrentUserFragment
    }
  
    forum: forumBySlug(slug: $slug) {
      name
      slug
      description
      topics {
        nodes {
          id
          ...TopicItem_topic
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
          {forum.topics.nodes->Array.length > 0
            ? forum.topics.nodes
              ->Array.map(node => {
                <React.Fragment key=node.id>
                  <TopicItem key={node.id} fragmentRefs={node.fragmentRefs} forum={forum} />
                </React.Fragment>
              })
              ->React.array
            : <tr>
                <td>
                  {`There are no topics yet!`->React.string}
                  /*
                  {currentUser ? (
                    currentUser.isAdmin ? (
                      "Create one below..."
                    ) : (
                      "Please check back later or contact an admin."
                    )
                  ) : (
                    <span>
                      Perhaps you need to <Link to="/login">log in</Link>?
                    </span>
                  )}*/
                </td>
              </tr>}
        </tbody>
      </table>
      {switch currentUser {
      | Some(_) =>
        <div>
          <h2> {`Create new topic`->React.string} </h2>
          /* <CreateNewTopicForm
            data={data}
            onCreateTopic={forum => {
              // TODO: alter the cache
              data.refetch()
            }}
          />*/
        </div>
      | None => React.null
      }}
    </Main>
  }
}
