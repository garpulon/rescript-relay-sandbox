module ForumFragment = %relay(`
  fragment ForumItem_forum on Forum {
    name
    description
    slug
  }
`)

@react.component
let make = (~fragmentRefs) => {
  let forum = ForumFragment.use(fragmentRefs)

  <div className="ForumItem">
    <h1 className="ForumItem-name">
      <Link to={`/forums/${forum.slug}`}> {forum.name->React.string} </Link>
    </h1>
    {forum.description->RescriptCore.String.trim == ""
      ? React.null
      : <div className="ForumItem-description"> {forum.description->React.string} </div>}
    //{currentUser && currentUser.isAdmin ? <div className="ForumItem-tools"> [edit] </div> : null}
  </div>
}
