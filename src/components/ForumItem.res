module QueryFragment = %relay(`
  fragment ForumItem_query on Query {
    currentUser {
      isAdmin
    }
  }
`)

module ForumFragment = %relay(`
  fragment ForumItem_forum on Forum {
    name
    description
    slug
  }
`)

@react.component
let make = (~forum, ~query) => {
  let forum = ForumFragment.use(forum)
  let fragment = QueryFragment.use(query)

  <div className="ForumItem">
    <h1 className="ForumItem-name">
      <Link to={`/forums/${forum.slug}`}> {forum.name->React.string} </Link>
    </h1>
    {forum.description->RescriptCore.String.trim == ""
      ? React.null
      : <div className="ForumItem-description"> {forum.description->React.string} </div>}
    {switch fragment.currentUser {
    | Some({isAdmin: true}) => <div className="ForumItem-tools"> {`[edit]`->React.string} </div>
    | _ => React.null
    }}
  </div>
}
