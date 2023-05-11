module ForumFragment = %relay(`
  fragment ForumItem_forum on Forum {
    name
    description
    slug
  }
`)

@react.component
let make = (~forum) => {
  let forum = ForumFragment.use(forum)

  <div className="ForumItem">
    <h1 className="ForumItem-name">
      <a href={`/forums/${forum.slug}`}> {forum.name->React.string} </a>
    </h1>
    {forum.description->Js.String2.trim == ""
      ? React.null
      : <div className="ForumItem-description"> {forum.description->React.string} </div>}
    //{currentUser && currentUser.isAdmin ? <div className="ForumItem-tools"> [edit] </div> : null}
  </div>
}
