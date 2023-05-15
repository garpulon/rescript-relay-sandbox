module TopicFragment = %relay(`
  fragment TopicItem_topic on Topic {
    rowId
    id
    title
    body
    user: author {
      avatarUrl
      email
    }
    posts {
      totalCount
    }
    updatedAt
  }
`)

@react.component
let make = (~fragmentRefs, ~forum: ForumPage_query_graphql.Types.fragment_forum) => {
  let topic = TopicFragment.use(fragmentRefs)

  <tr className="TopicItem">
    <td className="TopicItem-title">
      <Link to={`/forums/${forum.slug}/${topic.id}`}> {topic.title->React.string} </Link>
    </td>
    <td className="TopicItem-user">
      {switch topic.user {
      | Some({email}) => email->React.string
      | _ => React.null
      }}
    </td>
    <td className="TopicItem-replies"> {topic.posts.totalCount->React.int} </td>
    <td className="TopicItem-date"> {topic.updatedAt->React.string} </td>
  </tr>
}
