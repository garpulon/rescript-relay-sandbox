module QueryFragment = %relay(`
  fragment TopicPage_query on Query @argumentDefinitions(topic: { type: "ID!" }) {
    currentUser {
      isAdmin
    }
    topic: topicById(id: $topic) {
      ...TopicItem_topic
      ...CreateNewReplyForm_topic
      createdAt
      title
      body
      forum {
        name
        slug
      }
      user: author {
        avatarUrl
        email
      }
  
      posts(last: 1000) @connection(key: "TopicPage_posts") {
        __id
        edges {
          node {
            id
            ...PostItem_post
          }
        }
      }
    }
  }
`)

@react.component
let make = (~fragmentRefs) => {
  let fragment = QueryFragment.use(fragmentRefs)
  let topic = fragment.topic
  let currentUser = fragment.currentUser

  switch topic {
  | Some({forum: Some(forum), user: Some(user)} as topic) =>
    <Main>
      <div className="Forum-header">
        <Link to={`/forums/${forum.slug}/`}> {forum.name->React.string} </Link>
      </div>
      <h1 className="Topic-header"> {topic.title->React.string} </h1>
      <section className="Posts-container">
        <article className="PostItem">
          <div className="PostItem-meta PostItem-user PostItem-user--with-avatar">
            <img
              alt=""
              className="PostItem-avatar"
              src={user.avatarUrl->Option.getWithDefault(Common.avatarImgFallback)}
            />
            {user.email->React.string}
          </div>
          <div>
            <time className="PostItem-date"> {topic.createdAt->React.string} </time>
            <p className="PostItem-body"> {topic.body->React.string} </p>
          </div>
        </article>
        {topic.posts.edges->Array.length > 0
          ? topic.posts.edges
            ->Array.map(({node: {id: key, fragmentRefs: post} as node}) => {
              let _ = RescriptCore.Console.log(node)
              <PostItem key post />
            })
            ->React.array
          : <div>
              {`There are no replies yet!`->React.string}
              {switch currentUser {
              | Some({isAdmin: true}) => "Create one below..."->React.string
              | Some({isAdmin: false}) =>
                "Please check back later or contact an admin."->React.string
              | None =>
                <span>
                  {`Perhaps you need to`->React.string}
                  <Link to="/login"> {`log in`->React.string} </Link>
                  {`?`->React.string}
                </span>
              }}
            </div>}
      </section>
      {currentUser->Option.isSome
        ? <div>
            <h2> {`Reply to this topic`->React.string} </h2>
            <CreateNewReplyForm fragmentRefs=topic.fragmentRefs connectionID=topic.posts.__id />
          </div>
        : React.null}
    </Main>
  | _ => {
      let _ = RescriptCore.Console.log(topic)
      `Topic not found or malformed`->React.string
    }
  }
}
